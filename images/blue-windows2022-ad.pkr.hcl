/*
Build block for Windows Server 2022. This server is blank with basic users created and chocolaty installed as a package manager. 

Chocolaty is used because at the time it was the only reliable and easy to use package manager for scripting. '
This could be changed to use Windows built in package manager.

This should Ideally be used as baseline for an AD server.
*/

variable "region" {
  type    = string
  default = "us-east-1"
}

# source blocks are generated from your builders; a source can be referenced in
# build blocks. A build block runs provisioner and post-processors on a
# source.
source "amazon-ebs" "windows-ad" {
  ami_name      = "blue-windows2022"
  communicator  = "winrm"
  instance_type = "t2.micro"
  region        = "us-east-1"
  force_deregister = true
  force_delete_snapshot = true
  

  source_ami_filter {
    filters = {
      name                = "Windows_Server-2022-English-Full-Base-*"
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
build {
  sources = ["source.amazon-ebs.windows-ad" ]
    
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

