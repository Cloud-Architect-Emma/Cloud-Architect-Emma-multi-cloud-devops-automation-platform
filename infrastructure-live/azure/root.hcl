locals {
  subscription_id = "92bafd73-6e08-4239-acee-913bf89d5e1f"
  tenant_id       = "adaf5471-32cc-46bf-9006-156e3d62803b"
}

remote_state {
  backend = "azurerm"
  config = {
    subscription_id     = local.subscription_id
    tenant_id           = local.tenant_id
    resource_group_name = "multi-cloud-plateform"
    storage_account_name = "myprojectterrafromstate"
    container_name       = "tfstate"
    key                  = "${path_relative_to_include()}/terraform.tfstate"
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
provider "azurerm" {
  features {}
  subscription_id = "${local.subscription_id}"
  tenant_id       = "${local.tenant_id}"
}
EOF
}
