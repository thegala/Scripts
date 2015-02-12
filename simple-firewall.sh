#!/bin/bash
#Creating chains
iptables -N TCP
iptables -N UDP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT
iptables -P INPUT DROP

#Filing input chain
iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT   
iptables -A INPUT -m conntrack --ctstate INVALID -j DROP
iptables -A INPUT -p icmp --icmp-type 8 -m conntrack --ctstate NEW -j ACCEPT
iptables -A INPUT -p udp -m conntrack --ctstate NEW -j UDP
iptables -A INPUT -p tcp --syn -m conntrack --ctstate NEW -j TCP

#Block  SYS scan
iptables -I TCP -p tcp -m recent --update --seconds 60 --name TCP-PORTSCAN -j REJECT --reject-with tcp-rst
iptables -D INPUT -p tcp -j REJECT --reject-with tcp-rst
iptables -A INPUT -p tcp -m recent --set --name TCP-PORTSCAN -j REJECT --reject-with tcp-rst

#Block UDP scan
iptables -I UDP -p udp -m recent --update --seconds 60 --name UDP-PORTSCAN -j REJECT --reject-with port-unreachable
iptables -D INPUT -p udp -j REJECT --reject-with icmp-port-unreach
iptables -A INPUT -p udp -m recent --set --name UDP-PORTSCAN -j REJECT --reject-with icmp-port-unreach

#Block ping
iptables -A INPUT -p icmp --icmp-type echo-request -m recent --name ping_limiter --set
iptables -A INPUT -p icmp --icmp-type echo-request -m recent --name ping_limiter --update --hitcount 6 --seconds 4 -j DROP
iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT

#Reject tcp an udp if unreachable
iptables -A INPUT -p udp -j REJECT --reject-with icmp-port-unreachable
iptables -A INPUT -p tcp -j REJECT --reject-with tcp-rst

# Last rule
iptables -A INPUT -j REJECT --reject-with icmp-proto-unreachable

#Adding ports
iptables -A TCP -p tcp --dport 6596 -j ACCEPT
iptables -A TCP -p tcp --dport 80 -j ACCEPT
iptables -A TCP -p tcp --dport 22 -j ACCEPT
iptables -A TCP -p tcp --dport 443 -j ACCEPT
iptables -A UDP -p udp --dport 53 -j ACCEPT







