# outputs.tf

output "project_id" {
  description = "The GCP project ID"
  value       = var.project_id
}

output "pubsub_topics" {
  description = "List of created Pub/Sub topic names"
  value       = [for topic in google_pubsub_topic.topics : topic.name]
}

output "pubsub_subscriptions" {
  description = "List of created Pub/Sub subscription names"
  value       = [for subscription in google_pubsub_subscription.subscriptions : subscription.name]
}

output "service_account_email" {
  description = "Email of the created service account"
  value       = google_service_account.pubsub_gcs_sa.email
}

output "service_account_key_file" {
  description = "Path to the service account key file"
  value       = local_file.service_account_key.filename
  sensitive   = true
}

output "gcs_bucket_name" {
  description = "Name of the GCS bucket that the service account has access to"
  value       = var.storage_bucket_name
}
