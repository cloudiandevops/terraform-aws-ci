# # Create S3 Bucket
# data "aws_s3_bucket" "existing_bucket" {
#   bucket = "terraform-aws-ci-state-unique"
# }

# resource "aws_s3_bucket" "terraform_state" {
#   count  = length(data.aws_s3_bucket.existing_bucket.id) == 0 ? 1 : 0
#   bucket = "terraform-aws-ci-state-unique"
#   force_destroy = true
# }


# # resource "aws_s3_bucket" "terraform_state" {
# #   bucket = "terraform-aws-ci-state-unique" # Replace with a globally unique name
  
# #   tags = {
# #     Name        = "TerraformStateBucket"
# #     Environment = "Prod"
# #   }
# #   lifecycle {
# #     prevent_destroy = false
# #   }

# # }

# resource "aws_s3_bucket_versioning" "versioning" {
#   bucket = aws_s3_bucket.terraform_state.id

#   versioning_configuration {
#     status = "Enabled"
#   }
# }


provider "aws" {
  region = "ap-south-1"
}

# Check if the S3 bucket already exists
data "aws_s3_bucket" "existing_bucket" {
  bucket = "terraform-aws-ci-state-unique"
  # Use the actual bucket name here
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

