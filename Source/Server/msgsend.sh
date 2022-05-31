ip=$1
port=$2

sendChat() {
	
	sed -i 's/\x0//g' "chatLog_${roomName}.txt"
	timeout 2s nc 10.20.8.75 1234 < ./Data/Chat/"chatLog_${roomName}.txt"
}

sendChat
