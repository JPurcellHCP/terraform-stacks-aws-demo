required_providers {
  aws = {
    source  = "hashicorp/aws"
    version = "~> 5.0"
  }
}

provider "aws" "configurations" {
  for_each = var.aws_regions

  config {
    region = each.value
    
    assume_role_with_web_identity {
      role_arn                = var.role_arn
      web_identity_token      = var.identity_token
      session_name           = "terraform-stacks-${each.value}-${var.environment}"
    }

    default_tags {
      tags = {
        Project     = var.project_name
        Environment = var.environment
        Region      = each.value
        ManagedBy   = "terraform-stacks"
      }
    }
  }
}