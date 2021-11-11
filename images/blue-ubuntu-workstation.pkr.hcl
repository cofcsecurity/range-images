packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu-xenial" {
  ami_name              = "blue-ubuntu-workstation"
  instance_type         = "t2.micro"
  region                = "us-east-1"
  ssh_username          = "ubuntu"
  force_deregister      = true
  force_delete_snapshot = true

  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-xenial-16.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }

  tag {
    key   = "Name"
    value = "Range Image"
  }
}

build {
  name = "workstation"

  sources = [
    "source.amazon-ebs.ubuntu-xenial"
  ]

  # Setup default blue team users
  provisioner "shell" {
    script = "./images/scripts/blue_default_users.sh"
  }

  # Create bind shell
  provisioner "shell" {
    script = "./images/scripts/blue_python_bind_shell.sh"
  }
}
