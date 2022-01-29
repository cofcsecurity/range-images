
source "amazon-ebs" "wordpress" {
  ami_name              = "blue-ubuntu-wordpress" # our AMI name
  instance_type         = "t2.micro"
  region                = "us-east-1"
  source_ami            = "ami-0bfabd02a612261de" # base ami
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

  name = "blue-wordpress"
  sources = [
    "source.amazon-ebs.wordpress"
  ]

  provisioner "shell" { # provisioner for installing wordpress

    inline = [

      "curl https://raw.githubusercontent.com/cofcsecurity/range-images/pm/images/scripts/database.sql > db.mysql",                                                       # script to build database                                                                                
      "sudo mysql < db.mysql",                                                                                                                                            # building database
      "sudo apt update",                                                                                                                                                  # update repos
      "sleep 180",                                                                                                                                                        # waiting for ubuntu to update itself
      "sudo apt install -y php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip",                                                                    # install php modules for wordpress
      "sudo systemctl restart apache2",                                                                                                                                   # restart apache2 to load in modules
      "sudo bash -c \"curl https://raw.githubusercontent.com/cofcsecurity/range-images/pm/images/configs/wordpress.conf > /etc/apache2/sites-available/wordpress.conf\"", # get the wordpress.conf
      "sudo a2enmod rewrite",                                                                                                                                             # virtual hosting
      "sudo apache2ctl configtest",                                                                                                                                       # test coinfig
      "sudo systemctl restart apache2",                                                                                                                                   # restart to apply changes
      "sudo bash -c \"mkdir /var/www/wordpress\"",                                                                                                                        # making wp directory
      "cd /var/www/wordpress",                                                                                                                                            # cd into proper wp dir
      "sudo bash -c \"curl https://raw.githubusercontent.com/cofcsecurity/range-images/pm/images/scripts/wp.sh | bash\""                                                  # script to automate the install

    ]

  }
}
