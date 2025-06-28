# iam.tf

# ให้สิทธิ์ในการใช้ Speech-to-Text (ระดับโปรเจกต์)
resource "google_project_iam_member" "speech_user_binding" {
  project = var.gcp_project_id
  role    = "roles/aiplatform.user"
  member  = "serviceAccount:${google_service_account.speech_to_text_sa.email}"
}
