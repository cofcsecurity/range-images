
source "amazon-ebs" "rh" {
  ami_name              = "blue-redhat-lamp" # our AMI name
  instance_type         = "t2.micro"
  region                = "us-east-1"
  source_ami            = "ami-024b40a354b860dbd" # base ami
  ssh_username          = "ubuntu"                # ssh user for configing the EC2
  ssh_pty               = "true"                  # spawn a pseudo terminal to execute commands
  ssh_timeout           = "60m"
  force_deregister      = true
  force_delete_snapshot = true

  tag {
    key   = "Name"
    value = "Range Image"
  }
}

build {

  name = "blue-lamp"
  sources = [
    "source.amazon-ebs.rh"
  ]

  provisioner "shell" { # provisioner for installing wordpress

    inline = [

      "curl https://raw.githubusercontent.com/cofcsecurity/range-images/pm/images/scripts/database.sql > db.mysql",      # script to build database                                                                                # creating database before script
      "sudo mysql < db.mysql",                                                                                           # building database
      "sudo bash -c \"curl https://raw.githubusercontent.com/cofcsecurity/range-images/pm/images/scripts/wp.sh | bash\"" # script to automate the install

    ]

  }




}