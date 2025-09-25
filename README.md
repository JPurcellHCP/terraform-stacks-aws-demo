# AWS Provider Example - Terraform Stack

This Terraform Stack demonstrates how to use different AWS providers per deployment, deploying EC2 instances with security groups across multiple AWS regions. Each deployment uses a different AWS region, and the resource names include the region to clearly show the provider configuration differences.

## Overview

This stack creates:
- **VPC** with Internet Gateway and routing
- **EC2 Instance** with region and environment in the name/tags
- **Security Group** allowing SSH, HTTP, and HTTPS access with region in the name
- **Networking** resources (subnet, route table, etc.) with regional naming

## Key Features

### Multi-Region Provider Configuration
Each deployment in `deployments.tfdeploy.hcl` uses a different AWS region:
- `us-east-1-dev`: Development in US East 1 (Virginia)
- `us-west-2-staging`: Staging in US West 2 (Oregon)  
- `eu-west-1-prod`: Production in EU West 1 (Ireland)
- `ap-southeast-1-regional`: Regional expansion in Asia Pacific
- `ca-central-1-compliance`: Compliance workload in Canada

### Regional Naming Convention
All resources include the AWS region in their names and tags:
- EC2 Instance: `terraform-stack-demo-ec2-us-east-1-development`
- Security Group: `terraform-stack-demo-ec2-sg-us-east-1-development`
- VPC: `terraform-stack-demo-vpc-us-east-1-development`

## File Structure

```
aws-provider-example/
├── components.tfstack.hcl      # Stack components and provider config
├── deployments.tfdeploy.hcl    # Multi-region deployment definitions
├── README.md                   # This documentation
├── terraform.tfvars.example    # Example variables file
└── modules/
    └── ec2-with-sg/           # Reusable EC2 + Security Group module
        ├── main.tf            # Main resource definitions
        ├── variables.tf       # Input variables
        ├── outputs.tf         # Output values
        └── user_data.sh       # EC2 instance startup script
```

## Usage

### Prerequisites

1. **Terraform**: Install Terraform 1.13.0+ with integrated Stacks support

2. **AWS OIDC Setup**: Configure OIDC identity provider and trusted role in AWS:
   
   ### Step 1: Create OIDC Identity Provider (if not exists)
   ```bash
   aws iam create-openid-connect-provider \
     --url https://app.terraform.io \
     --client-id-list aws.workload.identity \
     --thumbprint-list 9e99a48a9960b14926bb7f3b02e22da2b0ab7280
   ```
   
   ### Step 2: Create IAM Role for Terraform Stacks
   Create a role with this trust policy (replace YOUR_ORG, YOUR_PROJECT, YOUR_STACK):
   ```json
   {
     "Version": "2012-10-17",
     "Statement": [
       {
         "Effect": "Allow",
         "Principal": {
           "Federated": "arn:aws:iam::YOUR_ACCOUNT_ID:oidc-provider/app.terraform.io"
         },
         "Action": "sts:AssumeRoleWithWebIdentity",
         "Condition": {
           "StringEquals": {
             "app.terraform.io:aud": "aws.workload.identity"
           },
           "StringLike": {
             "app.terraform.io:sub": "organization:YOUR_ORG:project:YOUR_PROJECT:stack:YOUR_STACK:*"
           }
         }
       }
     ]
   }
   ```
   
   ### Step 3: Attach Permissions to Role
   Attach appropriate AWS policies (e.g., EC2FullAccess, VPCFullAccess) to the role.

3. **Update Deployment Configuration**: Replace `YOUR_ACCOUNT_ID` in `deployments.tfdeploy.hcl` with your actual AWS account ID and role name.

### Deployment Commands

```bash
# Initialize the stack
terraform init

# Plan a specific deployment (e.g., development)
terraform plan -deployment=us-east-1-dev

# Apply a specific deployment
terraform apply -deployment=us-east-1-dev

# View outputs for a deployment
terraform output -deployment=us-east-1-dev

# Apply all deployments (be careful!)
terraform apply

# Destroy a specific deployment
terraform destroy -deployment=us-east-1-dev
```

### Example Output
After deployment, you'll see outputs like:
```
instance_details = {
  instance_id = "i-0123456789abcdef0"
  instance_name = "terraform-stack-demo-ec2-us-east-1-development" 
  public_ip = "54.123.45.67"
  private_ip = "10.0.1.100"
  security_group_id = "sg-0123456789abcdef0"
  region = "us-east-1"
  environment = "development"
}
```

## Customization

### Adding New Regions
To add a new region deployment:

1. Add a new deployment block in `deployments.tfdeploy.hcl`:
```hcl
deployment "eu-central-1-test" {
  inputs = {
    aws_region    = "eu-central-1"
    environment   = "test"
    project_name  = "terraform-stack-demo"
    instance_type = "t3.micro"
    # ... other variables
  }
}
```

2. Deploy with:
```bash
terraform apply -deployment=eu-central-1-test
```

### Modifying Instance Types
Change the `instance_type` in any deployment to use different EC2 instance sizes:
- `t3.nano` - Minimal testing
- `t3.micro` - Development (Free Tier eligible)
- `t3.small` - Staging
- `t3.medium` - Production
- And larger sizes as needed

### Security Group Rules
Modify `allowed_ssh_cidrs` in deployments to restrict SSH access:
- `["0.0.0.0/0"]` - Open to internet (development only)
- `["10.0.0.0/8"]` - Private networks only
- `["1.2.3.4/32"]` - Specific IP only

## Testing the Deployment

After deployment, the EC2 instance runs a simple web server. You can:

1. **SSH to the instance**:
```bash
ssh -i your-key.pem ec2-user@<public_ip>
```

2. **View the web page**:
```bash
curl http://<public_ip>
```

The web page displays deployment information including the region, environment, and instance details.

3. **Check deployment logs**:
```bash
# On the EC2 instance
sudo cat /var/log/deployment.log
```

## Clean Up

To avoid AWS charges, destroy resources when done:
```bash
# Destroy specific deployment
terraform destroy -deployment=us-east-1-dev

# Or destroy all deployments
terraform destroy
```

## Provider Configuration Notes

This stack demonstrates several important Terraform Stacks concepts:

1. **Provider Configuration**: Each deployment configures the AWS provider with a different region
2. **Variable Interpolation**: Region names are used in resource naming throughout the stack
3. **Component Reusability**: The same module creates resources in different regions
4. **Output Aggregation**: Stack outputs show deployment-specific information

The key innovation is in `components.tfstack.hcl` where the AWS provider is configured with:
```hcl
provider "aws" "main" {
  config {
    region = var.aws_region
  }
}
```

This allows each deployment to specify its region, and all resources will be created in that region with region-aware naming.