terraform {
  backend "gcs" {
    bucket = "tfstate-terraform-multi-cloud"
    prefix = "dev/us-central1/gke"
  }
}
