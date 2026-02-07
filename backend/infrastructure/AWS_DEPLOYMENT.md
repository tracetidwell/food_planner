# AWS Deployment Guide

Complete guide for deploying the Meal Planner Backend to AWS using ECS Fargate.

## Architecture

The deployment creates:

- **ECS Fargate Cluster**: Serverless container orchestration
- **Application Load Balancer**: HTTP load balancing and health checks
- **ECR Repository**: Docker image storage
- **Secrets Manager**: Secure secret storage (API keys, JWT secrets)
- **VPC**: Isolated network with public/private subnets
- **CloudWatch Logs**: Centralized logging
- **Auto Scaling**: Automatic scaling based on CPU/Memory
- **NAT Gateways**: Outbound internet access for private subnets

## Prerequisites

### 1. Install Required Tools

```bash
# AWS CLI
# macOS
brew install awscli

# Linux
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Windows
# Download from: https://aws.amazon.com/cli/

# Terraform
# macOS
brew install terraform

# Linux
wget https://releases.hashicorp.com/terraform/1.6.0/terraform_1.6.0_linux_amd64.zip
unzip terraform_1.6.0_linux_amd64.zip
sudo mv terraform /usr/local/bin/

# Windows
# Download from: https://www.terraform.io/downloads

# Docker (already installed for backend development)
```

### 2. Configure AWS Credentials

```bash
# Configure AWS CLI
aws configure

# Enter your credentials:
# AWS Access Key ID: YOUR_ACCESS_KEY
# AWS Secret Access Key: YOUR_SECRET_KEY
# Default region: us-east-1
# Default output format: json
```

**Get AWS Credentials:**
1. Log into AWS Console
2. Go to IAM → Users → Your User
3. Security credentials → Create access key
4. Choose "CLI" as use case
5. Copy Access Key ID and Secret Access Key

### 3. Generate Secrets

```bash
# Generate JWT secret key
openssl rand -hex 32

# Generate encryption key
openssl rand -hex 32
```

## Quick Start Deployment

### Option 1: Automated Deployment Script (Recommended)

```bash
cd backend/infrastructure
./deploy.sh
```

The script will:
1. Check prerequisites
2. Initialize Terraform
3. Show infrastructure plan
4. Create AWS resources
5. Build and push Docker image
6. Deploy to ECS
7. Verify deployment

### Option 2: Manual Deployment

#### Step 1: Configure Terraform Variables

```bash
cd backend/infrastructure/terraform

# Copy example file
cp terraform.tfvars.example terraform.tfvars

# Edit with your values
nano terraform.tfvars
```

```hcl
# terraform.tfvars
aws_region  = "us-east-1"
environment = "prod"

jwt_secret_key = "your-generated-jwt-secret"
encryption_key = "your-generated-encryption-key"
openai_api_key = "sk-proj-your-openai-api-key"

desired_count    = 2
container_cpu    = 512
container_memory = 1024
```

#### Step 2: Initialize Terraform

```bash
terraform init
```

#### Step 3: Review Plan

```bash
terraform plan
```

This will show:
- 30+ resources to be created
- Estimated costs
- Resource dependencies

#### Step 4: Apply Infrastructure

```bash
terraform apply
```

Type `yes` when prompted. This takes 3-5 minutes.

#### Step 5: Get ECR Repository URL

```bash
ECR_REPO=$(terraform output -raw ecr_repository_url)
echo $ECR_REPO
```

#### Step 6: Build and Push Docker Image

```bash
# Login to ECR
aws ecr get-login-password --region us-east-1 | \
    docker login --username AWS --password-stdin $ECR_REPO

# Build image
cd ../../
docker build -t meal-planner-backend:latest .

# Tag for ECR
docker tag meal-planner-backend:latest $ECR_REPO:latest

# Push to ECR
docker push $ECR_REPO:latest
```

#### Step 7: Deploy to ECS

```bash
cd infrastructure/terraform

ECS_CLUSTER=$(terraform output -raw ecs_cluster_name)
ECS_SERVICE=$(terraform output -raw ecs_service_name)

# Force new deployment with latest image
aws ecs update-service \
    --cluster $ECS_CLUSTER \
    --service $ECS_SERVICE \
    --force-new-deployment \
    --region us-east-1

# Wait for deployment to complete
aws ecs wait services-stable \
    --cluster $ECS_CLUSTER \
    --services $ECS_SERVICE \
    --region us-east-1
```

