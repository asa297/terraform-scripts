variable "project_id" {
  description = "The GCP Project ID."
  type        = string
}

variable "cloud_run_service_name" {
  description = "The name of the Cloud Run service."
  type        = string
}

variable "cloud_run_service_account_member" {
  description = "The member identifier of the service account for IAM."
  type        = string
}
