/*
WIP!!! CURRENTLY DOES NOT WORK. NO DNS IS WORKING WITHIN THE RANGE ENVIRONMENT
NEVER TOUCHED OTHER THAN EDITING EXISTING SCRIPTS. MAY NEED TO BE REWORKED FROM SCRATCH.

This is the build file for the main DNS server on the network. Uses Ubuntu server currently
with dnsmasq as the service to serve DNS. 

*/
source "amazon-ebs" "debian-stretch" {
  ami_name = "blue-debian-dnsmasq"

  instance_type = "t2.micro"
  region        = "us-east-1"
  source_ami_filter {
    filters = {
      name                = "debian-11-amd64-*"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["136693071363"] # Debian official
  }
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

  sources = ["source.amazon-ebs.debian-stretch" ]

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
}
