#!/bin/bash

declare -i five_Minute=600 #temporary 10minutes 

showChat(){
	while read line;
	do
		chatDate_full=`echo ${line}|cut -d ';' -f 1`
		chatDate_HH_mm=`date -d "$chatDate_full" '+%H:%M'`
		
		chatUser=`echo ${line}|cut -d ';' -f 2`
		chatMessage=`echo ${line}|cut -d ';' -f 3`
		
		echo "${chatUser} (${chatDate_HH_mm})"
		echo "Message : ${chatMessage}"
		echo ""
		
	done < chatLog1.txt
}

updateUI(){
    	clear
	echo "<<welcome to room${opt_R}>>"
	
	case ${opt_R} in
		"1") showChat chatLog1.txt ;;
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
		"1") echo "$(date);${username};${msg_s}" >> chatLog1.txt ;; #not spacing
		"2") echo "$(date);${username};${msg_s}" >> chatLog2.txt ;;
		"3") echo "$(date);${username};${msg_s}" >> chatLog3.txt ;;
	esac
}
deleteMessage(){	
	declare -i count=1
    	clear
    	echo " <<delete Message>> ${username}"
	    while read line;
		do
		chatUser=`echo ${line}|cut -d ';' -f 2`
		chatMessage=`echo ${line}|cut -d ';' -f 3`
		
		
		declare -i dateNow_s=`date '+%s'`
		chatDate_full=`echo ${line}|cut -d ';' -f 1`
		declare -i chatDate_s=`date -d "$chatDate_full" '+%s'`
		declare -i timeInterval=`expr ${dateNow_s} - ${chatDate_s}`
		if [ ${username} = ${chatUser} ]; then
			if [ ${timeInterval} -le ${five_Minute} ]; then
				echo "[${count}]"
				echo "User : ${chatUser}" 
				echo "Message : ${chatMessage}"
				echo ""
			
				count=`expr $count + 1`
				sleep 1
			fi
		fi

		done < chatLog1.txt
	echo "deleteMessage End"
	sleep 5
		
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

roomView(){
    updateUI
    selectMode
}

#code start point 

roomView





