#!/bin/bash

# View CloudWatch Logs for Meal Planner Backend

LOG_GROUP="/ecs/meal-planner"

echo "📊 Viewing logs from $LOG_GROUP"
echo "Press Ctrl+C to stop"
echo ""

aws logs tail "$LOG_GROUP" --follow --format short
