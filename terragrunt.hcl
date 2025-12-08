# =====================================================================
# Root Terragrunt Config (DRY backend + provider config)
# =====================================================================

remote_state {
  backend = "s3"
  config = {
    bucket         = "muticloud-terraform-state"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"

  contents = <<EOF
provider "aws" {
  region = "us-east-1"
}
EOF
}

# Add this new block to generate versions.tf with provider version constraints
generate "versions" {
  path      = "versions.tf"
  if_exists = "overwrite"
  contents  = <<EOF
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"  # Ensures support for elastic_gpu_specifications and elastic_inference_accelerator blocks
    }
  }
  required_version = ">= 1.0"
}
EOF
}