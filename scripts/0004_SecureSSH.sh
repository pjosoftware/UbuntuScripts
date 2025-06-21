#!/bin/bash
sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/#PermitEmptyPasswords no/PermitEmptyPasswords no/' /etc/ssh/sshd_config
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/#Port 22/Port 54321/' /etc/ssh/sshd_config

cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
sed -i 's/port    = ssh/enabled = true\nport    = 54321/' /etc/fail2ban/jail.local

systemctl daemon-reexec
systemctl restart ssh
systemctl enable fail2ban --now