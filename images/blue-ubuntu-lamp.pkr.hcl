packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu-bionic" {
  ami_name              = "blue-ubuntu-lamp"
  instance_type         = "t2.micro"
  region                = "us-east-1"
  force_deregister      = true
  force_delete_snapshot = true

  source_ami_filter { # search for AMI
    filters = {
      name                = "ubuntu/images/*ubuntu-bionic-18.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu" # non-root user to ssh into

  tag {
    key   = "Name"
    value = "Range Image"
  }
}

build { # build the machine for the image

  name = "blue-lamp" # name of temp ec2 for running commands
  sources = [
    "source.amazon-ebs.ubuntu-bionic"
  ]


  provisioner "shell" { # provisioner for Apache install

    inline = [

      "echo Installing Apache",
      "sudo apt update", # update repos
      "sleep 30",
      "sudo apt install apache2 apache2-bin apache2-utils -y", # install apache2
      "sleep 30",
      "sudo apache2ctl configtest",                                                  # testing the config
      "sudo bash -c \"echo \"ServerName 127.0.0.1\" >> /etc/apache2/apache2.conf\"", # add the localhost to the conf file NOTE: you need to use bash -c to echo text into a conf file
      "sudo apache2ctl configtest",                                                  # test the new config
      "sudo systemctl restart apache2"                                               # restart the apache service

    ]

  }

  provisioner "shell" { # provisioner for installing mysql


    inline = [

      "echo Installing MySQL",
      "sudo apt install mysql-server mysql-client -y",     # installing mysql server and mysql-client (for server administration)
      "sudo mysqladmin --user=root password \"password\"", # set the db root password without doing mysql_secure_installation
      "sleep 30"

    ]

  }

  provisioner "shell" { # provisioner for installing PHP

    inline = [

      "echo Installing PHP",
      "sudo apt install php libapache2-mod-php php-mysql -y", # installing PHP libraries
      "sleep 30",
      "sudo systemctl restart apache2",     # retarts Apache after PHP modules
      "sudo chown -R $USER:$USER /var/www", # change the user and group ownership for the /var/www/html dir
      "sudo chmod -R 755 /var/www/",        # change permissions of /var/www dir
      "sudo setfacl -R -m u:$USER:rwx /var/www",
      "sudo systemctl restart apache2", # restart apache2

    ]

  }

  provisioner "shell" { # provisioner for installing AV test file

    inline = [

      "sudo apt install wget -y",                                                  # installing wget
      "sudo bash -c \"wget -O /home/.malware https://secure.eicar.org/eicar.com\"" # AV test file

    ]

  }

}

