#!/bin/bash
echo 'tmpfs /run/shm tmpfs defaults,noexec,nosuid 0 0' | tee -a /etc/fstab
mount -o remount /run/shm
systemctl daemon-reload
