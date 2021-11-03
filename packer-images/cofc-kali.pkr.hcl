source "amazon-ebs" "kali" {

  ami_name      = "cofc-kali"
  instance_type = "t2.micro"
  region        = "us-east-1"
  source_ami    = "ami-0212d39aa1d70f26b" # kali AMI ID for future reference...
  ssh_username  = "kali"                  # non-root user to ssh into the machine with
  ssh_pty       = "true"                  # spawn a tty for executing commands
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

      "sudo systemctl stop atftpd",        # service that was causing issues... stop
      "sudo systemctl disable atftpd",     # service that was causing issues... disable
      "sudo apt remove --purge atftpd -y", # remove the service from the machine
      "sudo apt clean",                    # clean the repos 
      "sudo apt autoremove -y",            # remove uneccessary packages
      "sudo apt update",
      "sudo DEBIAN_FRONTEND=noninteractive apt full-upgrade -yq" # update the packages without any interactive prompts and defaulting to yes for them

    ]

  }

}

