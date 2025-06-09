# modules/github-actions-sa/outputs.tf

output "service_account_email" {
  value       = google_service_account.sa.email
  description = "The email of the created service account for GitHub Actions."
}
