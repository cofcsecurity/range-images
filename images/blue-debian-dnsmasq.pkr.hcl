packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "debian-stretch" {
  ami_name = "blue-debian-dnsmasq"

  instance_type = "t2.micro"
  region        = "us-east-1"
  source_ami    = "ami-0f643787e21058389"
  ssh_username  = "admin"

  force_deregister      = true
  force_delete_snapshot = true

  tag {
    key   = "Name"
    value = "Range Image"
  }
}

build {
  name = "dnsmasq"

  sources = [
    "source.amazon-ebs.debian-stretch"
  ]

  # Setup default blue team users
  provisioner "shell" {
    script = "./images/scripts/blue_default_users.sh"
  }

  # Setup default blue team users
  provisioner "shell" {
    script = "./images/scripts/blue_dnsmasq_install.sh"
  }

}
