#!/bin/bash

log_file="/var/log/yhbp.log"

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

log_message(){
	touch $log_file
	echo "$(date) $1" >> $log_file
}

sudo iptables -I INPUT -p icmp --icmp-type 8 -m state  --state NEW,ESTABLISHED,RELATED -j LOG --log-level=1 --log-prefix "yhbp "
src=""
last_src=""

tail -n0 -F /var/log/syslog | 
	while IFS= read -r line
	do		
		if [[ $line = *"yhbp"* ]]; then
			val=${line% DST=*}
			$src=${val##*SRC=}
			msg="You have been pinged by $(read_conf $src)"
			if [[ $src == $last_src ]]; then
				log_message $msg
			else
				log_message $msg" (visible)"
				notify-send $msg
				$last_src = $src
			fi
		fi
	done
