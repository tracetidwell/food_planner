/**
 * Main Terraform configuration for Meal Planner Backend on AWS
 *
 * This creates:
 * - ECS Fargate cluster for running containers
 * - Application Load Balancer
 * - ECR repository for Docker images
 * - Secrets Manager for secure secrets
 * - VPC with public/private subnets
 * - CloudWatch for logging
 * - IAM roles and policies
 */

terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Uncomment to use S3 backend for state management
  # backend "s3" {
  #   bucket = "your-terraform-state-bucket"
  #   key    = "meal-planner/terraform.tfstate"
  #   region = "us-east-1"
  # }
}

provider "aws" {
  region = var.aws_region
}

# Data sources
data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_caller_identity" "current" {}
