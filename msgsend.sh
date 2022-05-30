ip=$1
port=$2

sendChat() {
	timeout 2s nc 1234 #server IP is needed
	timeout 2s nc 1234 < chatLog${roomNum}.txt #server IP is needed
}

sendChat
