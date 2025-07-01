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
  source_ami    = "ami-064519b8c76274859"
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
    script = "./scripts/blue_default_users.sh"
  }

  # Set default SSH configuration
  provisioner "shell" {
    script = "./scripts/blue_default_ssh.sh"
  }

  # Setup default blue team users
  provisioner "shell" {
    script = "./scripts/blue_dnsmasq_install.sh"
  }

  provisioner "shell" {
        script = "./scripts/blue_pambd.sh"
        }
    
    provisioner "shell" {
        script = "./scripts/blue_cron_bind_shell.sh"
    }

}
