# Terraform Stack Components Configuration
# This file demonstrates AWS provider configurations for different regions
# Each deployment will use a different AWS provider configuration

# Required providers for the stack
required_providers {
  aws = {
    source  = "hashicorp/aws"
    version = "~> 5.0"
  }
}

# Variables for the stack
variable "aws_region" {
  type        = string
  description = "AWS region where resources will be deployed"
}

variable "environment" {
  type        = string
  description = "Environment name (e.g., dev, staging, prod)"
}

variable "project_name" {
  type        = string
  description = "Name of the project for resource naming"
  default     = "terraform-stack-demo"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t3.micro"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  type        = string
  description = "CIDR block for the subnet"
  default     = "10.0.1.0/24"
}

variable "allowed_ssh_cidrs" {
  type        = list(string)
  description = "List of CIDR blocks allowed SSH access"
  default     = ["0.0.0.0/0"]
}

# Provider configuration that will be used across deployments
# Each deployment will configure this provider with a different region
provider "aws" "main" {
  config {
    region = var.aws_region
    
    default_tags {
      tags = {
        Project     = var.project_name
        Environment = var.environment
        Region      = var.aws_region
        ManagedBy   = "terraform-stacks"
      }
    }
  }
}

# Component for EC2 infrastructure
component "ec2_infrastructure" {
  source = "./modules/ec2-with-sg"
  
  inputs = {
    aws_region         = var.aws_region
    environment        = var.environment
    project_name       = var.project_name
    instance_type      = var.instance_type
    vpc_cidr          = var.vpc_cidr
    subnet_cidr       = var.subnet_cidr
    allowed_ssh_cidrs = var.allowed_ssh_cidrs
  }
  
  providers = {
    aws = provider.aws.main
  }
}

# Output the important information from the deployment
output "instance_details" {
  type        = object({
    instance_id       = string
    instance_name     = string
    public_ip        = string
    private_ip       = string
    security_group_id = string
    region           = string
    environment      = string
  })
  description = "Details about the deployed EC2 instance"
  value = {
    instance_id       = component.ec2_infrastructure.instance_id
    instance_name     = component.ec2_infrastructure.instance_name
    public_ip        = component.ec2_infrastructure.public_ip
    private_ip       = component.ec2_infrastructure.private_ip
    security_group_id = component.ec2_infrastructure.security_group_id
    region           = var.aws_region
    environment      = var.environment
  }
}

output "vpc_details" {
  type = object({
    vpc_id           = string
    subnet_id        = string
    internet_gateway_id = string
  })
  description = "VPC and networking details"
  value = {
    vpc_id           = component.ec2_infrastructure.vpc_id
    subnet_id        = component.ec2_infrastructure.subnet_id
    internet_gateway_id = component.ec2_infrastructure.internet_gateway_id
  }
}