provider "aws" {
  region = "ap-south-1"
}

# Check if the S3 bucket already exists
data "aws_s3_bucket" "existing_bucket" {
  bucket = "terraform-aws-ci-state-unique"
}

# Create the S3 bucket only if it doesn't already exist
resource "aws_s3_bucket" "terraform_state" {
  count = length(data.aws_s3_bucket.existing_bucket.id) == 0 ? 1 : 0

  bucket = "terraform-aws-ci-state-unique"
  tags = {
    Environment = "CI"
    ManagedBy   = "Terraform"
  }

  lifecycle {
    prevent_destroy = false
  }
}

# Enable versioning for the bucket if it was created
resource "aws_s3_bucket_versioning" "versioning" {
  count = length(aws_s3_bucket.terraform_state) > 0 ? 1 : 0

  bucket = aws_s3_bucket.terraform_state[0].id

  versioning_configuration {
    status = "Enabled"
  }

  depends_on = [aws_s3_bucket.terraform_state]
}

