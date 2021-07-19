terraform {
  backend "s3" {
    region          = "eu-central-1"
    bucket          = "mattf2-s3"
    key             = "m8tt"
#    dynamodb_table  = "mattf-dynamo"
    max_retries     = 25
    encrypt         = true
  }
}

provider "aws" {
  region          = "eu-central-1"
  max_retries = "25"
  version     = "2.33.0"
}

provider "helm" {
  version        = "0.9.1"
  install_tiller = false
}

provider "external" {
  version = "1.2.0"
}

provider "null" {
  version = "2.1.2"
}

provider "template" {
  version = "2.1.2"
}
