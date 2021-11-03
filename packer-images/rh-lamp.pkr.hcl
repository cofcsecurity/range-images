
source "amazon-ebs" "rh" {
  ami_name      = "rh-7-lamp-stack" # our AMI name
  instance_type = "t2.micro"
  region        = "us-east-1"
  source_ami    = "ami-785bae10"
  ssh_username  = "ec2-user" # ssh user for configing the EC2
  ssh_pty       = "true"     # spawn a tty to execute commands
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
      "sudo yum install httpd -y",           # installing apache
      "sudo systemctl start httpd.service",  # starting the service
      "sudo systemctl enable httpd.service", # enable the service at system startup
      "sudo systemctl restart httpd.service"

    ]

  }

  provisioner "shell" {


    inline = [

      "echo Installing MySQL",
      "sudo yum install mariadb-server mariadb -y",        # installing mariadb (mysql) server and client for administration
      "sudo systemctl start mariadb.service",              # starting the service
      "sudo mysqladmin --user=root password \"password\"", # changing the db root password without mysql_secure_installation
      "sudo systemctl enable mariadb.service",             # enabling the service at start up

    ]

  }

  provisioner "shell" {

    inline = [

      "echo Installing PHP",
      "sudo yum install php php-mysql -y",    # installing PHP modules
      "sudo systemctl restart httpd.service", # restart Apache after installing PHP modules
      "sudo chown -R $USER:$USER /var/www",   # change the ownership for the /var/html dir
      "sudo chmod -R 755 /var/www/",          # change the permissions for the /var/html dir
      "sudo setfacl -R -m u:$USER:rwx /var/www",
      "sudo systemctl restart httpd.service",                         # restart the Apache service after chnaging permissions
      "sudo echo \"<? php phpinfo(); ?>\" >> /var/www/html/info.php", # sehll file for PHP testing
      "sudo systemctl restart httpd.service"                          # restart the service to apply PHP shell file to the webserver

    ]

  }

}
