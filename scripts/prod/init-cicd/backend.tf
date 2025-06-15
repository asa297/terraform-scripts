terraform {
  backend "gcs" {
    bucket = "campchang-pattaya-prod-tfstate"
    prefix = "init-cicd/terraform.tfstate"
  }
}
