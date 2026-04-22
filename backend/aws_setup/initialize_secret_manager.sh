#!/bin/bash
set -e

ENV_FILE="$(dirname "$0")/../backend/.env"

if [ ! -f "$ENV_FILE" ]; then
  echo "Error: $ENV_FILE not found."
  echo "Create backend/.env with: MASTER_USER_PASSWORD, RDS_ENDPOINT, SECRET_KEY, ENCRYPTION_KEY, OPENAI_API_KEY"
  exit 1
fi

MASTER_USER_PASSWORD=$(grep MASTER_USER_PASSWORD "$ENV_FILE" | cut -d'=' -f2 | tr -d ' ')
RDS_ENDPOINT=$(grep RDS_ENDPOINT "$ENV_FILE" | cut -d'=' -f2 | tr -d ' ')
SECRET_KEY=$(grep "^SECRET_KEY=" "$ENV_FILE" | cut -d'=' -f2 | tr -d ' ')
ENCRYPTION_KEY=$(grep ENCRYPTION_KEY "$ENV_FILE" | cut -d'=' -f2 | tr -d ' ')
OPENAI_API_KEY=$(grep OPENAI_API_KEY "$ENV_FILE" | cut -d'=' -f2 | tr -d ' ')

aws secretsmanager create-secret \
    --name meal-planner-app/production \
    --secret-string "{
        \"DATABASE_URL\": \"postgresql://postgres:${MASTER_USER_PASSWORD}@${RDS_ENDPOINT}:5432/meal_planner\",
        \"SECRET_KEY\": \"${SECRET_KEY}\",
        \"ENCRYPTION_KEY\": \"${ENCRYPTION_KEY}\",
        \"OPENAI_API_KEY\": \"${OPENAI_API_KEY}\"
    }"
