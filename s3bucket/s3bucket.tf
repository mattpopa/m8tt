provider "aws" {
  region = "eu-central-1"
}

# terraform state file setup
# create an S3 bucket to store the state file in
resource "aws_s3_bucket" "mattf-state-storage-s3" {
  bucket = "mattf2-s3"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }

  tags {
    Name = "mattf temporary testing"
  }
}
