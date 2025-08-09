#!/bin/bash
apt purge --auto-remove telnetd ftp vsftpd samba nfs-kernel-server nfs-common apache2 cups avahi-daemon rpcbind xinetd whoopsie modemmanager nis yp-tools tftpd atftpd tftpd-hpa rsh-server rsh-redone-server
apt autoremove
apt clean
