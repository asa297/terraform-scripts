variable "project_id" { type = string }
variable "cloud_run_account_id" { type = string }
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

# --- (ใหม่) เปิดใช้งาน API ที่จำเป็น ---
resource "google_project_service" "apis" {
  project                    = var.project_id
  for_each                   = toset(["secretmanager.googleapis.com", "run.googleapis.com", "storage.googleapis.com"])
  service                    = each.key
  disable_dependent_services = false
  disable_on_destroy         = false
}

# --- 1. สร้าง Service Account สำหรับ Cloud Run Service ---
resource "google_service_account" "cloud_run_app_sa" {
  project      = var.project_id
  account_id   = var.cloud_run_account_id
  display_name = "Service Account for Cloud Run App"
}

# --- 2. ให้สิทธิ์ SA, IAM นี้ในการเข้าถึง Cloud Storage ---
resource "google_storage_bucket_iam_member" "cloud_run_access" {
  bucket = var.bucket_name
  role   = "roles/storage.objectAdmin"
  member = google_service_account.cloud_run_app_sa.member
}
resource "google_project_iam_member" "cloud_run_bucket_lister" {
  project = var.project_id
  role    = "roles/storage.objectAdmin"
  member  = google_service_account.cloud_run_app_sa.member

  depends_on = [google_service_account.cloud_run_app_sa]
}

# --- 3. สร้าง "กล่อง" Secret ที่ว่างเปล่า ---
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

# --- 3.1 สร้าง Secret Version สำหรับแต่ละ Service ---
resource "google_secret_manager_secret_version" "dotenv_secrets_version" {
  for_each       = google_secret_manager_secret.dotenv_secrets
  secret         = each.value.id
  secret_data_wo = "# This is a placeholder for .env data. Please update with real values in the GCP Secret Manager console."
}

# --- 4. ให้สิทธิ์ Cloud Run SA ในการเข้าถึง Secrets ---
resource "google_secret_manager_secret_iam_member" "secret_accessor" {
  for_each = google_secret_manager_secret.dotenv_secrets

  project   = var.project_id
  secret_id = each.value.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = google_service_account.cloud_run_app_sa.member

  depends_on = [
    google_secret_manager_secret_version.dotenv_secrets_version
  ]
}

# --- 5. สร้าง Cloud Run Services ทั้งหมดใน Resource เดียว ---
resource "google_cloud_run_v2_service" "default" {
  for_each = var.cloud_run_services

  project  = var.project_id
  name     = each.value.name
  location = var.cloud_run_location

  deletion_protection = false

  template {
    service_account = google_service_account.cloud_run_app_sa.email

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
