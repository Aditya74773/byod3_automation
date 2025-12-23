provider "aws" {
  region = "us-east-1" 
}

resource "aws_s3_bucket" "test_bucket" {
  bucket = var.bucket_name
  tags = {
    Name        = "BYOD-3-Automation-Test"
    Environment = terraform.workspace == "default" ? "main" : terraform.workspace
  }
}

variable "bucket_name" {
  type        = string
  description = "The globally unique name for the S3 bucket"
}