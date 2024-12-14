# Create S3 Bucket
data "aws_s3_bucket" "existing_bucket" {
  bucket = "terraform-aws-ci-state-unique"
}

resource "aws_s3_bucket" "terraform_state" {
  count  = length(data.aws_s3_bucket.existing_bucket.id) == 0 ? 1 : 0
  bucket = "terraform-aws-ci-state-unique"
  force_destroy = true
}


# resource "aws_s3_bucket" "terraform_state" {
#   bucket = "terraform-aws-ci-state-unique" # Replace with a globally unique name
  
#   tags = {
#     Name        = "TerraformStateBucket"
#     Environment = "Prod"
#   }
#   lifecycle {
#     prevent_destroy = false
#   }

# }

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

