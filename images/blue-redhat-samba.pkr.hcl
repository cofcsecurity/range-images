packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "samba" {
  ami_name              = "blue-redhat-samba"
  instance_type         = "t2.micro"
  region                = "us-east-1"
  source_ami            = "ami-098f16afa9edf40be"
  ssh_username          = "ec2-user"
  force_deregister      = true
  force_delete_snapshot = true

  tag {
    key   = "Name"
    value = "Range Image"
  }
}

build {

  name = "Samba"
  sources = [
    "source.amazon-ebs.samba"
  ]

  # Setup default blue team users
  provisioner "shell" {
    environment_vars = ["ADMIN_GROUP=wheel"]
    script = "./images/scripts/blue_default_users.sh"
  }

  # Set default SSH configuration
  provisioner "shell" {
    script = "./images/scripts/blue_default_ssh.sh"
  }
  
  # Install Samba and share /etc
  provisioner "shell" {
    script           = "./images/scripts/blue_rhel_samba.sh"
  }
}
