install
text
key --skip
keyboard us
lang en_US.UTF-8
skipx
rootpw Ct@2017Yun!@$%.CN
firewall --disabled
authconfig --enableshadow --enablemd5
selinux --disabled
logging --level=info
reboot
services --disabled="avahi-daemon,iscsi,iscsid,firstboot,kdump" --enabled="network,sshd,rsyslog,tuned"
timezone --utc Asia/Shanghai
network  --bootproto=dhcp --device=eth0 --onboot=on
bootloader --location=mbr --append="console=tty0 console=ttyS0,115200" --location=mbr --driveorder="sda" --timeout=1
zerombr yes
clearpart --all

part / --fstype ext4 --size=2048 --grow

%post

cat > /etc/sysconfig/network-scripts/ifcfg-eth0 << EOF
DEVICE="eth0"
BOOTPROTO="dhcp"
ONBOOT="yes"
TYPE="Ethernet"
USERCTL="yes"
PEERDNS="yes"
IPV6INIT="no"
PERSISTENT_DHCLIENT="1"
EOF


echo "ttyS0" >> /etc/securetty
cat <<EOF > /etc/init/ttyS0.conf
start on stopped rc RUNLEVEL=[2345]
stop on starting runlevel [016]
respawn
instance /dev/ttyS0
exec /sbin/agetty /dev/ttyS0 115200 vt100-nav
EOF

#sed_profile
sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/g' /etc/ssh/sshd_config
sed -i 's/#UseDNS yes/UseDNS no/g' /etc/ssh/sshd_config
sed -i 's/GSSAPIAuthentication yes/GSSAPIAuthentication no/g' /etc/ssh/sshd_config

#yum clean all
rm -rf /root/*
rm -rf /var/log/anaconda*
rm -rf /var/log/message
>/var/log/boot.log
>/var/log/messages
>/var/log/cloud-init-output.log
>/var/log/yum.log
%end
%packages --nobase --excludedocs
