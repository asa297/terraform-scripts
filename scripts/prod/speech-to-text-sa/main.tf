# main.tf

# สร้าง Service Account
resource "google_service_account" "speech_to_text_sa" {
  project      = var.gcp_project_id
  account_id   = var.service_account_id
  display_name = var.service_account_display_name
}

# สร้าง Key และไฟล์ JSON
resource "google_service_account_key" "sa_key" {
  service_account_id = google_service_account.speech_to_text_sa.name
}

resource "local_file" "sa_key_json" {
  content  = base64decode(google_service_account_key.sa_key.private_key)
  filename = "${var.service_account_id}-credentials.json"
}
