#!/bin/bash

echo "Lime Fibre - 2022"
echo "Drop non-cloudflare proxy IP address(es) - IPv4 & IPv6"

echo "-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~"

echo "Running prerequisite checks"

if ! command -v iptables &> /dev/null
then
    echo "IPTables could not be found"
    exit
fi

if ! command -v ip6tables &> /dev/null
then
    echo "IP6Tables could not be found"
    exit
fi

echo "-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~"

for i in `curl -s https://www.cloudflare.com/ips-v4`; do
    iptables -I INPUT -p tcp -m multiport --dports 80 -s $i -j ACCEPT
    echo "Allowing "$i":80"
    iptables -I INPUT -p tcp -m multiport --dports 443 -s $i -j ACCEPT
    echo "Allowing "$i":443"
done

echo "Completed IPv4 Ranges"
echo
echo "-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~"

for i in `curl -s https://www.cloudflare.com/ips-v6`; do
    ip6tables -I INPUT -p tcp -m multiport --dports 80 -s $i -j ACCEPT
    echo "Allowing "$i":80"
    ip6tables -I INPUT -p tcp -m multiport --dports 443 -s $i -j ACCEPT
    echo "Allowing "$i":443"
done

echo "Completed IPv6 Ranges"
echo

if [ "$1" == "" ] || [ $# -gt 1 ]; then
        echo "-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~"
        echo
elif [ "$1" == "--block" ]; then
    iptables -A INPUT -p tcp -m multiport --dports http,https -j DROP
    echo "Blocked non-cloudflare access"
    ip6tables -A INPUT -p tcp -m multiport --dports http,https -j DROP
    echo "Blocked non-cloudflare v6 access"
    echo "-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~"
    echo
elif [ "$1" == "--help" ]; then
    echo "-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~"
    echo
    echo "--help - Displays this message"
    echo "--block - Blocks non-cloudflare proxy IP addresses & requests to port 80 & 443"
else
    echo "-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~"
    echo "Command not found, try using --help"
fi

echo "This terminal will clear in 10 seconds."
sleep 10s
clear
