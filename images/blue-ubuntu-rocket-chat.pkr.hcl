

source "amazon-ebs" "ubuntu-bionic" {
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
}
