#!/bin/bash

echo "Running the Autoscaler"

while true
	do
		LINES=$(xentop -b -i 1 | grep vm | wc -l)
		xentop -b -i 2 | grep vm | awk '{print $4 "\t" $6}' | tail -$LINES | awk '{t+=1}{c+=$1}{m+=$2} END {print c/t "\t" m/t}' >> log.txt
		PREDICAO=$(Rscript rscript.R)
		if [ "$PREDICAO" == "NULL" ]
		then
      			echo "\$PREDICAO is empty"

		else
			read VALOR LIMITE <<<"$(echo $PREDICAO)"
			#se o limite superior foi atingido cria vm, else mata vm
			if [ "$LIMITE" == "s" ]
			then
				sleep (echo $(($VALOR - 2)))m
				LINES=$((LINES+1))
      			xe vm-install template=vm5-ubuntu16 new-name-label=vm$LINES
                xe vm-start vm=vm$LINES
				PVM=$LINES

				sleep 60s
                #atualizar loading balance
                                
                LASTIP=$(sshpass -p soeusei ssh -o StrictHostKeyChecking=no 192.168.0.203 -l root "cat /var/lib/dhcp/dhcpd.leases | grep -B 8 vm$LINES | tail -9 | head -1 | awk '{ print \$2 }'")
                sshpass -p soeusei ssh -o StrictHostKeyChecking=no 192.168.0.203 -l root sed -i "5i\ server\ $LASTIP\;" /etc/nginx/sites-available/default
                sshpass -p soeusei ssh -o StrictHostKeyChecking=no 192.168.0.203 -l root service nginx restart


                #sshpass -p soeusei ssh -o StrictHostKeyChecking=no $LASTIP -l root "tee /etc/hostname <<<'vm5';echo -e '127.0.0.1\tlocalhost\n127.0.1.1\tvm5' | tee /etc/hostname"
                sshpass -p soeusei ssh -o StrictHostKeyChecking=no $LASTIP -l root "hostname vm$LINES"



			elif [ "$LIMITE" == "i" ]
			then
				xe vm-shutdown vm=vm$PVM
				sshpass -p soeusei ssh -o StrictHostKeyChecking=no 192.168.0.203 -l root sed -i "/$LASTIP/d" /etc/nginx/sites-available/default

			fi

		fi


		sleep 10s
	done
