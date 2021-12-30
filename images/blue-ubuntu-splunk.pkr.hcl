

source "amazon-ebs" "splunk" {

  ami_name              = "blue-ubuntu-splunk"
  instance_type         = "t2.micro"
  region                = "us-east-1"
  source_ami            = "ami-0279c3b3186e54acd" # ubuntu 18.04 base AMI
  ssh_username          = "ubuntu"                # non-root user to ssh into the machine with
  ssh_pty               = "true"                  # spawn a pseudo terminal for executing commands
  ssh_timeout           = "60m"
  force_deregister      = true
  force_delete_snapshot = true

}

build { # build the machine for the image

  name = "blue-splunk" # name of temp ec2 for running commands
  sources = [
    "source.amazon-ebs.splunk"
  ]

  provisioner "shell" { # provisioner for Splunk install

    inline = [

      "sudo apt update",                                                                                                          # update packages
      "wget https://download.splunk.com/products/splunk/releases/8.2.3/linux/splunk-8.2.3-cd0848707637-linux-2.6-amd64.deb",      # getting the deb installer file from splunk for the install
      "sudo dpkg -i splunk-8.2.3-cd0848707637-linux-2.6-amd64.deb",                                                               # installing splunk with dpkg
      "cd /opt/splunk/bin",                                                                                                       # changing into the directory to start up splunk
      "sudo ./splunk start --accept-license --no-prompt",                                                                         # start the splunk install service, accept the license, and then install with no interactive prompts
      "sleep 30",                                                                                                                 # sleep to allow the service to start up
      "sudo ./splunk cmd splunkd rest --noauth POST /services/authentication/users \"name=admin&password=password&roles=admin\"", # this is creating the admin user for the web portal and service
      "sleep 120",                                                                                                                # wait 2 mins to wait for changes to apply
      "sudo ./splunk restart",                                                                                                    # restart splunk service
      "sudo ./splunk enable boot-start"                                                                                           # start service on startup

    ]

  }

}