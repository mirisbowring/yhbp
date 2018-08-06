#!/bin/bash

function read_conf (){	
	INPUT=.yhbp
	OLDIFS=$IFS
	IFS=,
	[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
	while read ip name
	do
		if [[ "$ip" == "$1" ]]; then
			echo $name	
		fi
	done < $INPUT	
	if [[ "$ip" == "$1" ]]; then
		echo $name
	fi
	IFS=$OLDIFS
}

tail -n0 -F /var/log/syslog | 
	while IFS= read -r line
	do		
		if [[ $line = *"yhbp"* ]]; then
			val=${line% DST=*}
			value=${val##*SRC=}
			notify-send "You have been pinged by $(read_conf $value)"
		fi
	done
