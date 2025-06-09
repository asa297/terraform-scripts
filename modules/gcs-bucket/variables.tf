# modules/gcs-bucket/variables.tf

variable "project_id" {
  type        = string
  description = "The project ID to create the bucket in."
}

variable "name" {
  type        = string
  description = "The globally unique name of the bucket."
}

variable "location" {
  type        = string
  description = "The location of the bucket."
  default     = "ASIA-SOUTHEAST1"
}

variable "storage_class" {
  type        = string
  description = "The storage class of the bucket."
  default     = "STANDARD"
}

variable "versioning_enabled" {
  type        = bool
  description = "Flag to enable object versioning."
  default     = true
}

variable "lifecycle_rules" {
  type = list(object({
    age_in_days = number
    prefix      = optional(string) # ทำให้ prefix เป็น optional ไม่บังคับใส่
  }))
  description = "A list of lifecycle rules. Each rule object must have 'age_in_days' and can optionally have a 'prefix'."
  default     = []
}

variable "iam_members" {
  type        = map(list(string))
  description = "Map of IAM roles to a list of members. e.g. { 'roles/storage.objectAdmin' = ['serviceAccount:email@...'] }"
  default     = {}
}

variable "labels" {
  type        = map(string)
  description = "A map of labels to assign to the bucket."
  default     = {}
}
