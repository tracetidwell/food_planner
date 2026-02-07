#!/bin/bash
set -e

# Meal Planner AWS Deployment Script

echo "🚀 Meal Planner AWS Deployment"
echo "================================"
echo ""

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "❌ AWS CLI is not installed. Please install it first:"
    echo "   https://aws.amazon.com/cli/"
    exit 1
fi

# Check if Terraform is installed
if ! command -v terraform &> /dev/null; then
    echo "❌ Terraform is not installed. Please install it first:"
    echo "   https://www.terraform.io/downloads"
    exit 1
fi

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install it first:"
    echo "   https://docs.docker.com/get-docker/"
    exit 1
fi

echo "✅ Prerequisites check passed"
echo ""

# Get current directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TERRAFORM_DIR="$SCRIPT_DIR/terraform"
BACKEND_DIR="$(dirname "$SCRIPT_DIR")"

# Step 1: Configure Terraform variables
echo "📝 Step 1: Configure Terraform variables"
echo "=========================================="

if [ ! -f "$TERRAFORM_DIR/terraform.tfvars" ]; then
    echo "Creating terraform.tfvars from example..."
    cp "$TERRAFORM_DIR/terraform.tfvars.example" "$TERRAFORM_DIR/terraform.tfvars"
    echo ""
    echo "⚠️  Please edit $TERRAFORM_DIR/terraform.tfvars with your values:"
    echo "   - jwt_secret_key (generate with: openssl rand -hex 32)"
    echo "   - encryption_key (generate with: openssl rand -hex 32)"
    echo "   - openai_api_key (your OpenAI API key)"
    echo ""
    read -p "Press Enter after editing terraform.tfvars..."
fi

# Step 2: Initialize Terraform
echo ""
echo "🔧 Step 2: Initialize Terraform"
echo "================================"
cd "$TERRAFORM_DIR"
terraform init

# Step 3: Plan infrastructure
echo ""
echo "📋 Step 3: Review infrastructure plan"
echo "======================================"
terraform plan

echo ""
read -p "Do you want to apply this plan? (yes/no): " confirm
if [ "$confirm" != "yes" ]; then
    echo "Deployment cancelled."
    exit 0
fi

# Step 4: Apply infrastructure
echo ""
echo "🏗️  Step 4: Creating AWS infrastructure"
echo "========================================"
terraform apply -auto-approve

# Get outputs
ECR_REPO=$(terraform output -raw ecr_repository_url)
ECS_CLUSTER=$(terraform output -raw ecs_cluster_name)
ECS_SERVICE=$(terraform output -raw ecs_service_name)
ALB_DNS=$(terraform output -raw alb_dns_name)

echo ""
echo "✅ Infrastructure created successfully!"
echo ""
echo "📦 ECR Repository: $ECR_REPO"
echo "🎯 ECS Cluster: $ECS_CLUSTER"
echo "🔄 ECS Service: $ECS_SERVICE"
echo "🌐 Load Balancer: $ALB_DNS"
echo ""

# Step 5: Build and push Docker image
echo "🐳 Step 5: Build and push Docker image"
echo "======================================="

# Login to ECR
echo "Logging into Amazon ECR..."
aws ecr get-login-password --region us-east-1 | \
    docker login --username AWS --password-stdin $ECR_REPO

# Build image
echo "Building Docker image..."
cd "$BACKEND_DIR"
docker build -t meal-planner-backend:latest .

# Tag image
echo "Tagging image..."
docker tag meal-planner-backend:latest $ECR_REPO:latest

# Push image
echo "Pushing image to ECR..."
docker push $ECR_REPO:latest

echo ""
echo "✅ Docker image pushed successfully!"
echo ""

# Step 6: Force new deployment
echo "🔄 Step 6: Deploying to ECS"
echo "============================"

aws ecs update-service \
    --cluster $ECS_CLUSTER \
    --service $ECS_SERVICE \
    --force-new-deployment \
    --region us-east-1

echo "Waiting for service to stabilize (this may take 2-3 minutes)..."
aws ecs wait services-stable \
    --cluster $ECS_CLUSTER \
    --services $ECS_SERVICE \
    --region us-east-1

echo ""
echo "✅ Service deployed successfully!"
echo ""

# Step 7: Verify deployment
echo "🔍 Step 7: Verifying deployment"
echo "================================"

sleep 10  # Wait a bit for ALB to start routing

echo "Testing health endpoint..."
if curl -s -f http://$ALB_DNS/health > /dev/null; then
    echo "✅ Health check passed!"
else
    echo "⚠️  Health check failed. Service might still be starting up."
    echo "   Check CloudWatch logs for details."
fi

echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║            🎉 Deployment Complete! 🎉                      ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "Your API is now live at:"
echo ""
echo "  🌐 API URL:  http://$ALB_DNS"
echo "  📚 API Docs: http://$ALB_DNS/docs"
echo "  ❤️  Health:  http://$ALB_DNS/health"
echo ""
echo "Next steps:"
echo "  1. Test your API at the URLs above"
echo "  2. Set up a custom domain (optional)"
echo "  3. Configure SSL/TLS certificate (optional)"
echo "  4. Monitor logs: aws logs tail /ecs/meal-planner --follow"
echo ""
echo "To update the deployment:"
echo "  ./deploy.sh"
echo ""
echo "To destroy infrastructure:"
echo "  cd terraform && terraform destroy"
echo ""
