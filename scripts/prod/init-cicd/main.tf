# main.tf (ที่ root directory)

# (Optional) ประกาศตัวแปรสำหรับไฟล์หลัก
variable "project_id" { type = string }
variable "workload_identity_pool_id" { type = string }
variable "service_account_id" { type = string }
variable "github_owner" { type = string }
variable "github_repos" { type = list(string) }
variable "gar_location" { type = string }
variable "gar_repository_name" { type = string }

# เพิ่ม resource สำหรับเปิดใช้งาน API ที่จำเป็น
resource "google_project_service" "apis" {
  project                    = var.project_id
  for_each                   = toset(["iamcredentials.googleapis.com", "artifactregistry.googleapis.com"])
  service                    = each.key
  disable_dependent_services = false
  disable_on_destroy         = false
}

# สร้าง Workload Identity Pool และ Provider (ทำครั้งเดียวต่อโปรเจกต์)
resource "google_iam_workload_identity_pool" "github_pool" {
  project                   = var.project_id
  workload_identity_pool_id = var.workload_identity_pool_id
  display_name              = "GitHub Actions Pool"
  description               = "Identity pool for GitHub Actions"
}

resource "google_iam_workload_identity_pool_provider" "github_provider" {
  project                            = var.project_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.github_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-actions-provider"
  display_name                       = "GitHub Actions Provider"
  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.actor"      = "assertion.actor"
    "attribute.repository" = "assertion.repository"
  }

  attribute_condition = "attribute.repository.startsWith('${var.github_owner}/')"
  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }

  depends_on = [
    google_iam_workload_identity_pool.github_pool
  ]
}

resource "google_service_account" "github_actions_sa" {
  project      = var.project_id
  account_id   = var.service_account_id
  display_name = "Service Account for GitHub Actions CI/CD"
}

resource "google_service_account_iam_binding" "github_workload_identity_user" {
  service_account_id = google_service_account.github_actions_sa.name
  role               = "roles/iam.workloadIdentityUser"

  members = [
    for repo in var.github_repos : "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github_pool.name}/attribute.repository/${repo}"
  ]
}

resource "google_project_iam_member" "github_sa_cloud_run_admin" {
  project = var.project_id
  role    = "roles/run.admin"
  member  = google_service_account.github_actions_sa.member
}

resource "google_project_iam_member" "github_sa_iam_user" {
  project = var.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = google_service_account.github_actions_sa.member
}

resource "google_project_iam_member" "github_sa_artifact_registry_admin" {
  project = var.project_id
  role    = "roles/artifactregistry.admin"
  member  = google_service_account.github_actions_sa.member
}

# สร้าง Artifact Registry Repository สำหรับเก็บ Docker images
resource "google_artifact_registry_repository" "my_repository" {
  project = var.project_id

  location = var.gar_location

  repository_id = var.gar_repository_name

  format = "DOCKER"

  depends_on = [google_project_service.apis]
}
