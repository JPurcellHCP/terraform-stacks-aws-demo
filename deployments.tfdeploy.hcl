# Terraform Stack Deployments Configuration
# This file demonstrates how to use different AWS providers per deployment
# Each deployment targets a different AWS region, showing provider flexibility

# US East 1 (Virginia) - Development Environment
deployment "us-east-1-dev" {
  inputs = {
    aws_region         = "us-east-1"
    environment        = "development"
    project_name       = "terraform-stack-demo"
    instance_type      = "t3.micro"
    vpc_cidr          = "10.0.0.0/16"
    subnet_cidr       = "10.0.1.0/24"
    allowed_ssh_cidrs = ["0.0.0.0/0"]  # In production, restrict this
  }
}

# US West 2 (Oregon) - Staging Environment
deployment "us-west-2-staging" {
  inputs = {
    aws_region         = "us-west-2"
    environment        = "staging"
    project_name       = "terraform-stack-demo"
    instance_type      = "t3.small"
    vpc_cidr          = "10.1.0.0/16"
    subnet_cidr       = "10.1.1.0/24"
    allowed_ssh_cidrs = ["10.0.0.0/8", "192.168.0.0/16"]  # More restricted
  }
}

# EU West 1 (Ireland) - Production Environment
deployment "eu-west-1-prod" {
  inputs = {
    aws_region         = "eu-west-1"
    environment        = "production"
    project_name       = "terraform-stack-demo"
    instance_type      = "t3.medium"
    vpc_cidr          = "10.2.0.0/16"
    subnet_cidr       = "10.2.1.0/24"
    allowed_ssh_cidrs = ["10.0.0.0/8"]  # Very restricted for production
  }
}

# Asia Pacific Southeast 1 (Singapore) - Regional Expansion
deployment "ap-southeast-1-regional" {
  inputs = {
    aws_region         = "ap-southeast-1"
    environment        = "regional"
    project_name       = "terraform-stack-demo"
    instance_type      = "t3.small"
    vpc_cidr          = "10.3.0.0/16"
    subnet_cidr       = "10.3.1.0/24"
    allowed_ssh_cidrs = ["10.0.0.0/8"]
  }
}

# Canada Central - Compliance/Data Residency
deployment "ca-central-1-compliance" {
  inputs = {
    aws_region         = "ca-central-1"
    environment        = "compliance"
    project_name       = "terraform-stack-demo"
    instance_type      = "t3.micro"
    vpc_cidr          = "10.4.0.0/16"
    subnet_cidr       = "10.4.1.0/24"
    allowed_ssh_cidrs = ["10.0.0.0/8"]
  }
}