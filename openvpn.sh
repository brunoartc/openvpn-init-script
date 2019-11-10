#!/bin/bash
cd /home/ubuntu
wget -P /home/ubuntu/ https://github.com/OpenVPN/easy-rsa/releases/download/v3.0.4/EasyRSA-3.0.4.tgz
tar xvf EasyRSA-3.0.4.tgz
sudo apt-get -y update
sudo apt-get -y install openvpn easy-rsa
git clone https://github.com/brunoartc/openvpn-init-script
sudo cp openvpn-init-script/server.conf /etc/openvpn/server.conf
cp /etc/sysctl.conf sysctl.conf
echo "net.ipv4.ip_forward=1" >> sysctl.conf
sudo cp sysctl.conf /etc/sysctl.conf
sudo sysctl -p
sudo modprobe iptable_nat
sudo iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE
cp openvpn-init-script/vars EasyRSA-3.0.4/vars
cd /home/ubuntu/EasyRSA-3.0.4/
./easyrsa init-pki
./easyrsa build-ca nopass << EOF

EOF
./easyrsa gen-req server nopass << EOF

EOF
./easyrsa gen-dh
./easyrsa sign-req server server << EOF
yes
EOF
mkdir /home/ubuntu/files
cp pki/private/server.key /home/ubuntu/files/
cp pki/issued/server.crt /home/ubuntu/files/
cp pki/ca.crt /home/ubuntu/files/
openvpn --genkey --secret ta.key
cp ta.key /home/ubuntu/files
cp pki/dh.pem /home/ubuntu/files

mkdir -p /home/ubuntu/client-configs/keys
chmod -R 700 home/ubuntu/client-configs
#./easyrsa gen-req client1 nopass
#cp pki/private/client1.key home/ubuntu/client-configs/keys/


sudo cp /home/ubuntu/files/* /etc/openvpn/

sudo mkdir -p /etc/openvpn/ccd

echo "ifconfig-push 10.8.0.2 255.255.255.255" > /etc/openvpn/ccd/database


wget https://raw.githubusercontent.com/brunoartc/openvpn-init-script/master/clients.sh
machine_ip=$(curl ifconfig.me)
sh clients.sh database $machine_ip
sh clients.sh serverless $machine_ip





sudo systemctl restart openvpn@server


echo Terminou
sudo apt-get install apache2

