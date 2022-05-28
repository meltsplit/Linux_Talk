#! /bin/bash

ip=$1
port=$2
#not actual var
roomNum=1

requestOp() {

	# 입력은 [ ip port 수행명령 전달대상 ] 의 형식으로 설정

	read input <<< `timeout 2s nc -l 1234`
	ip=`echo ${input} | cut -d ' ' -f 1`
	port=`echo ${input} | cut -d ' ' -f 2`
	opt=`echo ${input} | cut -d ' ' -f 3`
	pas=`echo ${input} | cut -d ' ' -f 4`

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

while [ true ]
do
	requestOp
	if [ "${opt}" = "Send" ];
	then
		${msg} >> chatLog${roomNum}.txt
	elif [ "${opt}" = "Delete" ];
	then
		export opt="Delete"
	elif [ "${opt}" = "Exit" ]
	then
		break
	else
		nc -w2 -N ${ip} ${port} < chatLog${roomNum}.txt
	fi
done

