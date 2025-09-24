# Terraform Stack Deployments Configuration
# This file demonstrates how to use different AWS providers per deployment
# Each deployment targets different AWS regions, showing provider flexibility

# Development Environment - Single Region
deployment "development" {
  inputs = {
    aws_regions       = ["us-east-1"]
    environment       = "development"
    project_name      = "terraform-stack-demo"
    instance_type     = "t3.micro"
    vpc_cidr          = "10.0.0.0/16"
    subnet_cidr       = "10.0.1.0/24"
    allowed_ssh_cidrs = ["0.0.0.0/0"] # In production, restrict this
  }
}

# Staging Environment - Two Regions
deployment "staging" {
  inputs = {
    aws_regions       = ["us-east-1", "us-west-2"]
    environment       = "staging"
    project_name      = "terraform-stack-demo"
    instance_type     = "t3.small"
    vpc_cidr          = "10.1.0.0/16"
    subnet_cidr       = "10.1.1.0/24"
    allowed_ssh_cidrs = ["10.0.0.0/8", "192.168.0.0/16"] # More restricted
  }
}

# Production Environment - Multi-Region
deployment "production" {
  inputs = {
    aws_regions       = ["us-east-1", "us-west-2", "eu-west-1"]
    environment       = "production"
    project_name      = "terraform-stack-demo"
    instance_type     = "t3.medium"
    vpc_cidr          = "10.2.0.0/16"
    subnet_cidr       = "10.2.1.0/24"
    allowed_ssh_cidrs = ["10.0.0.0/8"] # Very restricted for production
  }
}

# Global Deployment - Multiple Regions
deployment "global" {
  inputs = {
    aws_regions       = ["us-east-1", "us-west-2", "eu-west-1", "ap-southeast-1", "ca-central-1"]
    environment       = "global"
    project_name      = "terraform-stack-demo"
    instance_type     = "t3.small"
    vpc_cidr          = "10.3.0.0/16"
    subnet_cidr       = "10.3.1.0/24"
    allowed_ssh_cidrs = ["10.0.0.0/8"]
  }
}