#!/bin/bash

# Check if the domain argument is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <domain>"
  exit 1
fi

# Ensure that the provided domain is the bare domain.
# If the domain is not the bare domain, inform the user of the proper usage, then extract the bare domain from the input domain and use that as $1 instead.
if [[ $1 == *"."*"."* ]]; then
  echo "Usage: $0 <domain>"
  echo "Please provide the bare domain, not a subdomain. You fool!"
  domain=$(echo $1 | cut -d "." -f 2-)
  echo "Using $domain as the domain."
  sleep 5
  clear
  $0 $domain
  exit 0
fi


# a list of recursive DNS servers
# 8.8.8.8/2001:4860:4860::8888 (google-public-dns-a.google.com/dns.google)
# 8.8.4.4/2001:4860:4860::8844 (google-public-dns-b.google.com/dns.google)
# 77.88.8.8/2a02:6b8::feed:0ff (dns.yandex.ru)
# 77.88.8.1/2a02:6b8:0:1::feed:0ff (secondary.dns.yandex.ru)
# 1.1.1.1/2606:4700:4700::1111 (1dot1dot1dot1.cloudflare-dns.com)
# 1.0.0.1/2606:4700:4700::1001 (1dot1dot1dot1.cloudflare-dns.com)
# 9.9.9.9/2620:fe::fe (dns.quad9.net)
# 149.112.112.112/2620:fe::9
# 9.9.9.10/2620:fe::10 (dns-nosec.quad9.net)
# 149.112.112.10/2620:fe::fe:10
# 208.67.222.222/2620:119:35::35 (resolver1.opendns.com)
# 208.67.220.220/2620:119:53::53 (resolver2.opendns.com)
# 208.67.222.220 (resolver3.opendns.com)
# 208.67.220.222 (resolver4.opendns.com)
# 185.222.222.222/2a09:: (public-dns-a.dns.sb)
# 185.184.222.222/2a09::1 (public-dns-b.dns.sb)
# 2a0d:2406:1802::
# 193.110.81.0/2a0f:fc80::
# 185.253.5.0/2a0f:fc81::
# 216.146.35.35 (resolver1.dyndnsinternetguide.com)
# 216.146.36.36 (resolver2.dyndnsinternetguide.com)
# 64.6.64.6/2620:74:1b::1:1 (recpubns1.nstld.net)
# 64.6.65.6/2620:74:1c::2:2 (recpubns2.nstld.net)
dns_servers=(
"8.8.8.8"
"8.8.4.4"
"77.88.8.8"
"77.88.8.1"
"1.1.1.1"
"1.0.0.1"
"9.9.9.9"
"149.112.112.112"
"9.9.9.10"
"149.112.112.10"
"208.67.222.222"
"208.67.220.220"
"208.67.222.220"
"208.67.220.222"
"185.222.222.222"
"185.184.222.222"
"193.110.81.0"
"185.253.5.0"
"216.146.35.35"
"216.146.36.36"
"64.6.64.6"
"64.6.65.6"
)

# Function to display the A records of the domain
display_records() {
  tput cup 0 0
  echo -e "\e[32mWatching DNS records for $1:\e[0m"
  echo -e "\e[37mPress Ctrl+C to exit.\e[0m\n"
  printf "%-20s %-20s %-20s\n" "DNS Server" "A_@" "A_WWW"
  for server in "${dns_servers[@]}"
  do
    ip_address_at=$(dig +short $1 A @${server%%/*})
    ip_address_www=$(dig +short www.$1 A @${server%%/*})
    printf "\e[34m%-20s %-20s %-20s\e[0m\n" "$server" "$ip_address_at" "$ip_address_www"
  done
}

# Trap the interrupt signal to exit the script gracefully
trap 'echo -e "\nExiting..."; exit' INT

# Spinner characters
spinner=( '|' '/' '-' '\' )

# Loop to refresh the records every 60 seconds
while true; do
  clear
  display_records $1
  # Spinner for 60 seconds
  for i in {1..600}; do
    printf "\rNext refresh in \e[31m%02d \e[0mseconds \e[32m%s\e[0m " $(( ((6000-i) % 600) / 10 )) "${spinner[i%4]}"
    sleep 0.1
  done
done
