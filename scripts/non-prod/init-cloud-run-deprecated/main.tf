variable "project_id" { type = string }
variable "bucket_name" { type = string }
variable "cloud_run_services" {
  description = "A map of Cloud Run services to create."
  type = map(object({
    name  = string
    image = string
  }))
}
variable "cloud_run_location" {
  description = "The location for Cloud Run services."
  type        = string
}
variable "cloud_run_sa_member" { type = string }
variable "cloud_run_sa_email" { type = string }

# --- (ใหม่) เปิดใช้งาน API ที่จำเป็น ---
resource "google_project_service" "apis" {
  project                    = var.project_id
  for_each                   = toset(["secretmanager.googleapis.com", "run.googleapis.com", "storage.googleapis.com"])
  service                    = each.key
  disable_dependent_services = false
  disable_on_destroy         = false
}

# --- สร้าง "กล่อง" Secret ที่ว่างเปล่า ---
resource "google_secret_manager_secret" "dotenv_secrets" {
  for_each = var.cloud_run_services

  project   = var.project_id
  secret_id = each.value.name

  replication {
    auto {

    }
  }

  depends_on = [google_project_service.apis]
}

# --- สร้าง Secret Version สำหรับแต่ละ Service ---
resource "google_secret_manager_secret_version" "dotenv_secrets_version" {
  for_each       = google_secret_manager_secret.dotenv_secrets
  secret         = each.value.id
  secret_data_wo = "# This is a placeholder for .env data. Please update with real values in the GCP Secret Manager console."
}

# --- ให้สิทธิ์ Cloud Run SA ในการเข้าถึง Secrets ---
resource "google_secret_manager_secret_iam_member" "secret_accessor" {
  for_each = google_secret_manager_secret.dotenv_secrets

  project   = var.project_id
  secret_id = each.value.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = var.cloud_run_sa_member

  depends_on = [
    google_secret_manager_secret_version.dotenv_secrets_version
  ]
}

# --- สร้าง Cloud Run Services ทั้งหมดใน Resource เดียว ---
resource "google_cloud_run_v2_service" "default" {
  for_each = var.cloud_run_services

  project  = var.project_id
  name     = each.value.name
  location = var.cloud_run_location

  deletion_protection = false

  template {
    service_account = var.cloud_run_sa_email

    # กำหนด Volume ที่จะใช้
    volumes {
      name = "dotenv-volume"
      secret {
        # อ้างอิง Secret ตามชื่อที่ถูกต้อง (คือชื่อ Service)
        secret = each.value.name
        items {
          version = "latest"
          path    = "dotenv" # นี่จะกลายเป็นชื่อไฟล์
        }
      }
    }

    containers {
      image = each.value.image

      # Mount Volume เข้าไปใน Container
      volume_mounts {
        name       = "dotenv-volume"
        mount_path = "/secrets/api" # ไดเรกทอรีที่จะ Mount เข้าไป
      }

      # สร้าง Environment Variable ที่ชี้ไปยัง Path ของไฟล์ Secret
      env {
        name  = "DOTENV_PATH"
        value = "/secrets/api/dotenv"
      }
    }
  }

  depends_on = [
    google_secret_manager_secret_iam_member.secret_accessor
  ]
}
