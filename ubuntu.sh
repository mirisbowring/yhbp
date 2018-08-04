#!/bin/bash

tail -n0 -F /var/log/syslog | 
	while IFS= read -r line
	do
		if [[ $line = *"yhbp"* ]]; then
			val=${line% DST=*}
			value=${val##*SRC=}
			notify-send "You have been pinged by $value"
		fi
	done
