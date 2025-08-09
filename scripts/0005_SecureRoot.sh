#!/bin/bash
passwd -l root

echo "Root account locked (Should show 'L')"
passwd -S root
echo "============================="

echo "List of users with passwords:"
cat /etc/shadow | grep '^[^:]*:[^\*!]'
echo "============================="

echo "List of users with login shells:"
awk -F: '/\/bin\/bash/ {print $1}' /etc/passwd
echo "============================="

echo "List of users without passwords:"
cat /etc/shadow | awk -F: '($2==""){print $1}'
echo "============================="

echo "List of sudoers other than root:"
grep -Po '^sudo.+:\K.*$' /etc/group
echo "============================="

echo "Ensure root user has UID of 0, any other number is bad:"
awk -F: '($3=="0"){print}' /etc/passwd
echo "============================="

read -n 1 -s -r -p "Press any key to continue..."