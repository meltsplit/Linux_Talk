#! /bin/bash

ip=$1
port=$2

sendChat() {

	while true
	do
		read -p "msg: " msg
		echo "$(date);${username};${msg}" | nc -q 0 ${ip} ${port}
	done
}

sendChat
