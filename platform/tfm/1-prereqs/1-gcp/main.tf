locals {
  api =["logging.googleapis.com",
        "monitoring.googleapis.com", 
        "compute.googleapis.com", 
        "dns.googleapis.com", 
        "file.googleapis.com", 
        "container.googleapis.com", 
        "artifactregistry.googleapis.com", 
        "servicenetworking.googleapis.com", 
        "secretmanager.googleapis.com", 
        "networkmanagement.googleapis.com", 
        "datastore.googleapis.com",
        "iap.googleapis.com",
        "cloudbuild.googleapis.com",
        "cloudresourcemanager.googleapis.com",
        "secretmanager.googleapis.com"]
}

resource "google_project_service" "api" {
  for_each = toset(local.api)
  service = each.value
}

resource "google_storage_bucket" "state-storage" {
    name      = var.storageBucketName
    location  = var.location
    uniform_bucket_level_access = true

    versioning {
      enabled = true
    }

    lifecycle_rule {

        condition {
          days_since_noncurrent_time = 7
          num_newer_versions = 2
        }

        action {
          type = "Delete"
        }
    }
}

resource "google_project_iam_member" "project-iam" {
  project = var.project_id
  role    = "roles/owner"
  member  = var.user
}