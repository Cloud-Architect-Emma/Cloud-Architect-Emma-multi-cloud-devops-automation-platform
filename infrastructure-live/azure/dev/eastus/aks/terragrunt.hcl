# azure/dev/eastus/aks/terragrunt.hcl
terraform {
  source = "../../../modules/aks"
}

include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

locals {
  environment = "dev"
  location    = "eastus"
}

# Dependencies
dependency "vnet" {
  config_path = "../vnet"
}

dependency "acr" {
  config_path = "../acr"
}

# Inputs for AKS
inputs = {
  environment         = local.environment
  location            = local.location

  # Resource Group where AKS will be deployed
  resource_group_name = "multi-cloud-platform"

  # AKS cluster settings
  aks_name   = "aks-${local.location}-${local.environment}"
  node_count = 1                          # minimal nodes for dev/test
  node_size  = "Standard_DC2ads_v5"       # ✅ allowed in your subscription, cheap

  # Networking
  subnet_id        = dependency.vnet.outputs.subnet_ids["aks"]
  service_cidr     = "10.240.0.0/16"
  dns_service_ip   = "10.240.0.10"

  # ACR integration
  acr_name         = dependency.acr.outputs.acr_name
  acr_id           = dependency.acr.outputs.acr_id
}
