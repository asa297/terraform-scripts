# apis.tf

resource "google_project_service" "speech_api" {
  project            = var.gcp_project_id
  service            = "speech.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "storage_api" {
  project            = var.gcp_project_id
  service            = "storage.googleapis.com"
  disable_on_destroy = false
}
