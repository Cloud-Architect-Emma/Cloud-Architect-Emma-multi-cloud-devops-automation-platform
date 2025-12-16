
// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT



resource "google_storage_bucket" "storage_dev" {
  name     = "st-dev-us-central1"
  project  = "terraform-multi-cloud-480415"
  location = "US-CENTRAL1"

  uniform_bucket_level_access = true
}

output "bucket_name" {
  description = "The name of the storage bucket"
  value       = google_storage_bucket.storage_dev.name
}

output "bucket_location" {
  description = "The location of the storage bucket"
  value       = google_storage_bucket.storage_dev.location
}
