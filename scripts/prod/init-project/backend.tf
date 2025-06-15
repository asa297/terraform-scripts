terraform {
  backend "gcs" {
    bucket = "campchang-pattaya-prod-tfstate"
    prefix = "init-project/terraform.tfstate"
  }
}
