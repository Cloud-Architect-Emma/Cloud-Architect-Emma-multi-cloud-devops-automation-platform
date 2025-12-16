# infra/stacks/gcp/dev/us-central1/vpc/stack.tm.hcl


stack {
  name = "gcp-dev-us-central1-vpc"
  tags = ["gcp", "dev", "us-central1", "vpc"]
}

generate_file "backend.tf" {
  content = <<EOT
terraform {
  backend "gcs" {
    bucket = "${global.backend_bucket}"
    prefix = "${global.environment}/${global.region}/vpc"
  }
}
EOT
}

generate_file "provider.tf" {
  content = <<EOT
provider "google" {
  project = "${global.project_id}"
  region  = "${global.region}"
}
EOT
}

generate_file "main.tf" {
  content = <<EOT
module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 9.0"

  project_id   = "${global.project_id}"
  network_name = "${global.vpc_name}"
  subnets = [
    {
      subnet_name           = "${global.subnet_name}"
      subnet_ip             = "${global.subnet_cidr}"
      subnet_region         = "${global.region}"
      subnet_private_access = true
    }
  ]
}

output "vpc_self_link" {
  value = module.vpc.network_self_link
}

output "subnet_self_link" {
  value = module.vpc.subnets_self_links[0]
}
EOT
}
