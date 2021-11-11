data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["blue-ubuntu-workstation"]
  }
}

data "aws_ami" "kali" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["red-kali"]
  }
}

data "aws_ami" "mongo" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["blue-ubuntu-mongodb"]
  }
}
