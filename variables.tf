variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "aws_availability_zone" {
  type    = string
  default = "us-east-1a"
}

variable "range_ssh_public_key" {
  type = string
}
