#!/bin/bash

rm iwScan_Results.WSP

sudo iw wlan0 scan | grep -v OBSS | grep 'SSID\|signal\|BSS\|DS\ Parameter\ set' > iwScanParsed.WSP

BSS=()
SSID=()
CHAN=()
SIGNAL=()

grep BSS iwScanParsed.WSP | awk '{print $2}' | tr 'a-f' 'A-F' > BSS.WSP
grep SSID iwScanParsed.WSP | awk '{print $2}' > SSID.WSP
grep channel iwScanParsed.WSP | awk '{print $5}' > CHANNEL.WSP
grep signal iwScanParsed.WSP | awk '{print $2}' > SIGNAL.WSP

while read LINE
do
    BSS+=("$LINE")
done < BSS.WSP

while read LINE
do
    SSID+=("$LINE")
done < SSID.WSP 

while read LINE
do
    CHAN+=("$LINE")
done < CHANNEL.WSP

while read LINE
do
    SIGNAL+=("$LINE")
done < SIGNAL.WSP

count=$(( $(grep -c BSS iwScanParsed.WSP) - 1 ))

sudo rm *.WSP

echo -e "MAC_AP\t\t\t Channel \t Signal \t SSID" >> iwScan_Results.WSP
for index in $(seq 0 $count)
do
	echo -e "${BSS[index]} \t${CHAN[index]} \t\t${SIGNAL[index]} \t\t${SSID[index]} " >> iwScan_Results.WSP
done

