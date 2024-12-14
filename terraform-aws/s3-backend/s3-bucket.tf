# Create S3 Bucket
resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-aws-ci-state-unique" # Replace with a globally unique name
  
  tags = {
    Name        = "TerraformStateBucket"
    Environment = "Prod"
  }
  lifecycle {
    prevent_destroy = false
  }

}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}