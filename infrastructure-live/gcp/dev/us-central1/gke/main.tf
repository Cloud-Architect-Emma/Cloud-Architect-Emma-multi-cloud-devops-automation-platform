data "terraform_remote_state" "vpc" {
  backend = "gcs"
  config = {
    bucket = "tfstate-terraform-multi-cloud"
    prefix = "dev/us-central1/vpc"
  }
}

module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google"
  version = "~> 30.0"

  project_id = var.project_id
  name       = var.cluster_name
  region     = var.region

  network    = data.terraform_remote_state.vpc.outputs.vpc_name
  subnetwork = data.terraform_remote_state.vpc.outputs.subnet_name

  ip_range_pods     = "pods"
  ip_range_services = "services"
}
