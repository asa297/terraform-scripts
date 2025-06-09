# modules/gcp-project/variables.tf

variable "project_id" {
  type        = string
  description = "The desired, unique ID for the new GCP project."
}

variable "project_name" {
  type        = string
  description = "The display name for the new GCP project."
}

variable "billing_account" {
  type        = string
  description = "The billing account ID to associate with the new project."
}
