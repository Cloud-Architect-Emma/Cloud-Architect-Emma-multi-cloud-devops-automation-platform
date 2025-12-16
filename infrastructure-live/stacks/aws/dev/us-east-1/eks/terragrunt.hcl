# Include parent Terragrunt config
include {
  path = find_in_parent_folders()
}

# Dependency on VPC module
dependency "vpc" {
  config_path = "../vpc"
}

# Terraform module source for EKS
terraform {
  source = "github.com/terraform-aws-modules/terraform-aws-eks?ref=v20.24.0"
}


# Module inputs
inputs = {
  cluster_name    = "dev-eks"
  cluster_version = "1.29"

  vpc_id     = dependency.vpc.outputs.vpc_id
  subnet_ids = dependency.vpc.outputs.private_subnets

  # Managed node groups
  eks_managed_node_groups = {
    default = {
      desired_size   = 2
      max_size       = 3
      min_size       = 1
      instance_types = ["t3.medium"]
    }
  }

  # Self-managed node groups
  eks_node_groups = {
    dev_node_group = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1
      instance_type    = "t3.medium"
      subnet_ids       = dependency.vpc.outputs.private_subnets
    }
  }
}

# Generate backend.tf automatically
generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite"
  contents  = <<EOF
terraform {
  backend "s3" {}
}
EOF
}
