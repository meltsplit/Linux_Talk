#! /bin/bash

IP=$1
PORT=$2

sendChat() {
	read -p "msg: " msg
	echo "$(date);${username};${msg}" | nc -q 0 ${IP} ${PORT}
}
sendChat
