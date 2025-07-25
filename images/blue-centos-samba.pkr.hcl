/*
This build server constructs the CentOS to run samba as a simple file share.
Is untested but assumed to work.
To test:
- Load Range environment and attempt to connect to the network drive. 
*/
source "amazon-ebs" "samba" {
    ami_name              = "blue-centOS-samba" # our AMI name
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

    name = "blue-centOS-samba"

    sources = ["source.amazon-ebs.samba" ]

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
    script = "./scripts/blue_samba_fileshare_REHL.sh"
    }

}