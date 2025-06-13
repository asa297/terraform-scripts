variable "project_id" {
  description = "The GCP Project ID."
  type        = string
}

variable "location" {
  description = "The GCP region for the Cloud Run service."
  type        = string
}

variable "service_name" {
  description = "The name of the Cloud Run service."
  type        = string
}

variable "service_account_email" {
  description = "The email of the service account to run the service."
  type        = string
}

variable "service_account_member" {
  description = "The member identifier of the service account for IAM."
  type        = string
}
