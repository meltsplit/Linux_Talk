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
		
	done < chatLog${opt_R}.txt
}

updateUI(){
    	clear
	echo "<<welcome to room${opt_R}>>"
	
	showChat chatLog${opt_R}.txt
		
    	echo -e "\n"
}

deleteMessage(){	
	declare -i count=1
    	clear
    	echo " <<delete Message>> "
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

		done < chatLog${opt_R}.txt
	echo "deleteMessage End"
	sleep 5
		
}
findMessage(){
    	clear
    	updateUI
    	echo " <<Find Message>> "
	read -p "Input Message: " msg
	cat chatLog${opt_R}.txt | grep -niw --color "$msg" 
}
exitRoom(){
	echo " <<Exit Room>> "
	sleep 1
	break
}

selectMode() {

#Delete: /D
#Find : /F
#Exit : /E
    
    msg_s=0
	    while [ $msg_s != "/E" ]
	    do
	    updateUI
		    echo "Send:[ENTER]"
		    echo "Delete : /D"   
		    echo "Find : /F"     
		    echo "Exit : /E"     
		    
		    read -p "send:[Enter], other /D,/F,/E: " msg_s

		    while [ true ]
		    do
			    if [ ${msg_s} == "/D" -o ${msg_s} == "/F" -o ${msg_s} == "/E" ]; then
				    break
			    else
			    	echo "$(date);${username};${msg_s}" >> chatLog${opt_R}.txt
			    fi
		    updateUI
		    break
	done

	case ${msg_s} in
	"/D") deleteMessage;;
	"/F") findMessage;;
	"/E") exitRoom;;
	esac
done
}


roomView(){
    updateUI
    selectMode
}

#code start point 

roomView





