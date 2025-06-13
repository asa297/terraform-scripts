variable "project_id" { type = string }
variable "new_cloud_run_account_id" { type = string }
variable "bucket_name" { type = string }

resource "google_service_account" "cloud_run_app_sa" {
  project      = var.project_id
  account_id   = var.new_cloud_run_account_id
  display_name = "Service Account for Cloud Run App"
}

resource "google_storage_bucket_iam_member" "cloud_run_access" {
  bucket = var.bucket_name
  role   = "roles/storage.objectAdmin"
  member = google_service_account.cloud_run_app_sa.member
}

resource "google_project_iam_member" "cloud_run_bucket_lister" {
  project = var.project_id
  role    = "roles/storage.objectAdmin"
  member  = google_service_account.cloud_run_app_sa.member

  depends_on = [google_service_account.cloud_run_app_sa]
}

#
resource "google_service_account_iam_member" "sa_self_token_creator" {
  service_account_id = google_service_account.cloud_run_app_sa.name
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = google_service_account.cloud_run_app_sa.member

  depends_on = [google_service_account.cloud_run_app_sa]
}
