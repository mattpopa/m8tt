terraform {
  backend "s3" {
    bucket  = "digital-tf-state"
    key     = "m8tt"
    region  = "eu-central-1"
    encrypt = true
    profile = "digit-all"
  }
}
