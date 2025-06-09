# modules/gcs-bucket/outputs.tf

output "bucket_name" {
  value       = google_storage_bucket.bucket.name
  description = "The name of the GCS bucket."
}

output "bucket_url" {
  value       = google_storage_bucket.bucket.url
  description = "The gsutil URL of the GCS bucket."
}
