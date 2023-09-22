#!/bin/bash
#

while true; do

read -p "# Digite o IP utilizado para acesso: " int1
read -p "# Digite a Porta SSH utilizada: " int2
read -p "# Digite o IP do servidor SNMP 01: " int3
read -p "# Digite o IP do servidor SNMP 02: " int5
read -p "# Digite o IP do servidor Antivirus: " int4

clear

echo " - IP utilizado para acesso...= $int1 "
echo " - Porta SSH utilizada........= $int2 "
echo " - IP servidor SNMP 01........= $int3 "
echo " - IP servidor SNMP 02........= $int5 "
echo " - IP servidor Antivirus......= $int4 "

read -p "Caso as informações estejam corretas, digite 'sim', caso deseja corrigir, digite 'nao': " int66

	if [[ $int66 == "nao" ]]; then
		echo "Reiniciando o script!"

	elif [[ $int66 == "sim" ]]; then
		echo "Continuando o script!"
		break
	else
		echo "Resposta inválida. Por favor, digite 'sim' ou 'nao'."
	fi
done

iptables -F
echo Permitindo o IP de acesso: $int1
iptables -A INPUT -s $int1 -j ACCEPT

echo Liberando ping prtg
iptables -A INPUT -p icmp -s $int3 -j ACCEPT
iptables -A INPUT -p icmp -s $int5 -j ACCEPT

iptables -A INPUT -s $int4 -p tcp --dport 16761 -j ACCEPT
iptables -A INPUT -s $int4 -p udp --dport 16761 -j ACCEPT
iptables -A INPUT -p icmp -s $int4 -j ACCEPT

echo Bloqueando qualquer requisição na porta $int2
iptables -A INPUT -p tcp --dport $int2 -j DROP
iptables -A INPUT -p udp --dport $int2 -j DROP

echo Bloquendo qualquer requisição na porta 5060
iptables -A INPUT -p tcp --dport 5060 -j DROP
iptables -A INPUT -p udp --dport 5060 -j DROP

echo Bloqueando ping
iptables -A INPUT -p icmp --icmp-type echo-request -j DROP

echo Liberando range de ips utilizados por clientes
wget -O - https://raw.githubusercontent.com/patryckpinhal/issabel-construtor/main/ips-liberados.sh | bash
