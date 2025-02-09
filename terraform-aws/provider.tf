provider "aws" {
  region = var.region
}


# Backend Configuration
terraform {
  backend "s3" {
    bucket         = "terraform-aws-ci-state-unique-saik"
    key            = "terraform/state.tfstate"
    region         = "ap-south-1"
    
  }
}
