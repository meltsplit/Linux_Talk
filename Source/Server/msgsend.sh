ip=$1
port=$2

sendChat() {
 
	timeout 2s nc 10.20.8.75 1234 < ./Data/Chat/"chatLog_${roomName}.txt"
}

sendChat
