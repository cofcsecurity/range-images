source "amazon-ebs" "rh" {
  ami_name              = "blue-ubuntu-docker" # our AMI name
  instance_type         = "t2.micro"
  region                = "us-east-1"
  source_ami            = "ami-024b40a354b860dbd" # base ami
  ssh_username          = "ec2-user" # ssh user for configing the EC2
  ssh_pty               = "true"     # spawn a pseudo terminal to execute commands
  ssh_timeout           = "60m"
  force_deregister      = true
  force_delete_snapshot = true

  tag {
    key   = "Name"
    value = "Docker"
  }


build {

  name = "blue-ubuntu-docker"
  sources = [
    "source.amazon-ebs.rh"
  ]

}

provisioner "shell" { # provisioner for installing wordpress

    inline = [

        

    ]

}


}