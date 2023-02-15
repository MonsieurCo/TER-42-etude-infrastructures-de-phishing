#!/bin/bash 

$domain=$1
$ip=$2
$dns=$3

echo "Creating DNS records for $domain"

# Create the A record
echo "Creating SPF record for $domain"

echo "\n"

echo  	"v=spf1 ip4:$ip include:$dns ~all"

echo "Creating DKIM record for $domain"

