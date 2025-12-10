terraform {
  source = "../../../modules/vnet"
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
  resource_group_name = "multi-cloud-platform"

  # VNet configuration
  vnet_name     = "vnet-${local.location}-${local.environment}"
  address_space = ["10.0.0.0/16"]

  subnets = {
    aks   = "10.0.1.0/24"
    other = "10.0.2.0/24"
  }
}
