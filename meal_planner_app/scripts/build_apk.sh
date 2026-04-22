#!/bin/bash
set -e

APP_RUNNER_URL=$(aws apprunner list-services \
  --query 'ServiceSummaryList[?ServiceName==`meal-planner-backend`].ServiceUrl' \
  --output text)

echo "Building APK with API_BASE_URL: https://${APP_RUNNER_URL}"

cd /home/trace/Documents/food_tracker/meal_planner_app
flutter build apk --release \
  --dart-define=API_BASE_URL=https://${APP_RUNNER_URL}
