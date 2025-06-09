# modules/github-actions-sa/main.tf

# 1. สร้าง Service Account
resource "google_service_account" "sa" {
  project      = var.project_id
  account_id   = var.service_account_id
  display_name = "Service Account for GitHub Actions"
}

# 2. ให้สิทธิ์ (Roles) ที่จำเป็นกับ Service Account นี้
#    เพื่อให้มันสามารถทำงาน CI/CD ได้ (เช่น deploy Cloud Run, push image)
resource "google_project_iam_member" "sa_roles" {
  for_each = toset(var.roles) # วนลูปตาม list ของ roles ที่รับเข้ามา

  project = var.project_id
  role    = each.key
  member  = google_service_account.sa.member
}

# 3. (สำคัญ) ผูก Service Account เข้ากับ GitHub Repo ผ่าน Workload Identity
#    อนุญาตให้ GitHub repo ที่ระบุ สามารถ "สวมรอย" เป็น Service Account นี้ได้
resource "google_service_account_iam_binding" "workload_identity_user" {
  service_account_id = google_service_account.sa.name
  role               = "roles/iam.workloadIdentityUser"

  members = [
    for repo in var.github_repos : "principalSet://iam.googleapis.com/${var.workload_identity_pool_id}/attribute.repository/${repo}"
  ]
}
