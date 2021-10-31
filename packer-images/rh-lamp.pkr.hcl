
source "amazon-ebs" "rh" {
  ami_name      = "rh-7-lamp-stack"
  instance_type = "t2.micro"
  region        = "us-east-1"
  source_ami    = "ami-785bae10"
  ssh_username  = "ec2-user"
  ssh_pty       = "true"
  ssh_timeout   = "60m"
  subnet_id     = "subnet-1ad89f57"
}

build {

  name = "centos7-lamp"
  sources = [
    "source.amazon-ebs.rh"
  ]


  provisioner "shell" {

    inline = [

      "echo Installing Apache",
      "sudo yum install httpd -y",
      "sudo systemctl start httpd.service",
      "sudo systemctl enable httpd.service",
      "sudo systemctl restart httpd.service"

    ]

  }

  provisioner "shell" {


    inline = [

      "echo Installing MySQL",
      "sudo yum install mariadb-server mariadb -y",
      "sudo systemctl start mariadb.service",
      "sudo mysqladmin --user=root password \"password\"",
      "sudo systemctl enable mariadb.service",

    ]

  }

  provisioner "shell" {

    inline = [

      "echo Installing PHP",
      "sudo yum install php php-mysql -y",
      "sudo systemctl restart httpd.service",
      "sudo chown -R $USER:$USER /var/www",
      "sudo chmod -R 755 /var/www/",
      "sudo setfacl -R -m u:$USER:rwx /var/www",
      "sudo systemctl restart httpd.service",
      "sudo echo \"<? php phpinfo(); ?>\" >> /var/www/html/info.php",
      "sudo systemctl restart httpd.service"

    ]

  }

}
