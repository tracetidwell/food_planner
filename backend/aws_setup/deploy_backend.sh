#!/bin/bash
set -e

cd "$(dirname "$0")/../backend"

echo "Building Docker image..."
docker build --no-cache -t meal-planner-backend .

echo "Tagging image..."
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
docker tag meal-planner-backend:latest ${ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com/meal-planner-backend:latest

echo "Pushing to ECR..."
docker push ${ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com/meal-planner-backend:latest

echo "Getting service ARN..."
SERVICE_ARN=$(aws apprunner list-services \
  --query 'ServiceSummaryList[?ServiceName==`meal-planner-backend`].ServiceArn' \
  --output text)

if [ -z "$SERVICE_ARN" ] || [ "$SERVICE_ARN" == "None" ]; then
  echo "Error: App Runner service 'meal-planner-backend' not found."
  echo "Run create_app_runner.sh first to create the service."
  exit 1
fi

# Check current status
STATUS=$(aws apprunner describe-service --service-arn "$SERVICE_ARN" --query 'Service.Status' --output text)

if [ "$STATUS" == "CREATE_FAILED" ]; then
  echo "Error: Service is in CREATE_FAILED state. It must be recreated."
  echo "Run: bash create_app_runner.sh"
  echo "(It will delete the failed service and create a new one.)"
  exit 1
fi

# Wait for service to be in RUNNING state before deploying
echo "Checking service status..."
MAX_RETRIES=30
RETRY_INTERVAL=10

for i in $(seq 1 $MAX_RETRIES); do
  STATUS=$(aws apprunner describe-service --service-arn "$SERVICE_ARN" --query 'Service.Status' --output text)

  if [ "$STATUS" == "RUNNING" ]; then
    echo "Service is RUNNING. Starting deployment..."
    aws apprunner start-deployment --service-arn "$SERVICE_ARN"
    echo "Deployment started successfully!"
    exit 0
  elif [[ "$STATUS" == *"FAILED"* ]]; then
    echo "Error: Service is in $STATUS state. Cannot deploy."
    exit 1
  else
    echo "Service status: $STATUS (attempt $i/$MAX_RETRIES). Waiting ${RETRY_INTERVAL}s..."
    sleep $RETRY_INTERVAL
  fi
done

echo "Error: Service did not reach RUNNING state after $MAX_RETRIES attempts."
exit 1
