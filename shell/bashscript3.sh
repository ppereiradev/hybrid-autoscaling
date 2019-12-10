#!/bin/bash



while true
do

	#conectar ssh da vm
	sshpass -p root ssh 192.168.122.88 -l teste
	read cpu a b c previdle rest < /proc/stat
	prevtotal=$((a+b+c+previdle))
	sleep 0.5
	read cpu a b c idle rest < /proc/stat
	total=$((a+b+c+idle))
	CPU=$((100*( (total-prevtotal) - (idle-previdle) ) / (total-prevtotal) ))
	echo "$CPU"
	
	sleep 10s

done
