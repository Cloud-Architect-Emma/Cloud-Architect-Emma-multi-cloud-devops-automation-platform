// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT



resource "google_artifact_registry_repository" "repo_dev" {
  project       = "terraform-multi-cloud-480415"
  location      = "us-central1"
  repository_id = "repo-dev"
  format        = "DOCKER"
}

output "artifact_registry_repo" {
  description = "The Artifact Registry repository name"
  value       = google_artifact_registry_repository.repo_dev.repository_id
}

output "artifact_registry_location" {
  description = "The Artifact Registry location"
  value       = google_artifact_registry_repository.repo_dev.location
}
