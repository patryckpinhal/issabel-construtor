#!/bin/bash
#

while true; do

read -p "# Digite o IP utilizado para acesso Life: " int1
#read -p "# Digite o IP utilizado para acesso TP: " int4
read -p "# Digite a Porta SSH utilizada: " int2
read -p "# Digite o IP do servidor SNMP: " int3
#read -p "# Digite o IP do servidor Ansible: " int5
read -p "# Digite o IP do servidor SIEM: " int6

clear
echo " "
echo " - IP utilizado para acesso Life...= $int1 "
#echo " - IP utilizado para acesso TP.....= $int4 "
echo " - Porta SSH utilizada.............= $int2 "
echo " - IP servidor SNMP................= $int3 "
#echo " - IP servidor Ansible.............= $int5 "
echo " - IP servidor SIEM................= $int6 "

echo " "
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

#Acessos VPN
echo Permitindo o IP de acesso: $int1
iptables -A INPUT -s $int1 -j ACCEPT
#iptables -A INPUT -s $int4 -j ACCEPT

#Acesso Ansible
#echo Permitindo IP do servidor Ansible: $int5
#iptables -A INPUT -s $int5 -p tcp --dport $int2 -j ACCEPT

#Ping PRTG
echo Liberando ping prtg $int3
iptables -A INPUT -p icmp -s $int3 -j ACCEPT

#Acessos e ping Antivirus
#iptables -A INPUT -s $int4 -p tcp --dport 16761 -j ACCEPT
#iptables -A INPUT -s $int4 -p udp --dport 16761 -j ACCEPT
#iptables -A INPUT -p icmp -s $int4 -j ACCEPT

#Acesso SIEM
echo Liberando IP $int6 do SIEM para acesso as portas 1515/tcp, 1514/tcp e 55000/tcp
iptables -A INPUT -s $int6 -p tcp --dport 1515 -j ACCEPT
iptables -A INPUT -s $int6 -p tcp --dport 1514 -j ACCEPT
iptables -A INPUT -s $int6 -p tcp --dport 55000 -j ACCEPT

#Liberação localhost
iptables -A INPUT -s 127.0.0.1 -j ACCEPT

#Bloqueio portas
iptables -A INPUT -p tcp --dport $int2 -j DROP      #porta ssh tcp
iptables -A INPUT -p udp --dport $int2 -j DROP      #porta ssh udp
iptables -A INPUT -p tcp --dport 5060 -j DROP       #porta sip tcp
iptables -A INPUT -p udp --dport 5060 -j DROP       #porta sip udp
iptables -A INPUT -p tcp --dport 3306 -j DROP       #porta mysql tcp
iptables -A INPUT -p udp --dport 3306 -j DROP       #porta mysql udp
iptables -A INPUT -p tcp --dport 20005 -j DROP      #porta open webnet tcp
iptables -A INPUT -p udp --dport 20005 -j DROP      #porta open webnet udp
iptables -A INPUT -p tcp --dport 8088 -j DROP       #porta web socket tcp
iptables -A INPUT -p udp --dport 8088 -j DROP       #porta web socket udp

#Bloqueio ping
echo Bloqueando ping
iptables -A INPUT -p icmp --icmp-type echo-request -j DROP

#Liberando porta 5060
echo Liberando range de ips utilizados por clientes
wget -O - https://raw.githubusercontent.com/patryckpinhal/issabel-construtor/main/ips-liberados.sh | bash


#Validar se existe o arquivo de ips particulares, caso não, criar

validar="/home/script/ips-clientes.sh"

if [ -e "$validar" ]; then
    echo "O arquivo $validar já existe."
        cd /home/script/
        ./ips-clientes.sh
else
    echo "#!/bin/bash" > "$validar"
    echo "#" >> "$validar"
    echo "#iptables -I INPUT -s X.X.X.X -p tcp --dport XXXX -j ACCEPT" >> "$validar"
    chmod +x "$validar"
    echo "O arquivo $validar foi criado com sucesso."
fi
