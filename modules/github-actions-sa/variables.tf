# modules/github-actions-sa/variables.tf

variable "project_id" {
  type        = string
  description = "The project ID to create the service account in."
}

variable "service_account_id" {
  type        = string
  description = "The ID for the new service account."
}

variable "github_repos" {
  type        = list(string)
  description = "A list of GitHub repositories in 'owner/repo' format."
}

variable "roles" {
  type        = list(string)
  description = "List of IAM roles to grant to the service account."
  default     = []
}

variable "workload_identity_pool_id" {
  type        = string
  description = "The ID of the Workload Identity Pool."
}
