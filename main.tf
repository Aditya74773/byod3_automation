# provider "aws" {
#   region = "us-east-1" 
# }

# resource "aws_s3_bucket" "test_bucket" {
#   bucket = var.bucket_name
#   tags = {
#     Name        = "BYOD-3-Automation-Test"
#     Environment = terraform.workspace == "default" ? "main" : terraform.workspace
#   }
# }

# variable "bucket_name" {
#   type        = string
#   description = "The globally unique name for the S3 bucket"
# }

# provider "aws" {
#   region = "us-east-1"
# }

# resource "aws_instance" "splunk_server" {
#   ami           = "ami-0ecb62995f68bb549" # Ubuntu 22.04 LTS
#   instance_type = "t2.medium"             # Required for Splunk performance
#   key_name      = "Aadiibyod"              # Must match your AWS Key Pair name

#   tags = {
#     Name = "Splunk-Server-Task1"
#   }
# }

# # These outputs are CRITICAL for Task 1
# output "instance_public_ip" {
#   value = aws_instance.splunk_server.public_ip
# }

# output "instance_id" {
#   value = aws_instance.splunk_server.id
# }

resource "aws_instance" "splunk_server" {
  ami           = "ami-0ecb62995f68bb549"
  instance_type = "t2.medium"
  key_name      = "Aadii_new"  # Change this to your new key name
  
  tags = {
    Name = "Splunk-Server-Task1"
  }
}