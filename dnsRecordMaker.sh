#!/bin/bash 



echo -n "Enter the domain name: "
read domain

echo -n "Enter the IP address: "
read ip

echo -n "Enter the DNS server: "
read dns


echo "Creating DNS records for $domain"

echo

# Create the A record
echo "Creating SPF record for $domain"

echo 

echo  	"v=spf1 ip4:$ip include:$dns ~all"

echo "Creating dmarc record for $domain"

echo 

echo  	"v=DMARC1; p=quarantine; rua=mailto:postmaster@$domain; ruf=mailto:postmaster@$domain; fo=1; adkim=r; aspf=r; pct=100; rf=afrf; ri=86400"

