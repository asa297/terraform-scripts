# main.tf (ที่ root directory)

# (Optional) ประกาศตัวแปรสำหรับไฟล์หลัก
variable "project_id" { type = string }
variable "project_name" { type = string }
variable "billing_account" { type = string }
variable "github_repos" { type = list(string) }
variable "storage_bucket_name" { type = string }

# เรียกใช้งาน Module ที่ 1: สร้าง Project
module "gcp_project" {
  source = "../../modules/gcp-project" # บอกที่อยู่ของ module

  project_id      = var.project_id
  project_name    = var.project_name
  billing_account = var.billing_account
}


# เรียกใช้งาน Module ที่ 2: ตั้งค่า Firebase
module "firebase_auth" {
  source = "../../modules/firebase-auth"

  project_id = module.gcp_project.project_id
}


# 5. เรียกใช้งาน Module ที่ 5: สร้าง Cloud Storage Bucket
module "artifact_storage" {
  source     = "../../modules/gcs-bucket"
  project_id = var.project_id
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

# # 3. สร้าง Workload Identity Pool และ Provider (ทำครั้งเดียวต่อโปรเจกต์)
# resource "google_iam_workload_identity_pool" "github_pool" {
#   project                   = var.project_id
#   workload_identity_pool_id = "github-actions-pool"
#   display_name              = "GitHub Actions Pool"
#   description               = "Identity pool for GitHub Actions"

#   depends_on = [
#     module.gcp_project # รอให้โปรเจกต์ถูกสร้างก่อน
#   ]
# }

# resource "google_iam_workload_identity_pool_provider" "github_provider" {
#   project                            = var.project_id
#   workload_identity_pool_id          = google_iam_workload_identity_pool.github_pool.workload_identity_pool_id
#   workload_identity_pool_provider_id = "github-actions-provider"
#   display_name                       = "GitHub Actions Provider"
#   attribute_mapping = {
#     "google.subject"       = "assertion.sub"
#     "attribute.actor"      = "assertion.actor"
#     "attribute.repository" = "assertion.repository"
#   }
#   oidc {
#     issuer_uri = "https://token.actions.githubusercontent.com"
#   }

#   depends_on = [
#     module.gcp_project # รอให้โปรเจกต์ถูกสร้างก่อน
#   ]
# }

# # 4. เรียกใช้งาน Module ที่ 3: สร้าง Service Account สำหรับ GitHub Actions
# module "github_actions_sa" {
#   source = "../../modules/github-actions-sa"

#   project_id                = var.project_id
#   service_account_id        = "github-actions-runner" # ตั้งชื่อ SA ที่ต้องการ
#   github_repos              = var.github_repos
#   workload_identity_pool_id = google_iam_workload_identity_pool.github_pool.workload_identity_pool_id

#   # กำหนดสิทธิ์ที่จำเป็นสำหรับ CI/CD ที่นี่
#   roles = [
#     "roles/artifactregistry.admin",
#     "roles/run.admin",
#     "roles/iam.serviceAccountUser" # Service Account User: สิทธิ์ในการ "สวมรอย" หรือใช้งาน Service Account อื่น (สำคัญตอน deploy Cloud Run ที่ระบุ SA ของตัวเอง)
#   ]

#   depends_on = [
#     google_iam_workload_identity_pool_provider.github_provider
#   ]
# }

# # 5. เรียกใช้งาน Module ที่ 5: สร้าง Cloud Storage Bucket
# module "artifact_storage" {
#   source     = "../../modules/gcs-bucket"
#   project_id = var.project_id
#   name       = var.storage_bucket_name

#   # กำหนดค่าต่างๆ สำหรับ Bucket
#   lifecycle_rules = [
#     {
#       # สำหรับ path /temp-uploads/
#       prefix      = "temp-uploads/" # อย่าลืมใส่ / ปิดท้าย
#       age_in_days = 30
#     },
#   ]

#   # (สำคัญ) ให้สิทธิ์ Service Account ของ GitHub Actions เป็นผู้ดูแล Object ใน Bucket นี้
#   iam_members = {
#     "roles/storage.objectAdmin" = [
#       "serviceAccount:${module.github_actions_sa.service_account_email}"
#     ]
#   }

#   labels = {
#     "managed-by" = "terraform"
#     "purpose"    = "ci-cd-artifacts"
#   }

#   depends_on = [
#     module.github_actions_sa
#   ]
# }
