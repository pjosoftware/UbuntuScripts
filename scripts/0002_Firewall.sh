#!/bin/bash
ufw --force enable

ufw default deny incoming
ufw default allow outgoing
