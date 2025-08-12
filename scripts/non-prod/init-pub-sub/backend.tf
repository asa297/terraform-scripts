terraform {
  backend "gcs" {
    bucket = "campchang-pattaya-non-prod-tfstate"
    prefix = "init-pub-sub/terraform.tfstate"
  }
}
