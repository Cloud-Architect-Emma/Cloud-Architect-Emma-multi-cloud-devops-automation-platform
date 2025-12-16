# infra/stacks/gcp/dev/us-central1/gke/stack.tm.hcl

stack {
  name = "gcp-dev-us-central1-gke"
  tags = ["gcp", "dev", "us-central1", "gke"]
}

generate_file "backend.tf" {
  content = <<EOT
terraform {
  backend "gcs" {
    bucket = "${global.backend_bucket}"
    prefix = "${global.environment}/${global.region}/gke"
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
data "terraform_remote_state" "vpc" {
  backend = "gcs"
  config = {
    bucket = "${global.backend_bucket}"
    prefix = "${global.environment}/${global.region}/vpc"
  }
}

module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google"
  version = "~> 30.0"

  project_id = "${global.project_id}"
  name       = "gke-dev"
  region     = "${global.region}"

  network    = data.terraform_remote_state.vpc.outputs.vpc_self_link
  subnetwork = data.terraform_remote_state.vpc.outputs.subnet_self_link

  ip_range_pods     = "pods"
  ip_range_services = "services"
}
EOT
}
