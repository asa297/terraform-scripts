# outputs.tf

output "service_account_email" {
  value       = google_service_account.speech_to_text_sa.email
  description = "The email of the created service account."
}

output "credentials_file_name" {
  value       = local_file.sa_key_json.filename
  description = "The name of the generated credentials JSON file."
}
