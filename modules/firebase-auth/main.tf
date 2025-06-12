# modules/firebase-auth/main.tf

terraform {
  required_providers {
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 6.0"
    }
  }
}

# Configures the provider to use the resource block's specified project for quota checks.
provider "google-beta" {
  user_project_override = true
}

# Configures the provider to not use the resource block's specified project for quota checks.
# This provider should only be used during project creation and initializing services.
provider "google-beta" {
  alias                 = "no_user_project_override"
  user_project_override = false
}

# เปิดใช้งาน API ที่จำเป็นสำหรับ Firebase และ Auth
resource "google_project_service" "project_apis" {
  provider = google-beta.no_user_project_override
  project  = var.project_id # รับ project_id มาจากตัวแปร
  for_each = toset([
    "cloudbilling.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "firebase.googleapis.com",
    "serviceusage.googleapis.com",
    "identitytoolkit.googleapis.com",
  ])
  service = each.key

  # Don't disable the service if the resource block is removed by accident.
  # disable_on_destroy = false
  disable_on_destroy         = true # ปิดการใช้งาน API เมื่อ resource นี้ถูกลบ
  disable_dependent_services = true
}

# เพิ่ม Firebase ไปยัง GCP Project
resource "google_firebase_project" "firebase_activation" {
  provider = google-beta
  project  = var.project_id

  depends_on = [
    google_project_service.project_apis
  ]
}

# กำหนดค่า Firebase Authentication (Identity Platform)
resource "google_identity_platform_config" "auth_config" {
  provider = google-beta
  project  = var.project_id

  sign_in {
    email {
      enabled = true
    }
  }

  depends_on = [
    google_firebase_project.firebase_activation
  ]
}

# Creates a Firebase Web App in the new project created above.
resource "google_firebase_web_app" "auth" {
  provider     = google-beta
  project      = var.project_id
  display_name = "My Web app"

  depends_on = [
    google_identity_platform_config.auth_config
  ]
}
