terraform {
  backend "gcs" {
    bucket = "campchang-pattaya-non-prod-tfstate"
    prefix = "init-project/terraform.tfstate"
  }
}
