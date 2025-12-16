# infra/stacks/gcp/dev/us-central1/stack.tm.hcl

stack {
  name = "gcp-dev-us-central1"
  tags = ["gcp", "dev", "us-central1"]
}

globals {
  # Environment & region
  environment = "dev"
  region      = "us-central1"

  # Terraform remote state bucket
  backend_bucket = "tfstate-terraform-multi-cloud"

  # GCP project
  project_id = "terraform-multi-cloud-480415"

  # Networking (VPC)
  vpc_name    = "vpc-dev"
  subnet_name = "subnet-dev"
  cidr_block  = "10.20.0.0/16"
  subnet_cidr = "10.20.1.0/24"

  # GKE
  cluster_name = "gke-dev-us-central1"
  node_size    = "e2-standard-4"
  node_count   = 3

  # Storage & Artifact Registry
  bucket_name = "st-dev-us-central1"
  repo_name   = "repo-dev"
  location    = "us-central1"

  # VPN peer details
  peer_ip       = "PEER_PUBLIC_IP"
  shared_secret = "CHANGE_ME_SECRET"
}
