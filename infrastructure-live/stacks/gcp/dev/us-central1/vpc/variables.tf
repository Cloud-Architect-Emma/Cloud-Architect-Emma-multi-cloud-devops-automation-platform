variable "project_id" {
  type        = string
  description = "The GCP project ID where the GKE cluster will be created"
  default     = "terraform-multi-cloud-480415"
}

variable "region" {
  type        = string
  description = "The GCP region for the GKE cluster"
  default     = "us-central1"
}

variable "cluster_name" {
  type        = string
  description = "The name of the GKE cluster"
  default     = "gke-dev"
}
