
# nmap variant
nmap portquiz.net | grep -i open

# curl variant
curl -s http://portquiz.net:80

# wget variant
wget -q http://portquiz.net:80

# nc variant (5 sec timeout)
nc -z portquiz.net 80 -w 5
