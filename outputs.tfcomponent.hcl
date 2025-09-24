output "instance_details" {
  type = map(object({
    instance_id       = string
    instance_name     = string
    public_ip         = string
    private_ip        = string
    security_group_id = string
    region            = string
    environment       = string
  }))
  description = "Details about the deployed EC2 instances by region"
  value = {
    for region, ec2 in component.ec2_infrastructure : region => {
      instance_id       = ec2.instance_id
      instance_name     = ec2.instance_name
      public_ip         = ec2.public_ip
      private_ip        = ec2.private_ip
      security_group_id = ec2.security_group_id
      region            = region
      environment       = var.environment
    }
  }
}

output "vpc_details" {
  type = map(object({
    vpc_id              = string
    subnet_id           = string
    internet_gateway_id = string
  }))
  description = "VPC and networking details by region"
  value = {
    for region, ec2 in component.ec2_infrastructure : region => {
      vpc_id              = ec2.vpc_id
      subnet_id           = ec2.subnet_id
      internet_gateway_id = ec2.internet_gateway_id
    }
  }
}