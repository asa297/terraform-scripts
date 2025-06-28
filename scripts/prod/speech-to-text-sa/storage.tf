# storage.tf

# สร้าง GCS Bucket ใหม่
resource "google_storage_bucket" "speech_bucket" {
  project       = var.gcp_project_id
  name          = var.gcs_bucket_name
  location      = var.gcs_bucket_location
  force_destroy = true # ตั้งเป็น true เพื่อให้ลบ bucket ได้ง่ายตอนทดลอง (Production ควรเป็น false)

  uniform_bucket_level_access = true # Best practice

  # Lifecycle rule เพื่อลบไฟล์ที่เก่ากว่า 1 วัน
  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 1 # ลบไฟล์ที่เก่ากว่า 1 วัน
    }
  }

  depends_on = [
    google_project_service.storage_api, # ต้องเปิดใช้งาน Storage API ก่อน
  ]
}

# ให้สิทธิ์ Service Account ในการอัปโหลด/จัดการไฟล์ใน Bucket นี้
resource "google_storage_bucket_iam_member" "gcs_object_admin_binding" {
  bucket = google_storage_bucket.speech_bucket.name
  role   = "roles/storage.objectAdmin"
  member = google_service_account.speech_to_text_sa.member
}
