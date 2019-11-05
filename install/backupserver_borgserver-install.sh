#!/bin/bash
# https://blog.karolak.fr/2017/05/05/monter-un-serveur-de-sauvegardes-avec-borgbackup/

set -xeu

# Variables and functions with confidential information
# You have to fill it with real data
source ./secrets.conf.sh

backups_path="/home/${BACKUPSERVER_USER}/${BACKUPSERVER_FOLDER}"
ssh_authorized_cmd="command=\"cd ${backups_path}; borg serve --restrict-to-path ${backups_path}\",no-port-forwarding,no-x11-forwarding,no-agent-forwarding,no-pty,no-user-rc"

# Borg server with a user
user="${BACKUPSERVER_USER}"
yum -y install epel-release
yum -y install borgbackup
useradd -rUm "${user}"

# Backups storage folder
file="${backups_path}"
install -b -m 0700 -o "${BACKUPSERVER_USER}" -g "${BACKUPSERVER_USER}" -d "${file}"

# SSH access for the mailserver
file="/home/${BACKUPSERVER_USER}/.ssh/authorized_keys"

install -b -m 0700 -o "${BACKUPSERVER_USER}" -g "${BACKUPSERVER_USER}" -d "/home/${BACKUPSERVER_USER}/.ssh"
printf '%s\n' "${ssh_authorized_cmd} ${BACKUPSERVER_SSH_AUTHORIZEDKEY}" > "${file}"
chown "${BACKUPSERVER_USER}:" "${file}"
chmod 0600 "${file}"

exit 0
