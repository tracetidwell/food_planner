# AWS Deployment - Quick Start

Get your Meal Planner API deployed to AWS in 10 minutes.

## Prerequisites

- AWS Account
- AWS CLI configured with credentials
- Terraform installed
- Docker installed

## 1. Generate Secrets

```bash
# Generate JWT secret
openssl rand -hex 32

# Generate encryption key
openssl rand -hex 32

# Get your OpenAI API key from: https://platform.openai.com/api-keys
```

## 2. Configure

```bash
cd backend/infrastructure/terraform
cp terraform.tfvars.example terraform.tfvars

# Edit terraform.tfvars and add:
# - jwt_secret_key (from step 1)
# - encryption_key (from step 1)
# - openai_api_key (from OpenAI)
```

## 3. Deploy

```bash
cd ..
./deploy.sh
```

That's it! The script will:
- ✅ Create AWS infrastructure (VPC, ECS, ALB, etc.)
- ✅ Build and push Docker image
- ✅ Deploy your API
- ✅ Show you the API URL

## 4. Test

```bash
# Get your API URL
cd terraform
ALB_DNS=$(terraform output -raw alb_dns_name)

# Test health
curl http://$ALB_DNS/health

# View docs
open http://$ALB_DNS/docs
```

## Common Commands

```bash
# View logs
./logs.sh

# Check status
./status.sh

# Update deployment
./deploy.sh

# Destroy everything
cd terraform && terraform destroy
```

## Estimated Cost

~$120-140/month for production setup with high availability

**Reduce to ~$55/month:**
- Edit `terraform/variables.tf`
- Change `desired_count = 1` (one task instead of two)
- Edit `terraform/vpc.tf`
- Reduce NAT gateways to 1

## Need Help?

See detailed guide: [AWS_DEPLOYMENT.md](./AWS_DEPLOYMENT.md)

## CI/CD with GitHub Actions

Already configured! Just push to `main`:

```bash
git add .
git commit -m "Deploy to AWS"
git push origin main
```

Add these secrets to GitHub:
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
