packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu-xenial" {
  ami_name              = "blue-ubuntu-jenkins"
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
  name = "jenkins"

  sources = [
    "source.amazon-ebs.ubuntu-xenial"
  ]

  # Setup default blue team users
  provisioner "shell" {
    script = "./images/scripts/blue_default_users.sh"
  }

  # Set default SSH configuration
  provisioner "shell" {
    script = "./images/scripts/blue_default_ssh.sh"
  }

  # Create systemd service to run a BIND shell on port 50250
  provisioner "shell" {
    environment_vars = ["PORT=50250"]
    script           = "./images/scripts/blue_systemd_bind_shell.sh"
  }

  # Install Jenkins
  provisioner "shell" {
    inline = [
      "wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -",
      "echo deb http://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null",
      "sudo apt update",
      "sudo apt install default-jre default-jdk -y",
      "sudo apt install jenkins -y",
    ]
  }
}
