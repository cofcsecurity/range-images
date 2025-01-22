#! /bin/bash



# Name: Default cloud.cfg Configuration File
# Notes: 
#   Editing the cloud config to not overwrite the Default configuration
#   Enables password authentication setting to be changed
# Valid Targets: Any Blue CentOS images

echo "Configuring cloud.cfg..."

CONFIG="
users:
   - default

disable_root: false
mount_default_fields: [~, ~, 'auto', 'defaults,nofail,x-systemd.requires=cloud-init.service,_netdev', '0', '2']
resize_rootfs_tmp: /dev
ssh_pwauth:   1

ssh_deletekeys:   true
ssh_genkeytypes:  ['rsa', 'ecdsa', 'ed25519']
syslog_fix_perms: ~
disable_vmware_customization: false

cloud_init_modules:
 - migrator
 - seed_random
 - bootcmd
 - write-files
 - growpart
 - resizefs
 - disk_setup
 - mounts
 - set_hostname
 - update_hostname
 - update_etc_hosts
 - ca-certs
 - rsyslog
 - users-groups
 - ssh

cloud_config_modules:
 - ssh-import-id
 - locale
 - set-passwords
 - rh_subscription
 - spacewalk
 - yum-add-repo
 - ntp
 - timezone
 - disable-ec2-metadata
 - runcmd

cloud_final_modules:
 - package-update-upgrade-install
 - write-files-deferred
 - puppet
 - chef
 - mcollective
 - salt-minion
 - reset_rmc
 - refresh_rmc_and_interface
 - rightscale_userdata
 - scripts-vendor
 - scripts-per-once
 - scripts-per-boot
 - scripts-per-instance
 - scripts-user
 - ssh-authkey-fingerprints
 - keys-to-console
 - install-hotplug
 - phone-home
 - final-message
 - power-state-change

system_info:
   
   distro: centos
   default_user:
     name: ec2-user
     lock_passwd: true
     gecos: Cloud User
     groups: [adm, systemd-journal]
     sudo: ['ALL=(ALL) NOPASSWD:ALL']
     shell: /bin/bash
   paths:
      cloud_dir: /var/lib/cloud/
      templates_dir: /etc/cloud/templates/
   ssh_svcname: sshd
"

   echo "$CONFIG" | sudo tee /etc/cloud/cloud.cfg > /dev/null

   echo "Done configuring cloud.cfg"