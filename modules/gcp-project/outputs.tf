# modules/gcp-project/outputs.tf

# ส่งต่อค่า project_id ที่ได้จาก resource "google_project" "new_project"
# ที่ถูกสร้างในไฟล์ main.tf ของโมดูลนี้
output "project_id" {
  description = "The ID of the created GCP project."
  value       = google_project.new_project.project_id
}