#### Step 8: Get Your API URL

```bash
terraform output alb_url
# Output: http://meal-planner-alb-1234567890.us-east-1.elb.amazonaws.com
```

## Post-Deployment

### Verify Deployment

```bash
# Check deployment status
./status.sh

# Test health endpoint
ALB_DNS=$(cd terraform && terraform output -raw alb_dns_name)
curl http://$ALB_DNS/health

# View API documentation
open http://$ALB_DNS/docs
```

### View Logs

```bash
# Real-time logs
./logs.sh

# Or directly with AWS CLI
aws logs tail /ecs/meal-planner --follow
```

### Monitor Resources

```bash
# ECS Service
aws ecs describe-services \
    --cluster meal-planner-cluster \
    --services meal-planner-service

# Task status
aws ecs list-tasks \
    --cluster meal-planner-cluster \
    --service-name meal-planner-service

# CloudWatch metrics
aws cloudwatch get-metric-statistics \
    --namespace AWS/ECS \
    --metric-name CPUUtilization \
    --dimensions Name=ServiceName,Value=meal-planner-service \
    --start-time 2024-01-01T00:00:00Z \
    --end-time 2024-01-01T23:59:59Z \
    --period 3600 \
    --statistics Average
```

## Continuous Deployment with GitHub Actions

### Setup

1. **Add AWS Credentials to GitHub Secrets:**
   - Go to your repo → Settings → Secrets and variables → Actions
   - Add secrets:
     - `AWS_ACCESS_KEY_ID`
     - `AWS_SECRET_ACCESS_KEY`

2. **Enable GitHub Actions:**
   - The workflow file is already created at `.github/workflows/deploy-aws.yml`
   - It automatically deploys on push to `main` branch

3. **Trigger Deployment:**
   ```bash
   git add .
   git commit -m "Deploy to AWS"
   git push origin main
   ```

The workflow will:
1. Run tests
2. Build Docker image
3. Push to ECR
4. Deploy to ECS
5. Verify health

## Updating Your Deployment

### Update Application Code

```bash
# Make code changes
# Commit to main branch
git push origin main

# GitHub Actions will automatically deploy
# Or manually trigger:
./deploy.sh
```

### Update Infrastructure

```bash
cd infrastructure/terraform

# Modify .tf files
# Then apply changes
terraform plan
terraform apply
```

### Update Secrets

```bash
# Update in Secrets Manager
aws secretsmanager update-secret \
    --secret-id meal-planner/prod/openai-api-key \
    --secret-string "new-api-key"

# Force new deployment to pick up changes
aws ecs update-service \
    --cluster meal-planner-cluster \
    --service meal-planner-service \
    --force-new-deployment
```

## Cost Optimization

### Estimated Monthly Costs

- **ECS Fargate**: ~$30-50/month (2 tasks, 512 CPU, 1GB RAM)
- **Application Load Balancer**: ~$20/month
- **NAT Gateway**: ~$32/month (per gateway, 2 gateways = $64)
- **Data Transfer**: Variable (minimal for API)
- **CloudWatch Logs**: ~$5/month (7-day retention)
- **Secrets Manager**: ~$1/month (3 secrets)

**Total**: ~$120-140/month

### Cost Reduction Tips

1. **Use Single NAT Gateway** (not HA):
   ```hcl
   # In vpc.tf, reduce to 1 NAT gateway
   count = 1  # instead of 2
   ```
   Saves: ~$32/month

2. **Reduce ECS Tasks** (for low traffic):
   ```hcl
   desired_count = 1  # instead of 2
   ```
   Saves: ~$15-25/month

3. **Use Spot Instances** (advanced):
   - Configure Fargate Spot in task definition
   - 70% cost savings, but tasks can be interrupted

4. **Consider AWS Free Tier**:
   - First 12 months include free tier for many services
   - 750 hours of EC2 (not Fargate, but can use EC2 instead)

## Custom Domain Setup (Optional)

### Using Route 53

1. **Register/Import Domain:**
   ```bash
   # If you have a domain
   aws route53 create-hosted-zone --name yourdomain.com --caller-reference $(date +%s)
   ```

2. **Get ALB DNS:**
   ```bash
   ALB_DNS=$(cd terraform && terraform output -raw alb_dns_name)
   ```

