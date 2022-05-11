#!/bin/bash

username=$1

updateUI(){
    	clear
	echo "<<welcome to room1>>"
    	echo "<<Update UI>>"

    	cat chatLog2.txt
    	echo -e "\n"
}

sendMessage(){
    	clear
    	updateUI
    	echo " <<Send Message>> " 
    	read -p "Input Message: " msg_s
    	export msg_s
    	echo "[32m$(date "+%m-%d %l:%M %^p") ; [34m${username} [0m ; ${msg_s}"
	echo "[32m$(date "+%m-%d%l:%M %^p") ; [34m${username} [0m ; ${msg_s}" >> chatLog2.txt
}
deleteMessage(){
    	clear
    	updateUI
    	echo " <<delete Message>> "
	    read -p "Input Message: " msg_d
	export msg_d
	sed -i "/$msg_d/d" chatLog2.txt
}
findMessage(){
    	clear
    	updateUI
    	echo " <<Find Message>> "
	read -p "Input Message: " msg
	cat chatLog2.txt | grep -niw --color "$msg" 
}
exitRoom(){
	clear
	updateUI
	echo " <<Exit Room>> "
	sleep 1
	break
}

selectMode() {

	#1 = send
	#2 = delete
	#3 = find 
	#4 = exit
	opt=0
	while [ $opt != 4 ]
	do
	echo "1) Send"
	echo "2) Delete"
	echo "3) Find"
	echo "4) Exit"
	while [ true ]
	do
		read -p "Choose mode(1-4): " opt
		if [ ${opt} == 1 -o ${opt} == 2 -o ${opt} == 3 -o ${opt} == 4 ]; then
			break
		fi
	done
	
	
	case ${opt} in
	"1") sendMessage;;
	"2") deleteMessage;;
	"3") findMessage;;
	"4") exitRoom;;
	esac
	updateUI

	done
}

room2(){
    updateUI
    selectMode
}

#code start point 

room2




