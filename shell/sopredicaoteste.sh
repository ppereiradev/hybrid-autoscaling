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
				echo "SUPERIOR: $VALOR m"

			elif [ "$LIMITE" == "i" ]
			then
				echo "INFERIOR: $VALOR m"				
			fi

		fi


		sleep 10s
	done
