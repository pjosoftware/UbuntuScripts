#!/bin/bash
read -p "Enter SSH port number desired (e.g., 1234): " port

sed -i "s/PermitRootLogin yes/PermitRootLogin no/" /etc/ssh/sshd_config
sed -i "s/#PermitEmptyPasswords no/PermitEmptyPasswords no/" /etc/ssh/sshd_config
sed -i "s/#PasswordAuthentication yes/PasswordAuthentication no/" /etc/ssh/sshd_config
sed -i "s/#PubkeyAuthentication yes/PubkeyAuthentication yes/" /etc/ssh/sshd_config
sed -i "s/#AuthorizedKeysFile/AuthorizedKeysFile/" /etc/ssh/sshd_config
sed -i "s/Include \/etc\/ssh\/sshd_config.d\/\*.conf/#Include \/etc\/ssh\/sshd_config.d\/\*.conf/" /etc/ssh/sshd_config
sed -i "s/#Port 22/Port $port/" /etc/ssh/sshd_config

cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
sed -i "s/port    = ssh/enabled = true\nmode = aggressive\nport    = $port/" /etc/fail2ban/jail.local

ufw allow ${port}/tcp
echo "Firewall rules updated. Port ${port}/tcp is now allowed."

systemctl daemon-reexec
systemctl restart ssh
systemctl enable fail2ban --now
