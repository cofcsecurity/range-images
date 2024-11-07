packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.1"
      source = "github.com/hashicorp/amazon"
    }
  }
}

variable "region" {
  type    = string
  default = "us-east-1"
}

# source blocks are generated from your builders; a source can be referenced in
# build blocks. A build block runs provisioner and post-processors on a
# source.
source "amazon-ebs" "firstrun-windows" {
  ami_name      = "blue-windows2022"
  communicator  = "winrm"
  instance_type = "t2.micro"
  region        = "us-east-1"
  force_deregister = true
  force_delete_snapshot = true
  

  source_ami_filter {
    filters = {
      name                = "Windows_Server-2022-English-Full-Base-2024.01.10"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
      
    }
    most_recent = true
    owners      = ["amazon"]
  }

  tag {
    key   = "Name"
    value = "Range Image"
  }

  user_data_file = "./scripts/winrm_for_packer.ps1"
  winrm_password = "SuperS3cr3t!!!!"
  winrm_username = "Administrator"
}

# a build block invokes sources and runs provisioning steps on them.
build {
  name    = "learn-packer"   
  sources = ["source.amazon-ebs.firstrun-windows"]


  provisioner "windows-restart" {
  }
  provisioner "powershell" {
    script = "./scripts/blue_default_users_windows.ps1"
  }
  provisioner "powershell" {
    script = "./scripts/blue_default_group_policy.ps1"
  }
  provisioner "powershell" {
    script = "./scripts/blue_windows_chocolatey.ps1"
  }
  provisioner "powershell" {
    script = "./scripts/blue_install_mariadb.ps1"
  }
}

