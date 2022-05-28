#!/bin/bash

IP=$1
PORT=$2

declare -i five_Minute=600 #temporary 10 minutes 
loadingView(){
	clear
	echo -e "\n\n\n\n\n\n\n             [ $1 ]\n\n"
	echo "                Loading..."
	sleep 1
	clear
}

showchat(){
	for (( i=`expr ${1} - 5`;i<=${1};i++ ))
	do
	if [ $i -lt 1 ]; then
		i=1
	fi
	line=`sed -n ${i}p < chatLog${roomNum}.txt`
	
	chatDate_full=`echo ${line}|cut -d ';' -f 1`
	chatDate_HH_mm=`date -d "$chatDate_full" '+%H:%M'`
	
	chatUser=`echo ${line}|cut -d ';' -f 2`
	chatMessage=`echo ${line}|cut -d ';' -f 3`
	
	if [ "${chatUser}" = "${username}" ]; then
		echo "[[32m${chatUser}[0m] (${chatDate_HH_mm})"
	else 
		echo "[[34m${chatUser}[0m] (${chatDate_HH_mm})"
	fi
		echo "${chatMessage}"
	echo ""
	done
}

updateUI(){
    clear
	echo -e "<<ROOM ${roomNum}>> \n"
	
	showchat 5
		
    	echo -e "\n"
}

deleteMessageProgram(){
	
	declare -i msgNum=1
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
				if [ ${msgNum} = ${deleteNum} ]; then
					sed -i "${lineNum}s/${chatMessage}/---delete Message---/g" chatLog${roomNum}.txt	
					
				fi
				msgNum=`expr $msgNum + 1`
			fi
		fi

		lineNum=`expr $lineNum + 1`

		done < chatLog${roomNum}.txt

}



deleteMessage(){	
	
	loadingView "Delete Message"
	
	while [ true ]
	do
		declare -i msgNum=1
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
					echo "[${msgNum}]"
					echo "User : ${chatUser}" 
					echo "Message : ${chatMessage}"
					echo ""
			
					msgNum=`expr $msgNum + 1`
				fi
			fi
		done < chatLog${roomNum}.txt
		
		echo "Select Number of Message which want to delete"
		
		deleteNum=0
		while [ "${deleteNum}" != "q" ]
		do
			read -p "Input Number(quit= 'q'): " deleteNum
		
	
			if [ ${deleteNum} -le ${msgNum} -a ${deleteNum} -ge 1 ]; then #정확한 값 입력시에만 실행되게
				deleteMessageProgram ${deleteNum}
				break;
			fi
		done
		
		if [ "${deleteNum}" = "q" ]; then
			break;
		fi
	done


	echo "deleteMessage End"
	
	loadingView "Go Room ${roomNum}"
		
}


findMessage(){

	loadingView "Find Message"

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
	done < chatLog${roomNum}.txt
GREP_COLOR="46" grep -B 13 -A 12 -E --color=auto ${msg} findText.txt
done
}


exitRoom(){
	loadingView "Exit Room${roomNum}"
}

sendMessage(){
	#echo "$(date);${username};${msg_s}" >> chatLog${roomNum}.txt
	bash msgsend.sh ${IP} ${PORT}  # send msg to server
}

roomView() {

#Delete: /D
#Find : /F
#Exit : /E
#Enter : 새로고침
	msg_s=0
	while [ true ]
    	do
		updateUI
		echo "Send:[ENTER], 새로고침은 문자 없이 엔터"
		echo "Delete : /D"   
		echo "Find : /F"     
		echo -e "Exit : /E\n"     
		
		read -p "입력하세요 : " msg_s

		if [[ ${msg_s} != "" ]]; then
			case ${msg_s} in
				"/D") deleteMessage;;
				"/F") findMessage;;
				"/E") exitRoom ;;
				*) sendMessage;;
			esac
		fi
		
		if [ ${msg_s} == "/E" ]; then
			break
		fi
	done
}

roomView









