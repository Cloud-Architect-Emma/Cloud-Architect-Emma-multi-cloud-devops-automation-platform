// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT


terraform {
  backend "gcs" {
    bucket = "tfstate-terraform-multi-cloud"
    prefix = "dev/artifact-registry"
  }
}
