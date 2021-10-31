source "amazon-ebs" "kali" {

  ami_name      = "cofc-kali"
  instance_type = "t2.micro"
  region        = "us-east-1"
  source_ami    = "ami-0212d39aa1d70f26b"
  ssh_username  = "kali"
  ssh_pty       = "true"
  ssh_timeout   = "60m"
  subnet_id     = "subnet-1ad89f57"

}

build {

  name = "cofc-kali"
  sources = [
    "source.amazon-ebs.kali"
  ]

  provisioner "shell" {

    inline = [

      "sudo systemctl stop atftpd",
      "sudo systemctl disable atftpd",
      "sudo apt remove --purge atftpd -y",
      "sudo apt clean",
      "sudo apt autoremove -y",
      "sudo apt update",
      "sudo DEBIAN_FRONTEND=noninteractive apt full-upgrade -yq"

    ]

  } 

}

