output "cloud_run_sa_email" {
  description = "The email address of the Cloud Run service account."
  value       = google_service_account.cloud_run_app_sa.email
}

output "cloud_run_sa_member" {
  description = "The IAM-compatible member identifier for the Cloud Run service account."
  value       = google_service_account.cloud_run_app_sa.member
}

output "cloud_run_sa_name" {
  description = "The full resource name of the Cloud Run service account."
  value       = google_service_account.cloud_run_app_sa.name
}

output "cloud_run_sa_unique_id" {
  description = "The unique, numeric ID of the Cloud Run service account."
  value       = google_service_account.cloud_run_app_sa.unique_id
}
