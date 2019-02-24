#1. Install the necessary software------------------------------
#1.1. Install IW
sudo apt-get install iw -y
sudo iw list
#1.2. Install DHCP Server
sudo apt-get install isc-dhcp-server -y
#1.3.Install Hostapd
sudo apt-get install hostapd -y
#1.4. Install iptables
sudo apt-get install iptables -y
#
##2. Configure DHCP---------------------------------------------
sudo vi /etc/dhcp/udhcp.conf
subnet 10.10.0.0 netmask 255.255.255.0{
range 10.10.0.25 10.10.0.150;
option domain-name-servers 8.8.4.4;
option routers 10.10.0.1;
interface wlan0;
}
#
###3. Configure Hostapd------------------------------------------
sudo vi /etc/hostapd/hostapd
interface=wlan0
driver=nl80211
ssid=group_12
hw_mode=g
channel=11
ignore_broadcast_ssid=0
wpa=0
wpa_passphrase=khoangoc
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP
macaddr_acl=0
#
####4. Start Wifi ---------------------------------------------
#4.1 Set IP for Wlan0
sudo ifconfig wlan0 10.10.0.1
#4.2 Start DHCP Server
sudo /etc/init.d/isc-dhcp-server restart
#4.3 Start Hostapd
sudo hostapd -d /etc/hostapd/hostapd.conf
#4.4 reboot 
sudo reboot

#####5. Routing Wifi connect to internet
#5.1 Configure IP static
sudo vi /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
allow-hotplug eth0
iface eth0 inet manual

auto wlan0
iface wlan0 inet static
address 10.10.0.1
netmask 255.255.255.0
######6. NAT 
#6.1 config sysctl.conf hiển thị hoặc thay đổi một tham số nào đó của kernel, Tham số ở đây là "net.ipv4.ip_forward=0-1" cho phép packet forward thong qua cac interface 
sudo /etc/sysctl.conf
net.ipv4.ip_forward=1
#create dhcp.sh
sudo vi routing.sh
sudo /etc/init.d/isc-dhcp-server
#6.2 create routing.sh
sudo vi routing.sh
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
#6.3 create ap.sh
sudo vi ap.sh
sudo hostapd -d /etc/hostapd/hostapd.conf
#6.4 config startup with kenel
sudo vi /etc/rc.local
sudo bash /home/pi/dhcp.sh
sudo bash /home/pi/ap.sh
sudo bash /home/pi/routing.sh



note": stop hostapd
killall hostapd  
brctl delif br0 eth0  
brctl delif br0 wlan0  
ifconfig br0 down  
brctl delbr br0  
service networking restart  

routing.sh
sudo /etc/init.d/isc-dhcp-server
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
sudo hostapd -d /etc/hostapd/hostapd.conf




