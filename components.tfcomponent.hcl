component "ec2_infrastructure" {
  for_each = var.aws_regions

  source = "./modules/ec2-with-sg"

  inputs = {
    aws_region        = each.value
    environment       = var.environment
    project_name      = var.project_name
    instance_type     = var.instance_type
    vpc_cidr          = var.vpc_cidr
    subnet_cidr       = var.subnet_cidr
    allowed_ssh_cidrs = var.allowed_ssh_cidrs
  }

  providers = {
    aws = provider.aws.configurations[each.value]
  }
}

