packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu-bionic" {
  ami_name              = "blue-ubuntu-mongodb"
  instance_type         = "t2.micro"
  region                = "us-east-1"
  ssh_username          = "ubuntu"
  force_deregister      = true
  force_delete_snapshot = true

  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-bionic-18.04-amd64-server-*"
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
  name = "mongodb"

  sources = [
    "source.amazon-ebs.ubuntu-bionic"
  ]

  # Setup default blue team users
  provisioner "shell" {
    script = "./images/scripts/blue_default_users.sh"
  }

  # Install MongoDB
  provisioner "shell" {
    script = "./images/scripts/blue_mongodb_install.sh"
  }
}
