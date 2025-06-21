#!/bin/bash
read -p "Enter username: " username
adduser "$username"
usermod -aG sudo "$username"

echo "Please run "ssh-keygen -t rsa-sha2-512" on host .ssh folder for input below."
read -s -p "Paste the SSH public key for $username (hidden): " sshkey
echo

user_home="/home/$username"
mkdir -p "$user_home/.ssh"
echo "$sshkey" > "$user_home/.ssh/authorized_keys"
chmod 700 "$user_home/.ssh"
chmod 600 "$user_home/.ssh/authorized_keys"
chown -R "$username:$username" "$user_home/.ssh"

unset sshkey