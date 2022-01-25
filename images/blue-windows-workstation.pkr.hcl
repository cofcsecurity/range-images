packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "windows-server" {
  ami_name              = "blue-windows-workstation"
  instance_type         = "t2.micro"
  region                = "us-east-1"
  force_deregister      = true
  force_delete_snapshot = true

  source_ami = "ami-0aad84f764a2bd39a"

  communicator   = "winrm"
  user_data_file = "./images/scripts/windows/win_bootstrap.txt"
  winrm_password = "range-replace-me"
  winrm_username = "Administrator"
  winrm_insecure = true
  winrm_use_ssl = true

  tag {
    key   = "Name"
    value = "Range Image"
  }
}

build {
  name = "workstation"

  sources = [
    "source.amazon-ebs.windows-server"
  ]

  provisioner "powershell" {
    inline = [
      "$Password = ConvertTo-SecureString `\"turing4ever`\" -AsPlainText -Force",
      "New-LocalUser `\"aturing`\" -Password $Password -FullName `\"Alan Turing`\"",
    ]
  }
}
