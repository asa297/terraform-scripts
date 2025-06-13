# --- สร้าง "กล่อง" Secret ที่ว่างเปล่าสำหรับ Service นี้ ---
resource "google_secret_manager_secret" "dotenv_secret" {
  project   = var.project_id
  secret_id = var.service_name # ใช้ชื่อ Service เป็น ID ของ Secret

  replication {
    auto {}
  }
}

# --- สร้าง Secret Version เริ่มต้น ---
resource "google_secret_manager_secret_version" "dotenv_secret_version" {
  secret         = google_secret_manager_secret.dotenv_secret.id
  secret_data_wo = "# This is a placeholder for .env data. Please update with real values in the GCP Secret Manager console."
}

# --- ให้สิทธิ์ Cloud Run SA ในการเข้าถึง Secret นี้ ---
resource "google_secret_manager_secret_iam_member" "secret_accessor" {
  project   = var.project_id
  secret_id = google_secret_manager_secret.dotenv_secret.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = var.service_account_member

  depends_on = [google_secret_manager_secret_version.dotenv_secret_version]
}

# --- สร้าง Cloud Run Service ---
resource "google_cloud_run_v2_service" "default" {
  project  = var.project_id
  name     = var.service_name
  location = var.location

  deletion_protection = false

  template {
    service_account = var.service_account_email

    volumes {
      name = "dotenv-volume"
      secret {
        secret = google_secret_manager_secret.dotenv_secret.secret_id
        items {
          version = "latest"
          path    = "dotenv"
        }
      }
    }

    containers {
      image = "us-docker.pkg.dev/cloudrun/container/hello"

      volume_mounts {
        name       = "dotenv-volume"
        mount_path = "/secrets/api"
      }

      env {
        name  = "DOTENV_PATH"
        value = "/secrets/api/dotenv"
      }
    }
  }

  depends_on = [google_secret_manager_secret_iam_member.secret_accessor]
}
