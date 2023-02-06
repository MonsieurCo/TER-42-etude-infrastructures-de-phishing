#!/bin/bash 
# This script will configure postfix to send mail from the server

#debconf-set-selections <<< "postfix postfix/mailname string your.hostname.com"
#debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"
#apt-get install --assume-yes postfix

# check if a domain name argument is provided 
if [ $# -eq 0 ]; then
    echo "No domain name provided"
    exit 1
fi

# Set the domaine name as a variable 

domain=$1 

# check if postfix is installed
if [ -f /etc/postfix/main.cf ]; then
    echo "Postfix is installed"
else
    echo "Postfix is not installed"
    echo "Installing postfix"

    #debconf-set-selections <<< "postfix postfix/mailname string" $domain
    debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"
    apt-get install --assume-yes postfix

fi



# update the main.cf file
sudo postconf -e "myhostname = $domain"
sudo postconf -e "mydestination = $domain, localhost.$domain, localhost"
sudo postconf -e "myorigin = /etc/mailname"

# update the /etc/mailname file
echo $domain | sudo tee /etc/mailname

# restart postfix
sudo systemctl restart postfix

# check the status of postfix
sudo systemctl status postfix

