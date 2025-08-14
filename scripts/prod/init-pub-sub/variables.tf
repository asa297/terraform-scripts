# variables.tf

variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "storage_bucket_name" {
  description = "Name of the GCS bucket to grant access to"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., non-prod, prod)"
  type        = string
  default     = "prod"
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "asia-southeast1"
}

variable "pubsub_topics" {
  description = "List of Pub/Sub topics to create"
  type        = list(string)
  default     = ["printer_queue_agent", "submit_print", "sync_print_status"]
}
