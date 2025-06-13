# --- สร้าง "กล่อง" Secret ที่ว่างเปล่าสำหรับ Service นี้ ---
resource "google_secret_manager_secret" "dotenv_secret" {
  project   = var.project_id
  secret_id = var.cloud_run_service_name # ใช้ชื่อ Service เป็น ID ของ Secret

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
  member    = var.cloud_run_service_account_member

  depends_on = [google_secret_manager_secret_version.dotenv_secret_version]
}
