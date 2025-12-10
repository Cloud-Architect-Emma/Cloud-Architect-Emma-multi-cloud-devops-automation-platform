# azure/dev/eastus/terragrunt.hcl
include "root" {
  path = find_in_parent_folders("root.hcl")  # will find azure/root.hcl
}

locals {
  location = "eastus"
}

# optional: expose location as inputs if you want:
inputs = {
  location = local.location
}