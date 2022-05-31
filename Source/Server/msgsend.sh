ip=$1
port=$2

sendChat() {
	timeout 2s nc 10.20.12.180 1234 
	timeout 2s nc 10.20.12.180 1234 < ./Data/Chat/chatLog_${roomName}.txt 
}

sendChat
