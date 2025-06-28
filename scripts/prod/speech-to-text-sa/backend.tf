terraform {
  backend "gcs" {
    bucket = "campchang-pattaya-prod-tfstate"
    prefix = "speech-to-text-sa/terraform.tfstate"
  }
}
