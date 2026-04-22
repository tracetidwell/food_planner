#!/bin/bash
# Sets up a NAT Gateway so App Runner can reach the internet (OpenAI API)
# while still accessing the RDS database through the VPC.
#
# Run this once. It is safe to run again (idempotent).
#
# Cost: ~$32/month for the NAT Gateway + ~$0.005/GB data processed.

set -e

REGION="us-east-1"
VPC_ID="vpc-95e58cf3"
NAT_PUBLIC_SUBNET="subnet-1c782331"   # us-east-1c (public, where bastion lives)
NEW_SG_NAME="meal-planner-vpc-connector-sg"
APP_RUNNER_SERVICE_NAME="meal-planner-backend"
NEW_VPC_CONNECTOR_NAME="meal-planner-vpc-connector"

# Private subnet CIDRs (not in use by existing subnets)
PRIVATE_CIDR_1="172.31.96.0/20"
PRIVATE_AZ_1="us-east-1c"
PRIVATE_CIDR_2="172.31.112.0/20"
PRIVATE_AZ_2="us-east-1a"

echo "=== Setting up NAT Gateway for App Runner internet access ==="
echo ""

# ── Step 1: Elastic IP ────────────────────────────────────────────────────────
echo "Step 1: Allocating Elastic IP for NAT Gateway..."

EIP_ALLOC_ID=$(aws ec2 describe-addresses \
  --filters "Name=tag:Name,Values=meal-planner-nat-eip" \
  --query 'Addresses[0].AllocationId' \
  --output text)

if [ "$EIP_ALLOC_ID" == "None" ] || [ -z "$EIP_ALLOC_ID" ]; then
  EIP_ALLOC_ID=$(aws ec2 allocate-address --domain vpc \
    --query 'AllocationId' --output text)
  aws ec2 create-tags --resources "$EIP_ALLOC_ID" \
    --tags Key=Name,Value=meal-planner-nat-eip
  echo "  Created EIP: $EIP_ALLOC_ID"
else
  echo "  Reusing EIP: $EIP_ALLOC_ID"
fi

# ── Step 2: NAT Gateway ───────────────────────────────────────────────────────
echo "Step 2: Creating NAT Gateway..."

NAT_GW_ID=$(aws ec2 describe-nat-gateways \
  --filter "Name=tag:Name,Values=meal-planner-nat-gw" \
           "Name=state,Values=available,pending" \
  --query 'NatGateways[0].NatGatewayId' \
  --output text)

if [ "$NAT_GW_ID" == "None" ] || [ -z "$NAT_GW_ID" ]; then
  NAT_GW_ID=$(aws ec2 create-nat-gateway \
    --subnet-id "$NAT_PUBLIC_SUBNET" \
    --allocation-id "$EIP_ALLOC_ID" \
    --query 'NatGateway.NatGatewayId' \
    --output text)
  aws ec2 create-tags --resources "$NAT_GW_ID" \
    --tags Key=Name,Value=meal-planner-nat-gw
  echo "  Created NAT Gateway: $NAT_GW_ID"
else
  echo "  Reusing NAT Gateway: $NAT_GW_ID"
fi

echo "  Waiting for NAT Gateway to become available (~60-90 seconds)..."
aws ec2 wait nat-gateway-available --nat-gateway-ids "$NAT_GW_ID"
echo "  NAT Gateway is available!"

# ── Step 3: Private subnets ───────────────────────────────────────────────────
echo "Step 3: Creating private subnets..."

PRIVATE_SUBNET_1=$(aws ec2 describe-subnets \
  --filters "Name=tag:Name,Values=meal-planner-private-1" \
            "Name=vpc-id,Values=$VPC_ID" \
  --query 'Subnets[0].SubnetId' --output text)

if [ "$PRIVATE_SUBNET_1" == "None" ] || [ -z "$PRIVATE_SUBNET_1" ]; then
  PRIVATE_SUBNET_1=$(aws ec2 create-subnet \
    --vpc-id "$VPC_ID" \
    --cidr-block "$PRIVATE_CIDR_1" \
    --availability-zone "$PRIVATE_AZ_1" \
    --query 'Subnet.SubnetId' --output text)
  aws ec2 create-tags --resources "$PRIVATE_SUBNET_1" \
    --tags Key=Name,Value=meal-planner-private-1
  echo "  Created private subnet 1: $PRIVATE_SUBNET_1 ($PRIVATE_AZ_1, $PRIVATE_CIDR_1)"
else
  echo "  Reusing private subnet 1: $PRIVATE_SUBNET_1"
fi

PRIVATE_SUBNET_2=$(aws ec2 describe-subnets \
  --filters "Name=tag:Name,Values=meal-planner-private-2" \
            "Name=vpc-id,Values=$VPC_ID" \
  --query 'Subnets[0].SubnetId' --output text)

if [ "$PRIVATE_SUBNET_2" == "None" ] || [ -z "$PRIVATE_SUBNET_2" ]; then
  PRIVATE_SUBNET_2=$(aws ec2 create-subnet \
    --vpc-id "$VPC_ID" \
    --cidr-block "$PRIVATE_CIDR_2" \
    --availability-zone "$PRIVATE_AZ_2" \
    --query 'Subnet.SubnetId' --output text)
  aws ec2 create-tags --resources "$PRIVATE_SUBNET_2" \
    --tags Key=Name,Value=meal-planner-private-2
  echo "  Created private subnet 2: $PRIVATE_SUBNET_2 ($PRIVATE_AZ_2, $PRIVATE_CIDR_2)"
else
  echo "  Reusing private subnet 2: $PRIVATE_SUBNET_2"
fi

