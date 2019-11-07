#!/bin/bash
cd /home/ubuntu
wget -P /home/ubuntu/ https://github.com/OpenVPN/easy-rsa/releases/download/v3.0.4/EasyRSA-3.0.4.tgz
tar xvf EasyRSA-3.0.4.tgz
sudo apt-get update
sudo apt-get install openvpn easy-rsa
#git clone https://github.com/brunoartc/cloud_database
sudo cp cloud_database/server.conf /etc/openvpn/server.conf
cp /etc/sysctl.conf sysctl.conf
echo "net.ipv4.ip_forward=1" >> sysctl.conf
sudo cp sysctl.conf /etc/sysctl.conf
sudo sysctl -p
sudo modprobe iptable_nat
sudo iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE
cp cloud_database/vars EasyRSA-3.0.4/vars
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
mkdir -p home/ubuntu/client-configs/keys
chmod -R 700 home/ubuntu/client-configs
./easyrsa gen-req client1 nopass
cp pki/private/client1.key home/ubuntu/client-configs/keys/


echo Terminou
