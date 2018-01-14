provider "aws" {
  region = "eu-central-1"
}

terraform {
  backend "s3" {
    bucket  = "digital-tf-state"
    key     = "m8tt-rds"
    region  = "eu-central-1"
    encrypt = true
    profile = "digit-all"
  }
}
