terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "splunk_sg" {
  name        = "splunk_security_group"
  description = "Allow SSH and Splunk Web UI"

  # Prevents the "Still destroying" deadlock error
  lifecycle {
    create_before_destroy = true
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "splunk_server" {
  ami           = "ami-0ecb62995f68bb549" 
  instance_type = "t2.medium"           
  key_name      = "Aadii_new"

  vpc_security_group_ids = [aws_security_group.splunk_sg.id]

  tags = {
    Name = "Splunk-Server-Task1"
  }
}