#!/bin/bash
echo "Running the Autoscaler"

LB=192.168.0.205
PASSWORD=soeusei

NAMES[1]=vm
LASTIP[1]=192

AUX=30
LOGS=0

while true
        do
                LINES=$(xentop -b -i 1 | grep vm | wc -l)
                xentop -b -i 2 | grep vm | awk '{print $4 "\t" $6}' | tail -$LINES | awk '{t+=1}{c+=$1}{m+=$2} END {print c/t "\t" m "\t" m/t}' >> log.txt
                
                if [ "$AUX" -gt 0 ]
                then
                        sleep 10s
                        AUX=$((AUX-1))
                        continue

                else
                        PREDICAO=$(Rscript rscript.R $LINES)

                        if [ "$PREDICAO" == "NULL" ]
                        then
                                echo "$PREDICAO NULL"

                        else
                                
                                read VALOR LIMITE <<<"$(echo $PREDICAO)"
                                #se o limite superior foi atingido cria vm, else mata vm
                                if [ "$LIMITE" == "s" ]
                                then
                                        
                                        NAMES[$((LINES+1))]=vm$LINES
                                        
                                        xe vm-install template=vm1_ new-name-label=${NAMES[$((LINES+1))]}
                                        xe vm-start vm=${NAMES[$((LINES+1))]}
                                        echo "VM: ${NAMES[$((LINES+1))]}"

                                        #ssh-keygen -R 192.168.0.205 -y
                                        #LASTIP[$((LINES+1))]=$(sshpass -p $PASSWORD ssh -o StrictHostKeyChecking=no $LB -l root "cat /var/lib/dhcp/dhcpd.leases | grep -B 8 webserver | tail -9 | head -1 | awk '{ print \$2 }'")
                                       
                                        AUXIPGREP=""
                                        while [ -z "$AUXIPGREP" ]
                                        do 
                                                AUXIPGREP=$(xe vm-list name-label=${NAMES[$((LINES+1))]} params=networks | head -n 1 | grep "ip:")
                                                AUXIP=$(xe vm-list name-label=${NAMES[$((LINES+1))]} params=networks | head -n 1 | awk '{print $5}')
                                        done

                                        LASTIP[$((LINES+1))]=${AUXIP:0:-1}
                                        echo "NOME VM: ${NAMES[$((LINES+1))]} IP VM: ${LASTIP[$((LINES+1))]}"
                                        
                                        #atualizar apache ports.conf e /var/www/html/index.html
                                        ssh-keygen -R ${LASTIP[$((LINES+1))]} -y
                                        sshpass -p $PASSWORD ssh -o StrictHostKeyChecking=no ${LASTIP[$((LINES+1))]} -l root sed -i "5c\Listen\ ${LASTIP[$((LINES+1))]}\:80" /etc/apache2/ports.conf

                                        sshpass -p $PASSWORD ssh -o StrictHostKeyChecking=no ${LASTIP[$((LINES+1))]} -l root "echo 'vm$LINES' > /var/www/html/index.html"

                                        sshpass -p $PASSWORD ssh -o StrictHostKeyChecking=no ${LASTIP[$((LINES+1))]} -l root sudo service apache2 start
                                        sshpass -p $PASSWORD ssh -o StrictHostKeyChecking=no ${LASTIP[$((LINES+1))]} -l root sudo service apache2 restart


                                        #atualizar loadbalancer
                                        sshpass -p $PASSWORD ssh -o StrictHostKeyChecking=no $LB -l root sed -i "5i\ server\ ${LASTIP[$((LINES+1))]}\;" /etc/nginx/sites-available/default

                                        sshpass -p $PASSWORD ssh -o StrictHostKeyChecking=no $LB -l root service nginx restart

                                        #apagando logs gigantes
                                        sshpass -p $PASSWORD ssh -o StrictHostKeyChecking=no $LB -l root rm -rf /var/log/nginx/access.log*                                   

                                        mv log.txt log.txt$LOGS
                                        LOGS=$((LOGS+1))


                                        AUX=30

                                        echo "LEVANTOU VM: $(date)"                                                       

                                elif [ "$LIMITE" == "i" ]
                                then
                                        LINES=$(xentop -b -i 1 | grep vm | wc -l)

                                        if [ "$LINES" -gt 2 ]
                                        then
                                                echo "NOME VM: ${NAMES[$LINES]}  IP VM: ${LASTIP[$LINES]}"
                                                VMUUID=$(xe vm-list is-control-domain=false name-label=${NAMES[$LINES]} --minimal | cut -d ',' -f1)
                                                xe vm-shutdown uuid=$VMUUID force=true
                                                xe vm-uninstall uuid=$VMUUID force=true

                                                sshpass -p $PASSWORD ssh -o StrictHostKeyChecking=no $LB -l root sed -i "/${LASTIP[$LINES]}/d" /etc/nginx/sites-available/default
                                                sshpass -p $PASSWORD ssh -o StrictHostKeyChecking=no $LB -l root service nginx restart

                                                mv log.txt log.txt$LOGS
                                                LOGS=$((LOGS+1))

                                                AUX=30

                                                echo "MATOU VM: $(date)"                               
                                        fi
                                fi

                        fi
                fi

                sleep 30s
        done
 

 
