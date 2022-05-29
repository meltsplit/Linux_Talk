#! /bin/bash

IP=$1
PORT=$2

sendChat() {
	timeout 1s nc 1234 #server IP is needed
	timeout 1s nc 1234 < chatLog${roomNum}.txt #server IP is needed	
}

sendChat
