# main.tf (ที่ root directory)

# (Optional) ประกาศตัวแปรสำหรับไฟล์หลัก
variable "project_id" { type = string }
variable "project_name" { type = string }
variable "billing_account" { type = string }
variable "storage_bucket_name" { type = string }

# เรียกใช้งาน Module ที่ 1: สร้าง Project
module "gcp_project" {
  source = "../../../modules/gcp-project" # บอกที่อยู่ของ module

  project_id      = var.project_id
  project_name    = var.project_name
  billing_account = var.billing_account
}

# เรียกใช้งาน Module ที่ 2: ตั้งค่า Firebase
module "firebase_auth" {
  source = "../../../modules/firebase-auth"

  project_id = module.gcp_project.project_id
}

# 5. เรียกใช้งาน Module ที่ 5: สร้าง Cloud Storage Bucket
module "artifact_storage" {
  source     = "../../../modules/gcs-bucket"
  project_id = module.gcp_project.project_id
  name       = var.storage_bucket_name

  # กำหนดค่าต่างๆ สำหรับ Bucket
  lifecycle_rules = [
    {
      # สำหรับ path /temp-uploads/
      prefix      = "temp-uploads/" # อย่าลืมใส่ / ปิดท้าย
      age_in_days = 30
    },
  ]

  labels = {
    "managed-by" = "terraform"
    "purpose"    = "ci-cd-artifacts"
  }
}
