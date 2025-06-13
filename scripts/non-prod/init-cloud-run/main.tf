variable "project_id" { type = string }
variable "cloud_run_location" { type = string }
variable "cloud_run_services" {
  description = "A map of Cloud Run services to create."
  type = map(object({
  }))
}
variable "cloud_run_sa_email" {
  description = "The email of the service account to run the Cloud Run services."
  type        = string
}
variable "cloud_run_sa_member" {
  description = "The member identifier of the service account for IAM."
  type        = string
}

# --- เปิดใช้งาน API ที่จำเป็น ---
resource "google_project_service" "apis" {
  project                    = var.project_id
  for_each                   = toset(["secretmanager.googleapis.com", "run.googleapis.com", "storage.googleapis.com"])
  service                    = each.key
  disable_dependent_services = false
  disable_on_destroy         = false
}

# --- create Service Account for Cloud Run Services ---
module "cloud_run_services" {
  source   = "../../../modules/cloud-run"
  for_each = var.cloud_run_services

  project_id             = var.project_id
  location               = var.cloud_run_location
  service_name           = each.key # ใช้ key ของ map เป็นชื่อ service
  service_account_email  = var.cloud_run_sa_email
  service_account_member = var.cloud_run_sa_member

  depends_on = [
    google_project_service.apis,
  ]
}
