# providers.tf

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.0"
    }
  }
}

provider "google" {
  # Terraform จะใช้ Credentials จาก gcloud ที่คุณได้ login ไว้โดยอัตโนมัติ
  # คุณสามารถระบุ project ID ที่นี่ หรือจะระบุในไฟล์ variables ก็ได้
}
