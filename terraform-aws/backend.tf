# Create S3 Bucket
resource "aws_s3_bucket" "terraform_state" {
  bucket = "terra-project-unique-name-state" # Replace with a globally unique name
  
  tags = {
    Name        = "TerraformStateBucket"
    Environment = "Dev"
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



# Backend Configuration
terraform {
  backend "s3" {
    bucket         = "terra-project-unique-name-state"
    key            = "terraform/state.tfstate"
    region         = var.region
    
  }
}