3. **Create CNAME Record:**
   ```bash
   HOSTED_ZONE_ID="YOUR_ZONE_ID"

   aws route53 change-resource-record-sets \
       --hosted-zone-id $HOSTED_ZONE_ID \
       --change-batch '{
         "Changes": [{
           "Action": "CREATE",
           "ResourceRecordSet": {
             "Name": "api.yourdomain.com",
             "Type": "CNAME",
             "TTL": 300,
             "ResourceRecords": [{"Value": "'$ALB_DNS'"}]
           }
         }]
       }'
   ```

### Add HTTPS (SSL/TLS)

1. **Request Certificate in ACM:**
   ```bash
   aws acm request-certificate \
       --domain-name api.yourdomain.com \
       --validation-method DNS
   ```

2. **Validate Certificate** (follow AWS Console instructions)

3. **Update ALB Listener** (uncomment in `alb.tf`):
   ```hcl
   resource "aws_lb_listener" "https" {
     load_balancer_arn = aws_lb.main.arn
     port              = 443
     protocol          = "HTTPS"
     ssl_policy        = "ELBSecurityPolicy-2016-08"
     certificate_arn   = "YOUR_CERTIFICATE_ARN"

     default_action {
       type             = "forward"
       target_group_arn = aws_lb_target_group.main.arn
     }
   }
   ```

4. **Apply Changes:**
   ```bash
   terraform apply
   ```

## Troubleshooting

### Service Won't Start

```bash
# Check ECS service events
aws ecs describe-services \
    --cluster meal-planner-cluster \
    --services meal-planner-service \
    --query 'services[0].events[:5]'

# Check task logs
./logs.sh

# Check task definition
aws ecs describe-task-definition \
    --task-definition meal-planner-backend
```

### Health Check Failing

```bash
# Check target health
aws elbv2 describe-target-health \
    --target-group-arn $(aws elbv2 describe-target-groups --query "TargetGroups[?contains(TargetGroupName, 'meal-planner')].TargetGroupArn" --output text)

# Test from within task
# SSH into running task (if enabled)
# curl localhost:8000/health
```

### Secrets Not Loading

```bash
# Verify secrets exist
aws secretsmanager list-secrets | grep meal-planner

# Check IAM permissions
aws iam get-role-policy \
    --role-name meal-planner-ecs-task-execution-role \
    --policy-name meal-planner-ecs-secrets-access
```

### High Costs

```bash
# Check NAT Gateway data transfer
aws cloudwatch get-metric-statistics \
    --namespace AWS/NATGateway \
    --metric-name BytesOutToDestination \
    --start-time 2024-01-01T00:00:00Z \
    --end-time 2024-01-31T23:59:59Z \
    --period 86400 \
    --statistics Sum

# Consider using VPC endpoints for AWS services
```

## Cleanup / Destroy

### Delete Everything

```bash
cd infrastructure/terraform
terraform destroy
```

Type `yes` to confirm. This will:
- Terminate ECS tasks
- Delete load balancer
- Delete VPC and subnets
- Delete CloudWatch logs (based on retention)
- Delete secrets (with 7-day recovery window)
- Delete ECR repository and images

**Note**: Some resources incur charges until fully deleted:
- NAT Gateway EIPs are released immediately
- Load balancer deletion takes a few minutes
- Secrets have a 7-day recovery window (still incur charges)

### Partial Cleanup (Keep Infrastructure)

```bash
# Scale down to 0 tasks
aws ecs update-service \
    --cluster meal-planner-cluster \
    --service meal-planner-service \
    --desired-count 0
```

This stops charges for:
- ECS Fargate compute
- But keeps infrastructure (ALB, NAT, etc.)

## Support

- **AWS Support**: Check AWS Console for service health
- **GitHub Issues**: For application bugs
- **Documentation**:
  - [AWS ECS](https://docs.aws.amazon.com/ecs/)
  - [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

## Next Steps

1. ✅ Deploy infrastructure with `./deploy.sh`
2. ✅ Verify API is working: `./status.sh`
3. ✅ Test API endpoints: `curl http://ALB_DNS/docs`
4. ✅ Set up GitHub Actions for CI/CD
5. ⬜ Configure custom domain (optional)
6. ⬜ Add HTTPS certificate (optional)
7. ⬜ Set up monitoring alerts
8. ⬜ Configure backup strategy
