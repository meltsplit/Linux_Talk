#!/bin/bash

username=$1

updateUI(){
    	clear
	echo "<<welcome to room1>>"
    	echo "<<Update UI>>"

    	cat chatLog1.txt
    	echo -e "\n"
}

sendMessage(){
    	clear
    	updateUI
    	echo " <<Send Message>> " 
    	read -p "Input Message: " msg_s
    	export msg_s
    	. send.sh ${username}
}
deleteMessage(){
    	clear
    	updateUI
    	echo " <<delete Message>> "
	read -p "Input Message: " msg_d
	export msg_d
	sed -i "/$msg_d/d" chatLog1.txt
}
findMessage(){
    	clear
    	updateUI
    	echo " <<Find Message>> "
	read -p "Input Message: " msg
	cat chatLog1.txt | grep -niw --color "$msg" 
}
exitRoom(){
	clear
	updateUI
	clear
	echo " <<Exit Room>> "
	exit 0
}
errorMode(){
    	clear
    	updateUI
    	echo "not valid mode"

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
	"1") sendMessage break;;
	"2") deleteMessage break;;
	"3") findMessage break;;
	"4") exitRoom break;;
	*) errorMode break;;
	esac
	updateUI

	done
}

room1(){
    updateUI
    selectMode
    	while [ ${opt} != "Exit" ] 
    	do
        	updateUI
        	selectMode	
    	done
}

#code start point 

room1
bash chatroom_list.sh


