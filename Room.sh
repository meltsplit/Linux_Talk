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

sendMessage(){
    	clear
    	updateUI
    	echo " <<Send Message>> " 
    	read -p "Input Message: " msg_s
    	export msg_s

	echo "$(date);${username};${msg_s}" >> chatLog${opt_R}.txt
		
}

deleteMessageProgram(){
	declare -i count=1
	declare -i lineNum=1
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
				if [ ${count} = ${d_opt} ]; then
					sed -i "${lineNum}s/${chatMessage}/---delete Message---/g" chatLog${opt_R}.txt	
					
				fi
				count=`expr $count + 1`
			fi
		fi

		lineNum=`expr $lineNum + 1`

		done < chatLog${opt_R}.txt

}

deleteMessage(){	
	while [ true ]
	do
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
			if [ "${username}" = "${chatUser}" ]; then
				if [ ${timeInterval} -le ${five_Minute} ]; then
					echo "[${count}]"
					echo "User : ${chatUser}" 
					echo "Message : ${chatMessage}"
					echo ""
			
					count=`expr $count + 1`
				fi
			fi
		done < chatLog${opt_R}.txt
		
		echo "Select Number of Message which want to delete"
		
		d_opt=0
		while [ "${d_opt}" != "q" ]
		do
			read -p "Input Number(quit= 'q'): " d_opt
		
	
			if [ ${d_opt} -le ${count} -a ${d_opt} -ge 1 ]; then #IF INPUT 'Q' WARNING HERE	
				deleteMessageProgram ${d_opt}
				break;
			fi
		done
		
		if [ "${d_opt}" = "q" ]; then
			break;
		fi
	done


	echo "deleteMessage End"
	sleep 2
		
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

	#1 = send
	#2 = delete
	#3 = find 
	#4 = exit
    
    msg_s=0
	    while [ $msg_s != 4 ]
	    do
	    updateUI
		    echo "Send:[ENTER]"
		    echo "2) Delete"
		    echo "3) Find"
		    echo "4) Exit"
		    
		    read -p "send=Enter, Choose mode(2-4): " msg_s

		    while [ true ]
		    do
			    if [ ${msg_s} == 2 -o ${msg_s} == 3 -o ${msg_s} == 4 ]; then
				    break
			    else
			    	echo "$(date);${username};${msg_s}" >> chatLog${opt_R}.txt
			    fi
		    updateUI
		    break
	done

	case ${msg_s} in
	"2") deleteMessage;;
	"3") findMessage;;
	"4") exitRoom;;
	esac
done
}


roomView(){
    updateUI
    selectMode
}

#code start point 

roomView






