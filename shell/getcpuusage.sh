#!/bin/bash 
COUNTER=0
while [  $COUNTER -lt 800 ]; do

	OUTPUT=$(sshpass -p root ssh 192.168.122.88 -l teste "cat /proc/stat")
	read cpu a b c previdle rest <<<"$(echo $OUTPUT)"
	prevtotal=$((a+b+c+previdle))
	sleep 0.5
	OUTPUT=$(sshpass -p root ssh 192.168.122.88 -l teste "cat /proc/stat")
	read cpu a b c idle rest <<<"$(echo $OUTPUT)"
	total=$((a+b+c+idle))
	CPU=$((100*( (total-prevtotal) - (idle-previdle) ) / (total-prevtotal) ))
	echo $CPU >> vm1_3.txt
	sleep 30s
	
	let COUNTER=COUNTER+1
done