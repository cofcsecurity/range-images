packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu-web" {
  ami_name              = "blue-ubuntu-cyberweb"
  instance_type         = "t2.micro"
  region                = "us-east-1"
  ssh_username          = "ubuntu"
  force_deregister      = true
  force_delete_snapshot = true

  # Filter here to find the most recent version of Ubuntu 24.04 release 
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-noble-24.04-amd64-server-*"
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
    "source.amazon-ebs.ubuntu-web"
  ]

  # Setup default blue team users
  provisioner "shell" {
    script = "./scripts/blue_default_users.sh"
  }

  # Set default SSH configuration
  provisioner "shell" {
    script = "./scripts/blue_default_ssh.sh"
  }

  provisioner "shell"{
    script = "./scripts/blue_webserver_setup.sh"
  }
}
