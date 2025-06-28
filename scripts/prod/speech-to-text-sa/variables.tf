# variables.tf

variable "gcp_project_id" {
  type        = string
  description = "The Google Cloud Project ID to deploy the resources in."
}

variable "service_account_id" {
  type        = string
  description = "The desired ID for the new service account."
  default     = "sa-speech-to-text"
}

variable "service_account_display_name" {
  type        = string
  description = "The display name for the new service account."
  default     = "Service Account for Speech-to-Text API"
}

variable "gcs_bucket_name" {
  type        = string
  description = "A globally unique name for the GCS bucket."
}

variable "gcs_bucket_location" {
  type        = string
  description = "The location/region for the GCS bucket."
  default     = "ASIA-SOUTHEAST1"
}
