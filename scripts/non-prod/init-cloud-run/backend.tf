terraform {
  backend "gcs" {
    bucket = "campchang-pattaya-non-prod-tfstate"
    prefix = "init-cloud-run/terraform.tfstate"
  }
}
