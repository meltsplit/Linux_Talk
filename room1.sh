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
	sed -i "/$msg1/d" chatLog1.txt
}
findMessage(){
    	clear
    	updateUI
    	echo " <<Find Messeage>> "
	read -p "Input Message: " msg
	cat chatLog1.txt | grep -niw --color "$msg" 
}
exitRoom(){
	clear
	updateUI
	clear
	echo " <<Exit Room>> "
	exit 0 # 종료가 안되어서 임시로 해놓음.
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
    
    	PS3="Input an integer(1-4): "
    	select opt in "Send" "Delete" "Find" "Exit"
    	do
    	case ${opt} in
    	"Send") sendMessage break;;
    	"Delete") deleteMessage break;;
    	"Find") findMessage break;;
    	"Exit") exitRoom break;;
    	*) errorMode break;;
    	esac
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

