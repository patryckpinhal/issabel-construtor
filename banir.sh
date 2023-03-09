#!/bin/bash
# 
iptables -F
echo Permitindo IP trocarip 
iptables -A INPUT -s trocarip -j ACCEPT


echo Bloqueando qualquer requisição na porta trocarporta
iptables -A INPUT -p tcp --dport trocarporta -j DROP
iptables -A INPUT -p udp --dport trocarporta -j DROP


echo Bloqueando lista de IPs perigosos

wget -O - https://raw.githubusercontent.com/patryckpinhal/issabel-construtor/main/ips-banidos.sh | bash