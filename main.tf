terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      # Changed from ~> 5.0 to >= 5.0 to allow the newer version in your state file
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Security Group for Task 1 & 4
resource "aws_security_group" "splunk_sg" {
  name        = "splunk_security_group"
  description = "Allow SSH and Splunk Web UI"

  # SSH Access for Ansible
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Splunk Web UI Port
  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound Internet Access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance for Task 1
resource "aws_instance" "splunk_server" {
  ami           = "ami-0ecb62995f68bb549" # Ubuntu 22.04 LTS
  instance_type = "t2.medium"           # 2 vCPU and 4GB RAM is better for Splunk
  key_name      = "Aadii_new"

  # --- CRITICAL FIX: Increased disk space to prevent "No space left on device" ---
  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  vpc_security_group_ids = [aws_security_group.splunk_sg.id]

  tags = {
    Name = "Splunk-Server-Task1"
  }
}