# ── Step 4: Route table ───────────────────────────────────────────────────────
echo "Step 4: Creating private route table (0.0.0.0/0 → NAT Gateway)..."

PRIVATE_RT_ID=$(aws ec2 describe-route-tables \
  --filters "Name=tag:Name,Values=meal-planner-private-rt" \
            "Name=vpc-id,Values=$VPC_ID" \
  --query 'RouteTables[0].RouteTableId' --output text)

if [ "$PRIVATE_RT_ID" == "None" ] || [ -z "$PRIVATE_RT_ID" ]; then
  PRIVATE_RT_ID=$(aws ec2 create-route-table \
    --vpc-id "$VPC_ID" \
    --query 'RouteTable.RouteTableId' --output text)
  aws ec2 create-tags --resources "$PRIVATE_RT_ID" \
    --tags Key=Name,Value=meal-planner-private-rt
  echo "  Created route table: $PRIVATE_RT_ID"
else
  echo "  Reusing route table: $PRIVATE_RT_ID"
fi

aws ec2 create-route \
  --route-table-id "$PRIVATE_RT_ID" \
  --destination-cidr-block "0.0.0.0/0" \
  --nat-gateway-id "$NAT_GW_ID" > /dev/null 2>&1 \
  && echo "  Added 0.0.0.0/0 → NAT Gateway route" \
  || echo "  Route already exists"

aws ec2 associate-route-table \
  --route-table-id "$PRIVATE_RT_ID" \
  --subnet-id "$PRIVATE_SUBNET_1" > /dev/null 2>&1 \
  && echo "  Associated private subnet 1" || echo "  Subnet 1 already associated"

aws ec2 associate-route-table \
  --route-table-id "$PRIVATE_RT_ID" \
  --subnet-id "$PRIVATE_SUBNET_2" > /dev/null 2>&1 \
  && echo "  Associated private subnet 2" || echo "  Subnet 2 already associated"

# ── Step 5: Security group + VPC connector ───────────────────────────────────
echo "Step 5: Creating dedicated security group and VPC connector..."

SG_ID=$(aws ec2 describe-security-groups \
  --filters "Name=group-name,Values=$NEW_SG_NAME" \
            "Name=vpc-id,Values=$VPC_ID" \
  --query 'SecurityGroups[0].GroupId' --output text)

if [ "$SG_ID" == "None" ] || [ -z "$SG_ID" ]; then
  SG_ID=$(aws ec2 create-security-group \
    --group-name "$NEW_SG_NAME" \
    --description "Security group for meal-planner App Runner VPC connector" \
    --vpc-id "$VPC_ID" \
    --query 'GroupId' --output text)
  # Allow all outbound (required for OpenAI API + RDS)
  aws ec2 authorize-security-group-egress \
    --group-id "$SG_ID" \
    --protocol -1 \
    --cidr 0.0.0.0/0 > /dev/null 2>&1 || true
  echo "  Created security group: $SG_ID"
else
  echo "  Reusing security group: $SG_ID"
fi

NEW_CONNECTOR_ARN=$(aws apprunner list-vpc-connectors \
  --query "VpcConnectors[?VpcConnectorName=='$NEW_VPC_CONNECTOR_NAME' && Status=='ACTIVE'].VpcConnectorArn | [0]" \
  --output text)

if [ "$NEW_CONNECTOR_ARN" == "None" ] || [ -z "$NEW_CONNECTOR_ARN" ]; then
  NEW_CONNECTOR_ARN=$(aws apprunner create-vpc-connector \
    --vpc-connector-name "$NEW_VPC_CONNECTOR_NAME" \
    --subnets "$PRIVATE_SUBNET_1" "$PRIVATE_SUBNET_2" \
    --security-groups "$SG_ID" \
    --query 'VpcConnector.VpcConnectorArn' \
    --output text)
  echo "  Created VPC connector: $NEW_CONNECTOR_ARN"
else
  echo "  Reusing VPC connector: $NEW_CONNECTOR_ARN"
fi

# ── Step 6: Update App Runner service ─────────────────────────────────────────
echo "Step 6: Updating App Runner service to use new VPC connector..."

SERVICE_ARN=$(aws apprunner list-services \
  --query "ServiceSummaryList[?ServiceName=='$APP_RUNNER_SERVICE_NAME'].ServiceArn" \
  --output text)

aws apprunner update-service \
  --service-arn "$SERVICE_ARN" \
  --network-configuration "{
    \"EgressConfiguration\": {
      \"EgressType\": \"VPC\",
      \"VpcConnectorArn\": \"$NEW_CONNECTOR_ARN\"
    }
  }" > /dev/null

echo "  Waiting for service to finish updating (~2-3 minutes)..."
while true; do
  STATUS=$(aws apprunner describe-service --service-arn "$SERVICE_ARN" \
    --query 'Service.Status' --output text)
  if [ "$STATUS" == "RUNNING" ]; then
    echo "  Service is RUNNING!"
    break
  elif [ "$STATUS" == "UPDATE_FAILED" ]; then
    echo "  ERROR: Service update failed!"
    exit 1
  fi
  echo "  Status: $STATUS — waiting..."
  sleep 15
done

# ── Done ──────────────────────────────────────────────────────────────────────
echo ""
echo "=== Done! ==="
echo ""
echo "App Runner now routes internet traffic:  private subnet → NAT GW → Internet"
echo "App Runner still reaches RDS via:        private subnet → VPC"
echo ""
SERVICE_URL=$(aws apprunner list-services \
  --query "ServiceSummaryList[?ServiceName=='$APP_RUNNER_SERVICE_NAME'].ServiceUrl" \
  --output text)
echo "Test the fix:"
echo "  curl https://${SERVICE_URL}/health"
