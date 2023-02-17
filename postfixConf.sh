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

#  generate a opendkim key
sudo opendkim-genkey -s mail -d $domain

# move the key to the opendkim folder
sudo mv mail.private /etc/opendkim/keys/$domain/mail.private

# change the permissions of the key
sudo chmod 400 /etc/opendkim/keys/$domain/mail.private

# update the opendkim.conf file
sudo sed -i "s/KeyTable.*$/KeyTable refile:\/etc\/opendkim\/KeyTable/" /etc/opendkim.conf
sudo sed -i "s/SigningTable.*$/SigningTable refile:\/etc\/opendkim\/SigningTable/" /etc/opendkim.conf

# update the KeyTable file
echo "mail._domainkey.$domain $domain:mail:/etc/opendkim/keys/$domain/mail.private" | sudo tee /etc/opendkim/KeyTable

# update the SigningTable file
echo "*@$domain mail._domainkey.$domain" | sudo tee /etc/opendkim/SigningTable

dkim_record=$(sudo cat /etc/opendkim/keys/$domain/mail.txt)

echo $dkim_record

# update the /etc/mailname file
echo $domain | sudo tee /etc/mailname

# restart postfix
sudo systemctl restart postfix

# check the status of postfix
sudo systemctl status postfix

