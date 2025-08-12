# main.tf

# Provider configuration
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# Enable required APIs
resource "google_project_service" "pubsub_api" {
  project = var.project_id
  service = "pubsub.googleapis.com"

  timeouts {
    create = "30m"
    update = "40m"
  }

  disable_dependent_services = true
}

# Pub/Sub Topics
resource "google_pubsub_topic" "topics" {
  for_each = toset(var.pubsub_topics)

  name    = each.value
  project = var.project_id

  labels = {
    environment = var.environment
    managed-by  = "terraform"
    purpose     = each.value
  }

  depends_on = [google_project_service.pubsub_api]
}

# Pub/Sub Subscriptions
resource "google_pubsub_subscription" "subscriptions" {
  for_each = toset(var.pubsub_topics)

  name    = "${each.value}_subscription"
  topic   = google_pubsub_topic.topics[each.key].name
  project = var.project_id

  # Message retention duration
  message_retention_duration = "1200s"

  # Acknowledge deadline
  ack_deadline_seconds = 30

  # Retry policy
  retry_policy {
    minimum_backoff = "10s"
    maximum_backoff = "600s"
  }

  labels = {
    environment = var.environment
    managed-by  = "terraform"
    purpose     = each.value
  }

  depends_on = [google_pubsub_topic.topics]
}

# Service Account สำหรับเข้าถึง Pub/Sub และ GCS
resource "google_service_account" "pubsub_gcs_sa" {
  account_id   = "pubsub-gcs-service-account"
  display_name = "Pub/Sub and GCS Service Account"
  project      = var.project_id
  description  = "Service account for accessing Pub/Sub topics and GCS bucket"
}

# IAM binding สำหรับ Pub/Sub Publisher
resource "google_pubsub_topic_iam_binding" "publisher" {
  for_each = toset(var.pubsub_topics)

  topic   = google_pubsub_topic.topics[each.key].name
  role    = "roles/pubsub.publisher"
  project = var.project_id

  members = [
    "serviceAccount:${google_service_account.pubsub_gcs_sa.email}",
  ]
}

# IAM binding สำหรับ Pub/Sub Subscriber
resource "google_pubsub_subscription_iam_binding" "subscriber" {
  for_each = toset(var.pubsub_topics)

  subscription = google_pubsub_subscription.subscriptions[each.key].name
  role         = "roles/pubsub.subscriber"
  project      = var.project_id

  members = [
    "serviceAccount:${google_service_account.pubsub_gcs_sa.email}",
  ]
}

# IAM binding สำหรับ GCS bucket access
resource "google_storage_bucket_iam_binding" "bucket_object_admin" {
  bucket = var.storage_bucket_name
  role   = "roles/storage.objectAdmin"

  members = [
    "serviceAccount:${google_service_account.pubsub_gcs_sa.email}",
  ]
}

# สร้าง Service Account Key
resource "google_service_account_key" "pubsub_gcs_sa_key" {
  service_account_id = google_service_account.pubsub_gcs_sa.name
  public_key_type    = "TYPE_X509_PEM_FILE"
}

# บันทึก Service Account Key เป็นไฟล์ JSON
resource "local_file" "service_account_key" {
  content  = base64decode(google_service_account_key.pubsub_gcs_sa_key.private_key)
  filename = "${path.module}/service-account.json"

  # ตั้งค่า file permissions ให้ปลอดภัย
  file_permission = "0600"
}
