# azure/dev/eastus/storage/terragrunt.hcl
terraform {
  source = "../../../modules/storage"
}

include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

locals {
  environment = "dev"
  location    = "eastus"
}

inputs = {
  environment            = local.environment
  location               = local.location
  resource_group_name    = "multi-cloud-platform"
  storage_account_name   = "steastusdev123"   # make this unique
}
