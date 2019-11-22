OPENVPN_LOCATION="$(command -v openvpn)"

while [ "$OPENVPN_LOCATION" != '/usr/sbin/openvpn' ]
do
    echo "OPENVPN NOT FOUND or found in wrong location $OPENVPN_LOCATION"  
    sleep 2;
done


sudo cp /var/lib/cloud/instances/*/user-data.txt /home/ubuntu/user-data.txt
echo ' ' >> /home/ubuntu/user-data.txt
echo 'echo "' >> /home/ubuntu/user-data.txt
cat /home/ubuntu/openvpn_client.conf >> /home/ubuntu/user-data.txt
echo '" >> openvpn.config' >> /home/ubuntu/user-data.txt
sudo tmux new -d -s vpn 'openvpn --config /home/ubuntu/openvpn.conf;'