# infra/terramate.hcl
terramate {
  required_version = ">=0.7.0"
}

generator "terraform" {
  format = true
}

variables {
  project_id = "terraform-multi-cloud-480415"
  backend_bucket = "tfstate-terraform-multi-cloud"
}
