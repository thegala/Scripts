#!/bin/bash

#this is my script for firewall
#Drop all forward input ,and output
#Allowing ssh,myssh,http,https,dns,imap,impas,pop3/s,postmail
# + LOGGING
#DDOS attack + port scanning + 
#Delete all existing rules
iptables -F
iptables -X

#Default drop everywhere
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT DROP

#Creating new chains
#iptables -N TCP
#iptables -N UDP
iptables -N LOGGING

#Loopback
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

#INvalid
iptables -A INPUT -m state --state INVALID -j DROP
iptables -A FORWARD -m state --state INVALID -j DROP
iptables -A OUTPUT -m state --state INVALID -j DROP

# These adresses are mostly used for LAN's, so if these would come to a WAN-only server, drop them.
iptables -A INPUT -s 10.0.0.0/8 -j DROP
iptables -A INPUT -s 169.254.0.0/16 -j DROP
iptables -A INPUT -s 172.16.0.0/12 -j DROP
iptables -A INPUT -s 127.0.0.0/8 -j DROP

#Multicast-adresses.
iptables -A INPUT -s 224.0.0.0/4 -j DROP
iptables -A INPUT -d 224.0.0.0/4 -j DROP
iptables -A INPUT -s 240.0.0.0/5 -j DROP
iptables -A INPUT -d 240.0.0.0/5 -j DROP
iptables -A INPUT -s 0.0.0.0/8 -j DROP
iptables -A INPUT -d 0.0.0.0/8 -j DROP
iptables -A INPUT -d 239.255.255.0/24 -j DROP
iptables -A INPUT -d 255.255.255.255 -j DROP


# Stop smurf attacks
iptables -A INPUT -p icmp -m icmp --icmp-type address-mask-request -j DROP
iptables -A INPUT -p icmp -m icmp --icmp-type timestamp-request -j DROP
iptables -A INPUT -p icmp -m icmp -j DROP

# Drop excessive RST packets to avoid smurf attacks
iptables -A INPUT -p tcp -m tcp --tcp-flags RST RST -m limit --limit 2/second --limit-burst 2 -j ACCEPT

#Send udp and tcp to TCP and UDP chain
#iptables -A INPUT -p udp -m conntrack --ctstate NEW -j UDP
#iptables -A INPUT -p tcp --syn -m conntrack --ctstate NEW -j TCP

#My SSH 
iptables -A INPUT  -p tcp -d 192.168.5.0/24 --dport 6596 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT  -p tcp --sport 6596 -m state --state ESTABLISHED -j ACCEPT
iptables -A OUTPUT  -p tcp -d 192.168.5.0/24 --dport 6596 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT  -p tcp --sport 6596 -m state --state ESTABLISHED -j ACCEPT

#default SSH
iptables -A INPUT  -p tcp  --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT  -p tcp --sport 22 -m state --state ESTABLISHED -j ACCEPT
iptables -A OUTPUT  -p tcp --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT  -p tcp --sport 22 -m state --state ESTABLISHED -j ACCEPT

#Port tricking
iptables -I INPUT -p tcp -m recent --update --seconds 60 --name TCP-PORTSCAN -j REJECT --reject-with tcp-rst
iptables -I INPUT -p udp -m recent --update --seconds 60 --name UDP-PORTSCAN -j REJECT --reject-with port-unreach

#Deny INVALID
iptables -A INPUT -m conntrack --ctstate INVALID -j DROP

#Accept ping output
iptables -A OUTPUT -p icmp --icmp-type echo-reply -j ACCEPT

#Inside comp ping
iptables -A OUTPUT -p icmp --icmp-type echo-request -j ACCEPT
iptables -A INPUT -p icmp --icmp-type echo-reply -j ACCEPT

#deny DDOS
iptables -A INPUT -p icmp --icmp-type echo-request -m limit --limit 30/min --limit-burst 8 -j ACCEPT
iptables -A INPUT -p icmp --icmp-type echo-request -j DROP

