source "amazon-ebs" "docker" {
  ami_name              = "blue-ubuntu-docker" # our AMI name
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

    name = "blue-docker"
    sources = [
      "source.amazon-ebs.docker"
    ]



    provisioner "shell" { # provisioner for installing docker

      inline = [

        "sudo apt remove -y docker docker-engine docker.io containerd runc",                                                                                                                                                                                 # remove any old docker commands
        "sudo apt update",                                                                                                                                                                                                                                   # update packages
        "sudo apt install -y ca-certificates curl gnupg lsb-release",                                                                                                                                                                                        # install packages for docker
        "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg",                                                                                                                    # get the docker repo public key
        "bash -c \"echo \"deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null", # set up repo files locally
        "sudo apt update",                                                                                                                                                                                                                                   # update repos with docker repo
        "sudo apt install -y docker-ce docker-ce-cli container.d",                                                                                                                                                                                           # install docker
        "sudo groupadd docker",                                                                                                                                                                                                                              # add group for docker
        "sudo usermod -aG docker $USER",                                                                                                                                                                                                                     # add user to docker
        "newgrp docker",                                                                                                                                                                                                                                     # apply group changes without logging out
        "sudo systemctl start docker",                                                                                                                                                                                                                       # start docker service
        "sudo systemctl enable docker"                                                                                                                                                                                                                       # enable docker at start 

      ]

    }

    provisioner "shell" { # spin up docker containers

      inline = [

        "docker pull portainer/portainer:latest",                                                                                                                                                      # portainer image for gui management of containers
        "docker volume create portainer_data",                                                                                                                                                         # volume to save config and container data
        "docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data cr.portainer.io/portainer/portainer-ce:2.9.3", # start container
        "docker pull linuxserver/code-server",                                                                                                                                                         # vscode in the browser
        "docker run -d --name=code-server -e PUID=1000 -e PGID=1000 -e TZ=America/Chicago -e PASSWORD=password -p 8443:8443 --restart unless-stopped lscr.io/linuxserver/code-server",                 # set up container
        "docker pull grafana/grafana",                                                                                                                                                                 # grafana image
        "docker run -d --name=grafana -p 3000:3000 grafana/grafana",                                                                                                                                   # set up grafana
        "docker pull bkimminich/juice-shop",                                                                                                                                                           # juice shop for vulns
        "docker run --rm -p 3333:3000 bkimminich/juice-shop &",                                                                                                                                        # set up juice shop
        "sleep 120"

      ]

    }

  }