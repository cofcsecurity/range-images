packer {
    required_plugins {
    amazon = {
        version = ">= 0.0.2"
        source  = "github.com/hashicorp/amazon"
    }
    }
}

source "amazon-ebs" "COS" {
    ami_name              = "blue-centOS-mysql" # our AMI name
    instance_type         = "t2.micro"
    region                = "us-east-1"
    source_ami            = "ami-0df2a11dd1fe1f8e3"
    ssh_username          = "ec2-user" # ssh user for configing the EC2
    ssh_pty               = "true"     # spawn a pseudo terminal to execute commands
    ssh_timeout           = "60m"
    force_deregister      = true
    force_delete_snapshot = true

    tag {
    key   = "Name"
    value = "Range Image"
    }
}

build {

    name = "blue-mysql-employees"

    sources = [
    "source.amazon-ebs.COS"
    ]

    provisioner "shell" {
        script = "./scripts/blue_default_cloud_config.sh"
    }

    provisioner "shell" {
        script = "./scripts/blue_users_REHL.sh"
    }

    provisioner "shell" {
        script = "./scripts/blue_default_ssh.sh"
    }

    provisioner "shell" {
        script = "./scripts/blue_mysql_REHL.sh"
    }

}