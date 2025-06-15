terraform {
  backend "gcs" {
    bucket = "campchang-pattaya-prod-tfstate"
    prefix = "init-cloud-run/terraform.tfstate"
  }
}
