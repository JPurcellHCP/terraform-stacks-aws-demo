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