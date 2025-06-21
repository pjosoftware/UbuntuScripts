#!/bin/bash
apt update -y
apt full-upgrade -y
apt autoremove -y
apt clean -y

apt install unattended-upgrades -y
apt install ufw -y
apt install fail2ban -y
