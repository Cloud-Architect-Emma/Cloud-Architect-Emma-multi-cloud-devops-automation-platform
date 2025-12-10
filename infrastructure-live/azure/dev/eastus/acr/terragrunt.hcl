# azure/dev/eastus/acr/terragrunt.hcl
terraform {
  source = "../../../modules/acr"
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
  environment         = local.environment
  location            = local.location

  # YOUR REAL RESOURCE GROUP
  resource_group_name = "multi-cloud-platform"

  # ACR name must be globally unique → using suffix from module
  acr_name = "acr${local.location}${local.environment}"

  sku = "Standard"
}
