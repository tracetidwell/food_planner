#!/bin/bash

# Check status of Meal Planner deployment

echo "🔍 Meal Planner Deployment Status"
echo "===================================="
echo ""

# Get Terraform outputs
cd "$(dirname "$0")/terraform"

if [ ! -f "terraform.tfstate" ]; then
    echo "❌ No deployment found. Run ./deploy.sh first."
    exit 1
fi

ECS_CLUSTER=$(terraform output -raw ecs_cluster_name 2>/dev/null)
ECS_SERVICE=$(terraform output -raw ecs_service_name 2>/dev/null)
ALB_DNS=$(terraform output -raw alb_dns_name 2>/dev/null)

if [ -z "$ECS_CLUSTER" ]; then
    echo "❌ Unable to get deployment info. Check terraform state."
    exit 1
fi

echo "📦 Infrastructure:"
echo "   Cluster: $ECS_CLUSTER"
echo "   Service: $ECS_SERVICE"
echo "   URL: http://$ALB_DNS"
echo ""

# Check ECS service status
echo "🔄 ECS Service Status:"
aws ecs describe-services \
    --cluster "$ECS_CLUSTER" \
    --services "$ECS_SERVICE" \
    --query 'services[0].{Status:status,Running:runningCount,Desired:desiredCount,Pending:pendingCount}' \
    --output table

echo ""

# Check task health
echo "💊 Task Health:"
aws ecs list-tasks \
    --cluster "$ECS_CLUSTER" \
    --service-name "$ECS_SERVICE" \
    --query 'taskArns[*]' \
    --output text | while read task; do
    if [ ! -z "$task" ]; then
        aws ecs describe-tasks \
            --cluster "$ECS_CLUSTER" \
            --tasks "$task" \
            --query 'tasks[0].{ID:taskArn,Status:lastStatus,Health:healthStatus,Started:startedAt}' \
            --output table
    fi
done

echo ""

# Check ALB target health
echo "🎯 Load Balancer Target Health:"
TARGET_GROUP_ARN=$(aws elbv2 describe-target-groups \
    --query "TargetGroups[?contains(TargetGroupName, 'meal-planner')].TargetGroupArn" \
    --output text)

if [ ! -z "$TARGET_GROUP_ARN" ]; then
    aws elbv2 describe-target-health \
        --target-group-arn "$TARGET_GROUP_ARN" \
        --query 'TargetHealthDescriptions[*].{Target:Target.Id,Port:Target.Port,Health:TargetHealth.State,Reason:TargetHealth.Reason}' \
        --output table
else
    echo "   No target group found"
fi

echo ""

# Test health endpoint
echo "❤️  Health Check:"
if curl -s -f "http://$ALB_DNS/health" > /dev/null 2>&1; then
    HEALTH=$(curl -s "http://$ALB_DNS/health")
    echo "   ✅ API is healthy"
    echo "   Response: $HEALTH"
else
    echo "   ❌ API health check failed"
    echo "   Check logs: ./logs.sh"
fi

echo ""
echo "📊 View logs: ./logs.sh"
echo "🔄 Update deployment: ./deploy.sh"
echo ""
