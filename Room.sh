#!/bin/bash

showChat(){
	while read line;
	do
		chatDate_full=`echo ${line}|cut -d ';' -f 1`
		chatDate_HH_mm=`date -d "$chatDate" +%H:%m`
		echo ${chatDate_HH_mm}
	done < chatLog1.txt
}

updateUI(){
    	clear
	echo "<<welcome to room1>>"
    	echo "<<Update UI>>"
	
	case ${opt_R} in
		"1") showChat chatLog1.txt ;;
		# "1") showChat;;
		"2") cat chatLog2.txt ;;
		"3") cat chatLog3.txt ;;
	esac
    	echo -e "\n"
}

sendMessage(){
    	clear
    	updateUI
    	echo " <<Send Message>> " 
    	read -p "Input Message: " msg_s
    	export msg_s

	case ${opt_R} in
		"1") echo "$(date) ; ${username} ; ${msg_s}" >> chatLog1.txt ;;
		"2") echo "$(date) ; ${username} ; ${msg_s}" >> chatLog2.txt ;;
		"3") echo "$(date) ; ${username} ; ${msg_s}" >> chatLog3.txt ;;
	esac
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

room1(){
    updateUI
    selectMode
}

#code start point 

room1




