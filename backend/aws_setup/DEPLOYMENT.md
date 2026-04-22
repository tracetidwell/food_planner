# AWS Hosting Guide for Meal Planner App

## Architecture Overview

```
[Mobile App] → [App Runner] (FastAPI backend, auto-HTTPS)
                    ↓
              [RDS PostgreSQL] (shared instance, meal_planner database)
```

App Runner provides automatic HTTPS, load balancing, and scaling with no ALB or CloudFront needed.

---

## 1. Prerequisites

- AWS account with CLI configured (`aws configure`)
- Docker installed locally for building images
- Existing RDS PostgreSQL instance (`five-three-one-db`) — we add a new database on it
- Python 3.11+

---

## 2. Database: Create `meal_planner` on Existing RDS

The RDS instance (`five-three-one-db`) is already running. We just need to create a new database on it.

### 2a. Set up bastion access (if not already done)

If you already have a bastion from the 531 app, skip to 2b.

```bash
cd aws_setup
bash setup_bastion.sh
```

### 2b. Create the database

```bash
# Start port forwarding via the bastion
bash connect_db.sh

# In another terminal, connect and create the database:
bash create_database.sh
```

Or manually:
```bash
PGPASSWORD=<YOUR_PASSWORD> psql -h localhost -U postgres -c "CREATE DATABASE meal_planner;"
```

---

## 3. Secrets: AWS Secrets Manager

Create a `backend/.env` file with the following values:
```
MASTER_USER_PASSWORD=<your_rds_password>
RDS_ENDPOINT=<your_rds_endpoint>
SECRET_KEY=<generate_with_openssl_rand_hex_32>
ENCRYPTION_KEY=<generate_with_openssl_rand_hex_32>
OPENAI_API_KEY=<your_openai_api_key>
```

Then run the initialization script:
```bash
cd aws_setup
bash initialize_secret_manager.sh
```

This creates a secret `meal-planner-app/production` with:
- `DATABASE_URL` — PostgreSQL connection string
- `SECRET_KEY` — App secret key
- `ENCRYPTION_KEY` — Data encryption key
- `OPENAI_API_KEY` — OpenAI API key

Generate strong keys:
```bash
openssl rand -hex 32
```

---

## 4. Backend: ECR + App Runner

### 4a. Create ECR repository

```bash
aws ecr create-repository --repository-name meal-planner-backend
```

### 4b. Authenticate with ECR

```bash
cd aws_setup
bash authenticate.sh
```

### 4c. Build and push the Docker image

```bash
cd aws_setup
bash deploy_backend.sh
```

This builds the image, tags it, and pushes to ECR.

### 4d. Create the App Runner service (first time only)

```bash
cd aws_setup
bash create_app_runner.sh
```

This creates:
- `AppRunnerECRAccessRole` (shared, reused if exists) — lets App Runner pull from ECR
- `MealPlannerInstanceRole` — lets the running container read from Secrets Manager
- `meal-planner-backend` App Runner service

### 4e. Get your App Runner URL

```bash
aws apprunner list-services \
  --query 'ServiceSummaryList[?ServiceName==`meal-planner-backend`].ServiceUrl' \
  --output text
```

The URL looks like `https://xxxxx.us-east-1.awsapprunner.com`.

### 4f. Run migrations

Start port forwarding via the bastion, then run:
```bash
cd backend
DATABASE_URL=postgresql://postgres:<PASSWORD>@localhost:5432/meal_planner \
  python -m alembic upgrade head
```

---

## 5. Mobile App Configuration

Update the API URL in your Flutter app to point to the App Runner URL:

```bash
flutter build apk --release \
  --dart-define=API_BASE_URL=https://<APP_RUNNER_URL>/api/v1
```

---

## 6. Security Checklist

Before going live:

- [ ] RDS is **not** publicly accessible (only reachable via bastion/App Runner VPC connector)
- [ ] SECRET_KEY is a strong random value stored in Secrets Manager
- [ ] ENCRYPTION_KEY is a strong random value stored in Secrets Manager
- [ ] OPENAI_API_KEY is stored in Secrets Manager (not in code)
- [ ] Remove `--reload` from Dockerfile CMD
- [ ] Set `ACCESS_TOKEN_EXPIRE_MINUTES` appropriately
- [ ] RDS encryption and automated backups are enabled

---

## 7. Estimated Monthly Cost

| Service | Spec | ~Cost |
|---------|------|-------|
| RDS PostgreSQL | db.t3.micro, 20GB (shared) | $0 (already running) |
| App Runner | 0.25 vCPU, 0.5GB | $5-15 |
| Secrets Manager | 4 secrets | $2 |
| ECR | Image storage | $1 |
| **Total** | | **~$8-18/mo** |

Note: RDS cost is shared with other apps on the same instance.

---

## 8. Deployment Updates

For subsequent deployments, just run:

```bash
cd aws_setup
bash authenticate.sh
bash deploy_backend.sh
```

Or push to `main` branch to trigger the GitHub Actions workflow.

---

## 9. Useful Commands

```bash
# Check App Runner service status
aws apprunner list-services

# View App Runner logs
aws apprunner list-operations --service-arn <SERVICE_ARN>

# Connect to database
cd aws_setup && bash connect_db.sh

# Stop bastion (save money when not debugging)
aws ec2 stop-instances --instance-ids <INSTANCE_ID>
```
