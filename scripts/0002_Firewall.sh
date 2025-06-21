#!/bin/bash
ufw enable

ufw default deny incoming
ufw default allow outgoing

ufw allow 54321/tcp