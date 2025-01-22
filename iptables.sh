iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 8043 -m conntrack --ctstate NEW -j DNAT --to 10.8.0.6:8043
iptables -t nat -A PREROUTING -i eth0 -p udp --dport 29810 -m conntrack --ctstate NEW -j DNAT --to 10.8.0.6:29810
iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 29811 -m conntrack --ctstate NEW -j DNAT --to 10.8.0.6:29811
iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 29812 -m conntrack --ctstate NEW -j DNAT --to 10.8.0.6:29812
iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 29813 -m conntrack --ctstate NEW -j DNAT --to 10.8.0.6:29813
iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 29814 -m conntrack --ctstate NEW -j DNAT --to 10.8.0.6:29814
iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 29815 -m conntrack --ctstate NEW -j DNAT --to 10.8.0.6:29815
iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 29816 -m conntrack --ctstate NEW -j DNAT --to 10.8.0.6:29816
iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 29817 -m conntrack --ctstate NEW -j DNAT --to 10.8.0.6:29817
iptables -t nat -A PREROUTING -i eth0 -p udp --dport 27001 -m conntrack --ctstate NEW -j DNAT --to 10.8.0.6:27001
iptables -t nat -A PREROUTING -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A POSTROUTING -t nat -j MASQUERADE
