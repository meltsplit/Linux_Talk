#! /bin/bash

IP=$1
PORT=$2

# sending msg to server

sendChat() {
	timeout 2s nc 1234 #server IP is needed
	timeout 2s nc 1234 < chatLog${roomNum}.txt #server IP is needed	
}

sendChat
