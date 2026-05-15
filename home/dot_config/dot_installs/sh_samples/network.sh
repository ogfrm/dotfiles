local_interface=$(ip route | grep default | sed -e "s/^.*dev.//" -e "s/.proto.*//")
# local_interface=$(ip -o link show | sed -rn '/^[0-9]+: en/{s/.: ([^:]*):.*/\1/p}')
# local_interface=$(ip route get 8.8.8.8 | awk -- '{printf $5}')

# local_wanip4=$(/sbin/ip -o -4 addr list $local_interface | awk '{print $4}' | cut -d/ -f1)
# local_wanip6=$(/sbin/ip -o -6 addr list $local_interface | awk '{print $4}' | cut -d/ -f1)
# local_wanip='dig @resolver4.opendns.com myip.opendns.com +short'
local_wanip4=$(dig @resolver4.opendns.com myip.opendns.com +short -4)
# local_wanip6='dig @resolver1.ipv6-sandbox.opendns.com AAAA myip.opendns.com +short -6'
# local_wanip4=$(curl ifconfig.io >/dev/null)
