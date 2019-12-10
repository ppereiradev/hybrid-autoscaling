#!/bin/bash

echo "Running the Autoscaling"


var=$(wc -l output.txt | awk '{print $1}')

if [[ $var -gt 20 ]]
then
	echo "var gt 20"
else
	echo "ELSE"
fi

#OUTPUT="$(Rscript teste.R)"

#CALCULO="${OUTPUT:${#OUTPUT}-1}"

#RESULTADO=$((CALCULO-3))

#sudo virsh --connect qemu:///system list

#sleep $[RESULTADO]s

#sudo virt-clone --connect qemu:///system --original vm_template --name vm3 --file /var/lib/libvirt/images/vm3.qcow2

#sudo virsh start vm3

#sudo virsh --connect qemu:///system list

#sleep 10s

#sudo virsh destroy vm3

#sudo virsh --connect qemu:///system list 

#sudo virsh undefine vm3

#sudo rm /var/lib/libvirt/images/vm3.qcow2
