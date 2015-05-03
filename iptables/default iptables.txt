#!/bin/bash

clear

# Remove all rules
iptables -F

# Block null packages
iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP

# Block syn-flood attack
iptables -A INPUT -p tcp ! --syn -m state --state NEW -j DROP

# Block XMAS packets
iptables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP

# Allow SSH 
iptables -A INPUT -p tcp -m tcp --dport 22 -j ACCEPT

# Allow all output and drop everything else coming inn
iptables -P OUTPUT ACCEPT
iptables -P INPUT DROP

# Save iptables
iptables-save | sudo tee /etc/sysconfig/iptables


# Reload
service iptables restart