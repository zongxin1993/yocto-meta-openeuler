
echo 'para:net-name ipaddr gatewayip dnsip,for example:eth0 192.168.11.46 192.168.11.1 192.168.11.1'


echo 'Net Config Start...'
set -e 

if [ $# -lt 2 ];then
	echo  "Error, missing arguments！"
	exit 1
fi

ifconfig $1 $2

ifconfig lo 127.0.0.1  
sleep 3

if [ ! -e /etc/resolv.conf ]; then
	cd /etc/
	mkdir -p ../run/systemd/resolve/
	touch ../run/systemd/resolve/resolv.conf
	ln -s ../run/systemd/resolve/resolv.conf /etc/resolv.conf
fi

sleep 3

if [ $# -ge 4 ];then
	echo "nameserver $4" >> /etc/resolv.conf
fi

sleep 3

if [ $# -ge 3 ];then
	route add default gw $3
fi

exit 0

