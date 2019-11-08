#!/bin/bash
# modified from https://www.digitalocean.com/community/tutorials/how-to-set-up-an-openvpn-server-on-ubuntu-18-04 
# best in amazon ubuntu ec2 images
CLIENT_NAME=$1
OPENVPN_SERVER=$2
CA_DIR=/home/ubuntu/EasyRSA-3.0.4/
CLIENT_DIR=/home/ubuntu/openvpn/clients
KEYS_DIR=/home/ubuntu/files

mkdir -p ${CLIENT_DIR}
 
cd ${CA_DIR}
./easyrsa gen-req ${CLIENT_NAME} nopass << EOF

EOF
cp pki/private/${CLIENT_NAME}.key ${KEYS_DIR}
cp pki/private/${CLIENT_NAME}.key home/ubuntu/client-configs/keys/
./easyrsa sign-req client ${CLIENT_NAME} << EOF
yes
EOF
cp pki/issued/${CLIENT_NAME}.crt ${KEYS_DIR}
 
echo "client
dev tun
proto udp
remote ${OPENVPN_SERVER} 1194
user nobody
group nogroup
persist-key
persist-tun
cipher AES-128-CBC
auth SHA256
key-direction 1
remote-cert-tls server
comp-lzo
verb 3" >> ${CLIENT_DIR}/${CLIENT_NAME}.ovpn

echo  '<ca>' >> ${CLIENT_DIR}/${CLIENT_NAME}.ovpn
cat ${KEYS_DIR}/ca.crt >> ${CLIENT_DIR}/${CLIENT_NAME}.ovpn
echo  '</ca>\n<cert>' >>  ${CLIENT_DIR}/${CLIENT_NAME}.ovpn
cat  ${KEYS_DIR}/${CLIENT_NAME}.crt >> ${CLIENT_DIR}/${CLIENT_NAME}.ovpn
echo  '</cert>\n<key>' >> ${CLIENT_DIR}/${CLIENT_NAME}.ovpn
cat ${KEYS_DIR}/${CLIENT_NAME}.key >> ${CLIENT_DIR}/${CLIENT_NAME}.ovpn
echo  '</key>\n<tls-auth>' >> ${CLIENT_DIR}/${CLIENT_NAME}.ovpn
cat  ${KEYS_DIR}/ta.key >> ${CLIENT_DIR}/${CLIENT_NAME}.ovpn
echo  '</tls-auth>' >> ${CLIENT_DIR}/${CLIENT_NAME}.ovpn
 
echo  "Client File Created - ${CLIENT_DIR}/${CLIENT_NAME}.ovpn"