#Http,hhtps
iptables -A INPUT  -p tcp -m multiport --dports 80,443 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT  -p tcp -m multiport --sports 80,443 -m state --state ESTABLISHED -j ACCEPT
iptables -A INPUT  -p tcp -m multiport --sports 80,443 -m state --state ESTABLISHED -j ACCEPT
iptables -A OUTPUT  -p tcp -m multiport --dports 80,443 -m state --state NEW,ESTABLISHED -j ACCEPT

#DNS
iptables -A OUTPUT -p udp  --dport 53 -j ACCEPT
iptables -A INPUT -p udp  --sport 53 -j ACCEPT

#NTP curretn this is problem but in nfs
iptables -A INPUT -p tcp --dport 111 -j ACCEPT
iptables -A INPUT -p udp --dport 111 -j ACCEPT
iptables -A INPUT -p tcp --dport 2045 -j ACCEPT
iptables -A INPUT -p udp --dport 2045 -j ACCEPT
iptables -A INPUT -p tcp --dport  2046 -j ACCEPT
iptables -A INPUT -p udp --dport 2046 -j ACCEPT
iptables -A INPUT -p tcp --dport  2047 -j ACCEPT
iptables -A INPUT -p udp --dport 2047 -j ACCEPT
iptables -A INPUT -p tcp --dport  2048 -j ACCEPT
iptables -A INPUT -p udp --dport 2048 -j ACCEPT
iptables -A INPUT -p tcp --dport 2049 -j ACCEPT
iptables -A INPUT -p tcp --dport 2049 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 111 -j ACCEPT
iptables -A OUTPUT -p udp --sport 111 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 2045 -j ACCEPT
iptables -A OUTPUT -p udp --sport 2045 -j ACCEPT
iptables -A OUTPUT -p tcp --sport  2046 -j ACCEPT
iptables -A OUTPUT -p udp --sport 2046 -j ACCEPT
iptables -A OUTPUT -p tcp --sport  2047 -j ACCEPT
iptables -A OUTPUT -p udp --sport 2047 -j ACCEPT
iptables -A OUTPUT -p tcp --sport  2048 -j ACCEPT
iptables -A OUTPUT -p udp --sport 2048 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 2049 -j ACCEPT
iptables -A OUTPUT -p udp --sport 2049 -j ACCEPT
iptables -A INPUT -p tcp --sport 111 -j ACCEPT
iptables -A INPUT -p udp --sport 111 -j ACCEPT
iptables -A INPUT -p tcp --sport 2045 -j ACCEPT
iptables -A INPUT -p udp --sport 2045 -j ACCEPT
iptables -A INPUT -p tcp --sport  2046 -j ACCEPT
iptables -A INPUT -p udp --sport 2046 -j ACCEPT
iptables -A INPUT -p tcp --sport  2047 -j ACCEPT
iptables -A INPUT -p udp --sport 2047 -j ACCEPT
iptables -A INPUT -p tcp --sport  2048 -j ACCEPT
iptables -A INPUT -p udp --sport 2048 -j ACCEPT
iptables -A INPUT -p tcp --sport 2049 -j ACCEPT
iptables -A INPUT -p tcp --sport 2049 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 111 -j ACCEPT
iptables -A OUTPUT -p udp --dport 111 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 2045 -j ACCEPT
iptables -A OUTPUT -p udp --dport 2045 -j ACCEPT
iptables -A OUTPUT -p tcp --dport  2046 -j ACCEPT
iptables -A OUTPUT -p udp --dport 2046 -j ACCEPT
iptables -A OUTPUT -p tcp --dport  2047 -j ACCEPT
iptables -A OUTPUT -p udp --dport 2047 -j ACCEPT
iptables -A OUTPUT -p tcp --dport  2048 -j ACCEPT
iptables -A OUTPUT -p udp --dport 2048 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 2049 -j ACCEPT
iptables -A OUTPUT -p udp --dport 2049 -j ACCEPT


#HTTP for 1W
#iptables -A OUTPUT -p udp --dport 2121 -j ACCEPT
#iptables -A INPUT -p udp --sport 2121 -j ACCEPT
#iptables -A OUTPUT -p udp --sport 2121 -j ACCEPT
#iptables -A INPUT -p udp --dport 2121 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 2121 -j ACCEPT
iptables -A INPUT -p tcp --sport 2121 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 2121 -j ACCEPT
iptables -A INPUT -p tcp --dport 2121 -j ACCEPT

