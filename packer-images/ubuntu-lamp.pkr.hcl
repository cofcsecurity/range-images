
source "amazon-ebs" "ubuntu" {
  ami_name      = "ubuntu-18.04-lamp-stack1"
  instance_type = "t2.micro"
  region        = "us-east-1"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-bionic-18.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
}

build {

  name = "ubuntu-18.04-lampa"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]


  provisioner "shell" {

    inline = [

      "echo Installing Apache",
      "sudo apt update",
      "sleep 30",
      "sudo apt install apache2 -y",
      "sleep 30",
      "sudo apache2ctl configtest",
      "sudo bash -c \"echo \"ServerName 127.0.0.1\" >> /etc/apache2/apache2.conf\"",
      "sudo apache2ctl configtest",
      "sudo systemctl restart apache2"

    ]

  }

  provisioner "shell" {


    inline = [

      "echo Installing MySQL",
      "sudo apt install mysql-server mysql-client -y",
      "sudo mysqladmin --user=root password \"password\"",
      "sleep 30"

    ]

  }

  provisioner "shell" {

    inline = [

      "echo Installing PHP",
      "sudo apt install php libapache2-mod-php php-mysql -y",
      "sleep 30",
      "sudo systemctl restart apache2",
      "sudo chown -R $USER:$USER /var/www",
      "sudo chmod -R 755 /var/www/",
      "sudo setfacl -R -m u:$USER:rwx /var/www",
      "sudo systemctl restart apache2",
      "sudo echo \"<? php phpinfo(); ?>\" >> /var/www/html/info.php",
      "sudo systemctl restart apache2"

    ]

  }

}
