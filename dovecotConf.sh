#!/bin/bash 
# This script will configure dovecot to send mail from the server

# check if dovecot is installed
if [ -f /etc/dovecot/dovecot.conf ]; then
    echo "Dovecot is installed"
else
    echo "Dovecot is not installed"
    exit 1
fi

# check if a domain name argument is provided
if [ $# -eq 0 ]; then
    echo "No domain name provided"
    exit 1
fi

# Set the domaine name as a variable
domain = $1
