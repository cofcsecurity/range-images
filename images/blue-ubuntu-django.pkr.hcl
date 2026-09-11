/*
WIP!!! THIS SERVER IS NOT CONFIGURED. WEB SERVICE IS NOT DEPLOYED.

This is the core range webserver. The server is written in Django but should be updated to something more relavent.
It is a simple unstyled html webserver that interacts with the databases on the range.

CURRENTLY ONLY PULLS DATA FROM CENTOS MYSQL SERVER. WINDOWS MARIABD IS NOT CONFIGURED TO INTERACT. 
THIS SHOULD BE UPDATED ASAP

*/
source "amazon-ebs" "ubuntu-web" {
  ami_name              = "blue-ubuntu-django"
  instance_type         = "t2.micro"
  region                = "us-east-1"
  ssh_username          = "ubuntu"
  force_deregister      = true
  force_delete_snapshot = true

  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
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

  sources = ["source.amazon-ebs.ubuntu-web" ]


  # Setup default blue team users
  provisioner "shell" {
    script = "./scripts/blue_default_users.sh"
  }

  # Set default SSH configuration
  provisioner "shell" {
    script = "./scripts/blue_default_ssh.sh"
  }

  provisioner "shell"{
    script = "./scripts/blue_apache_install.sh"
  }
}
