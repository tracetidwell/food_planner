#!/bin/bash
set -e

REGION="us-east-1"
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
APPRUNNER_ECR_ROLE_ARN="arn:aws:iam::${ACCOUNT_ID}:role/AppRunnerECRAccessRole"
APPRUNNER_INSTANCE_ROLE_ARN="arn:aws:iam::${ACCOUNT_ID}:role/MealPlannerInstanceRole"

# Reuse existing AppRunnerECRAccessRole (shared across apps)
echo "Checking for existing AppRunnerECRAccessRole..."
if aws iam get-role --role-name AppRunnerECRAccessRole &>/dev/null; then
  echo "AppRunnerECRAccessRole already exists, reusing."
else
  echo "Creating AppRunnerECRAccessRole..."
  aws iam create-role \
    --role-name AppRunnerECRAccessRole \
    --assume-role-policy-document '{
      "Version": "2012-10-17",
      "Statement": [{
        "Effect": "Allow",
        "Principal": {"Service": "build.apprunner.amazonaws.com"},
        "Action": "sts:AssumeRole"
      }]
    }'

  aws iam attach-role-policy \
    --role-name AppRunnerECRAccessRole \
    --policy-arn arn:aws:iam::aws:policy/service-role/AWSAppRunnerServicePolicyForECRAccess
fi

# Create instance role for meal planner (allows running container to access Secrets Manager)
echo "Checking for existing MealPlannerInstanceRole..."
if aws iam get-role --role-name MealPlannerInstanceRole &>/dev/null; then
  echo "MealPlannerInstanceRole already exists, reusing."
else
  echo "Creating MealPlannerInstanceRole..."
  aws iam create-role \
    --role-name MealPlannerInstanceRole \
    --assume-role-policy-document '{
      "Version": "2012-10-17",
      "Statement": [{
        "Effect": "Allow",
        "Principal": {"Service": "tasks.apprunner.amazonaws.com"},
        "Action": "sts:AssumeRole"
      }]
    }'
fi

# Grant instance role access to Secrets Manager (idempotent — overwrites if exists)
aws iam put-role-policy \
  --role-name MealPlannerInstanceRole \
  --policy-name SecretsManagerAccess \
  --policy-document "{
    \"Version\": \"2012-10-17\",
    \"Statement\": [{
      \"Effect\": \"Allow\",
      \"Action\": [\"secretsmanager:GetSecretValue\"],
      \"Resource\": \"arn:aws:secretsmanager:${REGION}:${ACCOUNT_ID}:secret:meal-planner-app/production*\"
    }]
  }"

echo "Waiting for IAM roles to propagate..."
sleep 15

# Delete existing failed service if present
EXISTING_ARN=$(aws apprunner list-services \
  --query 'ServiceSummaryList[?ServiceName==`meal-planner-backend`].ServiceArn' \
  --output text 2>/dev/null || true)

if [ -n "$EXISTING_ARN" ] && [ "$EXISTING_ARN" != "None" ]; then
  EXISTING_STATUS=$(aws apprunner describe-service --service-arn "$EXISTING_ARN" \
    --query 'Service.Status' --output text)

  if [ "$EXISTING_STATUS" == "CREATE_FAILED" ] || [ "$EXISTING_STATUS" == "DELETED" ]; then
    echo "Deleting failed service ($EXISTING_STATUS)..."
    aws apprunner delete-service --service-arn "$EXISTING_ARN"
    echo "Waiting for service deletion..."
    sleep 30
  elif [ "$EXISTING_STATUS" == "RUNNING" ]; then
    echo "Service already exists and is RUNNING. Use deploy_backend.sh to update."
    exit 0
  else
    echo "Service exists with status: $EXISTING_STATUS. Cannot proceed."
    echo "Wait for current operation to complete, or delete manually."
    exit 1
  fi
fi

# Verify VPC connector exists
VPC_CONNECTOR_ARN=$(aws apprunner list-vpc-connectors \
  --query 'VpcConnectors[0].VpcConnectorArn' --output text 2>/dev/null || true)

if [ -z "$VPC_CONNECTOR_ARN" ] || [ "$VPC_CONNECTOR_ARN" == "None" ]; then
  echo "Error: No VPC connector found. Create one first so App Runner can reach RDS."
  echo "  aws apprunner create-vpc-connector --vpc-connector-name meal-planner-vpc ..."
  exit 1
fi

echo "Using VPC connector: $VPC_CONNECTOR_ARN"

aws apprunner create-service \
  --service-name meal-planner-backend \
  --source-configuration "{
    \"ImageRepository\": {
      \"ImageIdentifier\": \"${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/meal-planner-backend:latest\",
      \"ImageRepositoryType\": \"ECR\",
      \"ImageConfiguration\": {
        \"Port\": \"8000\",
        \"RuntimeEnvironmentSecrets\": {
          \"DATABASE_URL\": \"arn:aws:secretsmanager:${REGION}:${ACCOUNT_ID}:secret:meal-planner-app/production:DATABASE_URL::\",
          \"SECRET_KEY\": \"arn:aws:secretsmanager:${REGION}:${ACCOUNT_ID}:secret:meal-planner-app/production:SECRET_KEY::\",
          \"ENCRYPTION_KEY\": \"arn:aws:secretsmanager:${REGION}:${ACCOUNT_ID}:secret:meal-planner-app/production:ENCRYPTION_KEY::\",
          \"OPENAI_API_KEY\": \"arn:aws:secretsmanager:${REGION}:${ACCOUNT_ID}:secret:meal-planner-app/production:OPENAI_API_KEY::\"
        }
      }
    },
    \"AutoDeploymentsEnabled\": false,
    \"AuthenticationConfiguration\": {\"AccessRoleArn\": \"${APPRUNNER_ECR_ROLE_ARN}\"}
  }" \
  --instance-configuration "{\"Cpu\":\"0.25 vCPU\",\"Memory\":\"0.5 GB\",\"InstanceRoleArn\":\"${APPRUNNER_INSTANCE_ROLE_ARN}\"}" \
  --network-configuration "{\"EgressConfiguration\":{\"EgressType\":\"VPC\",\"VpcConnectorArn\":\"${VPC_CONNECTOR_ARN}\"}}"

echo ""
echo "App Runner service creation initiated!"
echo "Check status with: aws apprunner list-services"
