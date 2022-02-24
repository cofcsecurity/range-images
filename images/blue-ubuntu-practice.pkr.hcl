

source "amazon-ebs" "ubuntu-xenial" {
  ami_name              = "blue-ubuntu-practice"
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
  name = "practice"

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

  # Install MongoDB
  provisioner "shell" {
    script = "./images/scripts/blue_mongodb_install.sh"
  }

  # Create systemd service to run a BIND shell on port 50250
  provisioner "shell" {
    environment_vars = ["PORT=50250"]
    script           = "./images/scripts/blue_systemd_bind_shell.sh"
  }

  # Create cron job to run a BIND shell on port 3333"
  provisioner "shell" {
    environment_vars = ["PORT=3333"]
    script           = "./images/scripts/blue_cron_bind_shell.sh"
  }
}
