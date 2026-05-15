dttt=$(date +%F)
bkdir=~/.orgs/$dttt
mkdir -p $bkdir
sudo iptables-save > $bkdir/iptables-save
sudo iptables -L -nv --line-number > $bkdir/iptables-list
sudo /sbin/iptables-save > $bkdir/rules.v4
sudo /sbin/ip6tables-save > $bkdir/rules.v6
sudo iptables -S

sudo cp /etc/sysctl.conf $bkdir/
sudo cp -r etc/fail2ban $bkdir/
sudo cp -r /etc/apt/apt.conf.d $bkdir/
sudo cp /etc/os-release $bkdir/
sudo cp -r /etc/iptables $bkdir/
sudo cp /usr/lib/os-release $bkdir/
sudo cp -r /etc/ssh $bkdir/
sudo cp -r /etc/conf.d $bkdir/


#iptables -F
#iptables-restore < savedrules.txt
# iptables-save > /root/iptables-backup-$(date +%F)
#echo 0 0 * * * root iptables-save > /root/iptables-backup-$(date +%F) >> /etc/crontab
