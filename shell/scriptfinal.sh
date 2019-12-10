#!/bin/bash
# set n to 1
n=1

while [ $n -le 2 ]
do
        LINES=$(xentop -b -i 1 | grep vm | wc -l)
        echo -e "$n\nQTD VM $LINES\n"

        LINES=$((LINES+2))
        xe vm-install template=vm5-ubuntu16 new-name-label=vm$LINES
        xe vm-start vm=vm$LINES
        PVM=$LINES

        echo -e "PVM $PVM\n"

        sleep 60s


        LASTIP=$(sshpass -p soeusei ssh -o StrictHostKeyChecking=no 192.168.0.203 -l root "cat /var/lib/dhcp/dhcpd.leases | grep -B 8 vm5 | tail -9 | head -1 | awk '{ print \$2 }'")
        echo -e "LASTIP $LASTIP\n"

        #atualiza o apache ports.conf e o /var/www/html/index.html
        sshpass -p soeusei ssh -o StrictHostKeyChecking=no $LASTIP -l root sed -i "5c\Listen\ $LASTIP\:80" /etc/apache2/ports.conf
        sshpass -p soeusei ssh -o StrictHostKeyChecking=no $LASTIP -l root "echo 'vm$LINES' > /var/www/html/index.html"
        sshpass -p soeusei ssh -o StrictHostKeyChecking=no $LASTIP -l root sudo service apache2 start
        sshpass -p soeusei ssh -o StrictHostKeyChecking=no $LASTIP -l root sudo service apache2 restart

        #atualiza o loadbalancer
        sshpass -p soeusei ssh -o StrictHostKeyChecking=no 192.168.0.203 -l root sed -i "5i\ server\ $LASTIP\;" /etc/nginx/sites-available/default
        sshpass -p soeusei ssh -o StrictHostKeyChecking=no 192.168.0.203 -l root service nginx restart


        #sshpass -p soeusei ssh -o StrictHostKeyChecking=no $LASTIP -l root "hostname vm$LINES"
        #sshpass -p soeusei ssh -o StrictHostKeyChecking=no $LASTIP -l root "hostname"
        echo -e "\n\n\n"

        n=$(( n+1 ))     # increments $n
done
