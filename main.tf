terraform {
  required_version = ">= 0.14.9"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.63.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "range" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "range_vpc"
  }
}

resource "aws_security_group" "range_default_sg" {
  name        = "range_default_sg"
  description = "Range default security group"
  vpc_id      = aws_vpc.range.id
  ingress {
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    description      = "Allow all"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
  }

  egress {
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    description      = "Allow all"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
  }
}

resource "aws_internet_gateway" "range_gateway" {
  vpc_id = aws_vpc.range.id

  tags = {
    Name = "range_gateway"
  }
}

resource "aws_key_pair" "range_ssh_public_key" {
  key_name   = "range_key"
  public_key = var.range_ssh_public_key
}
