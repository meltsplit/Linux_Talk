#!/bin/bash

dqeclare -i five_Minute=600 #temporary 10minutes 
q
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

#sendMessage(){
    	#clear
    	#updateUI
    	#echo " <<Send Message>> " 
    	#read -p "Input Message: " msg_s
    	#export msg_s
	
	#echo "$(date);${username};${msg_s}" >> chatLog${opt_R}.txt
		
#}

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
	clear
	echo -e "\n\n\n\n\n\n\n               [ Delete Message ]\n\n"
	echo "                    Loading..."
	sleep 1
	
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
	
	clear
	echo -e "\n\n\n\n\n\n\n               [ Go Room${opt_R} ]\n\n"
	echo "                    Loading..."
	sleep 1
		
}


findMessage(){
	clear
	echo -e "\n\n\n\n\n\n\n               [ Find Message ]\n\n"
	echo "                    Loading..."
	sleep 1

	clear
	updateUI
while [ true ]
do
	read -p "Input message[/Q to quit]: " msg
	if [ "${msg}" = "/Q" ];
	then
		break
	fi
	clear
	cat /dev/null > findText.txt
	while read line;
	do
		chatDate_full=`echo ${line}|cut -d ';' -f 1`
		chatDate_HH_mm=`date -d "$chatDate_full" '+%H:%M'`

		chatUser=`echo ${line}|cut -d ';' -f 2`
		chatMessage=`echo ${line}|cut -d ';' -f 3`

		echo "${chatUser} (${chatDate_HH_mm})" >> findText.txt
		echo "Message : ${chatMessage}" >> findText.txt
		echo -e "\n" >> findText.txt
	done < chatLog${opt_R}.txt
GREP_COLOR="46" grep -B 13 -A 12 -E --color=auto ${msg} findText.txt
done
}


exitRoom(){
	clear
	echo -e "\n\n\n\n\n\n\n               [ Exit Room${opt_R} ]\n\n"
	echo "                Loading..."
	
	sleep 2
	break
}


selectMode() {

#Delete: /D
#Find : /F
#Exit : /E
#Enter : 새로고침
    8
	msg_s="0"
	while [ $msg_s != "/E" ]
    	do
	updateUI
		echo "Send:[ENTER], 새로고침은 문자 없이 엔터"
		echo "Delete : /D"   
		echo "Find : /F"     
		echo -e "Exit : /E\n"     
		
		read -p "입력하세요 : " msg_s

		while [ ${msg_s} != "" ]
		do
		    	if [ ${msg_s} == "/D" -o ${msg_s} == "/F" -o ${msg_s} == "/E" ]; then
				break

		    	else
		    		echo "$(date);${username};${msg_s}" >> chatLog${opt_R}.txt
		    	fi
		    	break
		done

		case ${msg_s} in
			"/D") deleteMessage;;
			"/F") findMessage;;
			"/E") exitRoom;;
			"") msg_s=1
			
		esac
	done
}


roomView(){
    updateUI
    selectMode
}

#code start point 

roomView






