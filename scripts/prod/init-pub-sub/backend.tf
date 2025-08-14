terraform {
  backend "gcs" {
    bucket = "campchang-pattaya-prod-tfstate"
    prefix = "init-pub-sub/terraform.tfstate"
  }
}
