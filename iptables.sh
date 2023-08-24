#!/bin/bash
#

read -p "# Digite o IP: " int1
read -p "# Digite a Porta SSH: " int2

iptables -F
echo Permitindo IP $int1
iptables -A INPUT -s $int1 -j ACCEPT

echo Bloqueando qualquer requisição na porta $int2
iptables -A INPUT -p tcp --dport $int2 -j DROP
iptables -A INPUT -p udp --dport $int2 -j DROP

echo Bloquendo qualquer requisição na porta 5060
iptables -A INPUT -p tcp --dport 5060 -j DROP
iptables -A INPUT -p udp --dport 5060 -j DROP

echo Liberando ping prtg
iptables -A INPUT -p icmp -s 10.100.22.160/28 -j ACCEPT

echo Bloqueando ping
iptables -A INPUT -p icmp -j DROP

echo Liberando range de ips utilizados por clientes
wget -O - https://raw.githubusercontent.com/patryckpinhal/issabel-construtor/main/ips-liberados.sh | bash