######
#Mail
#Mail
#######################################################################################

#Postmail
iptables -A INPUT -p tcp --dport 25 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp --sport 25 -m state --state ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp --sport 25 -m state --state ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp --dport 25 -m state --state NEW,ESTABLISHED -j ACCEPT

#SMTP
iptables -A INPUT -p tcp --dport 587 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp --sport 587 -m state --state ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp --sport 587 -m state --state ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp --dport 587 -m state --state NEW,ESTABLISHED -j ACCEPT

#SMTPS
iptables -A INPUT -p tcp --dport 465 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp --sport 465 -m state --state ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp --sport 465 -m state --state ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp --dport 465 -m state --state NEW,ESTABLISHED -j ACCEPT


#IMAP/IMAP2
iptables -A INPUT  -p tcp --dport 143 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT  -p tcp --sport 143 -m state --state ESTABLISHED -j ACCEPT
iptables -A INPUT  -p tcp --sport 143 -m state --state ESTABLISHED -j ACCEPT
iptables -A OUTPUT  -p tcp --dport 143 -m state --state NEW,ESTABLISHED -j ACCEPT

#IMAPS
iptables -A INPUT  -p tcp --dport 993 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT  -p tcp --sport 993 -m state --state ESTABLISHED -j ACCEPT
iptables -A INPUT  -p tcp --sport 993 -m state --state ESTABLISHED -j ACCEPT
iptables -A OUTPUT  -p tcp --dport 993 -m state --state NEW,ESTABLISHED -j ACCEPT

#POP3
iptables -A INPUT  -p tcp --dport 110 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT  -p tcp --sport 110 -m state --state ESTABLISHED -j ACCEPT
iptables -A INPUT  -p tcp --sport 110 -m state --state ESTABLISHED -j ACCEPT
iptables -A OUTPUT  -p tcp --dport 110 -m state --state NEW,ESTABLISHED -j ACCEPT

#POPS
iptables -A INPUT  -p tcp --dport 995 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT  -p tcp --sport 995 -m state --state ESTABLISHED -j ACCEPT
iptables -A INPUT  -p tcp --sport 995 -m state --state ESTABLISHED -j ACCEPT
iptables -A OUTPUT  -p tcp --dport 995 -m state --state NEW,ESTABLISHED -j ACCEPT

#######################################################################################

#Evrything other to tcp and udp chain
#iptables -A INPUT -p udp -m conntrack --ctstate NEW -j UDP
#iptables -A INPUT -p tcp --syn -m conntrack --ctstate NEW -j TCP

#Reject on the end
iptables -A INPUT -p udp -m recent --set --name UDP-PORTSCAN -j REJECT --reject-with icmp-port-unreach
iptables -A INPUT -p tcp -m recent --set --name TCP-PORTSCAN -j REJECT --reject-with tcp-rst

#TCP UDP#
#Tricking scanners
#iptables -I TCP -p tcp -m recent --update --seconds 60 --name TCP-PORTSCAN -j REJECT --reject-with tcp-rst
#iptables -I UDP -p udp -m recent --update --seconds 60 --name UDP-PORTSCAN -j REJECT --reject-with port-unreach

#Ports again
#iptables -A TCP -p tcp --dport 80 -j ACCEPT
#iptables -A TCP -p tcp --dport 443 -j ACCEPT
#iptables -A TCP -p tcp --dport 6596 -j ACCEPT
#iptables -A TCP -p tcp --dport 22 -j ACCEPT
#iptables -A UDP -p udp --dport 53 -j ACCEPT

#Logging chain
iptables -A INPUT -j LOGGING
iptables -A LOGGING -m limit --limit 2/min -j LOG --log-prefix "IPTables Packet Dropped: " --log-level 7
iptables -A LOGGING -j DROP

#On the end reject all
iptables -A INPUT -j REJECT --reject-with icmp-proto-unreachable
