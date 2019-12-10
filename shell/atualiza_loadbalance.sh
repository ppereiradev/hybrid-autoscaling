#!/bin/bash

#atualizar loading balance
LASTIP="$(cat /var/lib/dhcp/dhcpd.leases | grep -B 8 vm | tail -9 | head -1 | awk '{ print $2 }')"
sed -i "5i server $LASTIP;" /etc/nginx/sites-available/default

#atualizar hostname
echo -e "127.0.0.1\tlocalhost\n127.0.1.1\tvm5" | tee /etc/hosts
echo -e "vm5" | tee /etc/hostname


#escrever no host from loading balance
sshpass -p soeusei ssh -o StrictHostKeyChecking=no $LASTIP -l root "tee /etc/hostname <<<'vm5';echo -e '127.0.0.1\tlocalhost\n127.0.1.1\tvm5' | tee /etc/hostname"

