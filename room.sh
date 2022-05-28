declare -i ten_Minute=600

sendMessage(){
	tput cup 28 12
	tput cnorm
	read msg

	echo "$(date);${username};${msg};;;" >> chatLog${roomNum}.txt 
}



deleteSetting(){	
	declare -i delNum=1
	declare -i lineNum=1
		
  	while read line;
	do
		time=`echo ${line}|cut -d ';' -f 1`
		user=`echo ${line}|cut -d ';' -f 2`
		message=`echo ${line}|cut -d ';' -f 3`
		
		declare -i dateNow_s=`date '+%s'`
		declare -i time_s=`date -d "$time" '+%s'`
		declare -i timeInterval=`expr ${dateNow_s} - ${time_s}`

		if [ "${username}" = "${user}" ]; then
			if [ ${timeInterval} -le ${ten_Minute} ]; then
				sed -i "${lineNum}s/.*/${time};${user};${message};deleteable;$delNum/g" chatLog${roomNum}.txt
				delNum=`expr $delNum + 1`
			fi
		fi
		lineNum=`expr $lineNum + 1`
	done < chatLog${roomNum}.txt
		

}

showChat(){
	${mode}View
	x_chat=3
	y_chat=3
	tput cup $y_chat $x_chat
	prev_Date=0
	count=1
	if [ $lastLine -lt 7 ];then
		lastLine=7
	elif [ $lastLine -gt $chatCount ]; then
		lastLine=$chatCount
	fi 
	
	for (( i=`expr ${lastLine} - 6`;i<=${lastLine};i++ ))
	do
	
	prev_Date=${time_Date}
	
	if [ $i -le 1 ]; then
		i=1
	fi
	if [ $count = 1 ]; then
		prev_Date=0
	fi
	
	line=`sed -n ${i}p < chatLog${roomNum}.txt`    
	
	
	time=`echo ${line}|cut -d ';' -f 1`
	user=`echo ${line}|cut -d ';' -f 2`
	message=`echo ${line}|cut -d ';' -f 3`
	deleteable=`echo ${line}|cut -d ';' -f 4`
	deleteNum=`echo ${line}|cut -d ';' -f 5`
	
	time_HH_MM=`date -d "$time" '+%H:%M'`
	time_Date=`date -d "$time" '+%m월 %d일'`
	
	userLength=`echo ${#user}`
	chatLength=`echo ${#message}`
	
	if [ "$prev_Date" != "$time_Date" ]; then
		tput cup $y_chat 23
		echo "(${time_Date})"
	else
		tput cup $y_chat $x_chat
		echo " "
	fi
	
	if [ "$user" = "" ]; then
		tput cup ${y_chat} $x_chat	
		echo " "
		tput cup `expr ${y_chat} + 1` $x_chat	
		echo " "
		tput cup `expr ${y_chat} + 2` $x_chat	
		echo " "
	
	elif [ "${user}" = "${username}" ]; then
		if [ "${mode}" = "Delete" -a "${deleteable}" = "deleteable" ]; then
			tput cup `expr ${y_chat} + 1` `expr 44 - ${userLength}`
			echo "[${deleteNum}] (${time_HH_MM}) [[32m${user}[0m] "
		else
			tput cup `expr ${y_chat} + 1` `expr 48 - ${userLength}`
			echo "(${time_HH_MM}) [[32m${user}[0m] "
		fi
		tput cup `expr ${y_chat} + 2` `expr 58 - ${chatLength}`	
		echo "${message}"
	else 
		tput cup `expr ${y_chat} + 1` $x_chat
		echo "[[34m${user}[0m] (${time_HH_MM})"
		
		tput cup `expr ${y_chat} + 2` $x_chat	
		echo "${message}"
	fi
	
	
	y_chat=`expr ${y_chat} + 3`
	
	count=`expr ${count} + 1`
	done
}

DefaultView(){
clear
tput cup 0 0
echo "*-----------------------------------------------------------*" #0
echo "|                                                           |"
echo "|-----------------------------------------------------------|" #2
echo "|                                                           |" #3
echo "|                                                           |"
echo "|                                                           |"
echo "|                                                           |"
echo "|                                                           |"
echo "|                                                           |"
echo "|                                                           |"
echo "|                                                           |"
echo "|                                                           |"
echo "|                                                           |"
echo "|                                                           |"
echo "|                                                           |"
echo "|                                                           |"
echo "|                                                           |"
echo "|                                                           |"
echo "|                                                           |"
echo "|                                                           |"
echo "|                                                           |"
echo "|                                                           |"
echo "|                                                           |"
echo "|                                                           |"
echo "|                                                           |"
echo "|-----------------------------------------------------------|" 
echo "|          [Find]        [Delete]          [Exit]           |"  #find 26,9 delete 26,23 26,42
echo "|-----------------------------------------------------------|"
echo "|   [Send]                                                  |"  #28,2
echo "|                                                           |"
echo "*-----------------------------------------------------------*"

tput cup 1 27
echo "Room${roomNum}" 

}


DeleteView(){
clear
tput cup 0 0
echo "*-----------------------------------------------------------*" #0
echo "|                                                           |"
echo "|-----------------------------------------------------------|" #2
echo "|                                                           |" #3
echo "|                                                           |"
echo "|                                                           |"
echo "|                                                           |"
echo "|                                                           |"
echo "|                                                           |"
echo "|                                                           |"
echo "|                                                           |"
echo "|                                                           |"
echo "|                                                           |"
echo "|                                                           |"
echo "|                                                           |"
echo "|                                                           |"
echo "|                                                           |"
echo "|                                                           |"
echo "|                                                           |"
echo "|                                                           |"
echo "|                                                           |"
echo "|                                                           |"
echo "|                                                           |"
echo "|                                                           |"
echo "|                                                           |"
echo "|-----------------------------------------------------------|" 
echo "|                          [Exit]                           |"  #find 26,9 delete 26,23 26,42
echo "|-----------------------------------------------------------|"
echo "|   [Send]                                                  |"  #28,2
echo "|                                                           |"
echo "*-----------------------------------------------------------*"

tput cup 1 23
echo "Delete Mode" 

}

selectMark(){
	tput civis
	tput cup $y $x
	echo "[33m>[0m"
	tput cup $y $x
}

Room_Select(){
	x=2
	y=28
	DefaultView 
	chatCount=`wc -l<chatLog${roomNum}.txt`
	lastLine=$chatCount
while :
do  
    mode=Default
	showChat ${lastLine}
	selectMark
	
	read -sn 3 KEY
	case "$y"
	in
	"28")
	if [[ -z ${KEY} ]]; then  
		sendMessage  
		chatCount=`wc -l<chatLog${roomNum}.txt`
		lastLine=$chatCount
		
	elif [ "${KEY}" = "[A" ]; then  #up
		echo " "
		x=9
		y=26	
		selectMark
	else
		continue
	fi	
	;;
	
	"26") 	
	if [[ -z ${KEY} ]]; then  
		 if [ $x = 9 ]; then #FIND
		 	continue
		 elif [ $x = 23  ]; then #DELETE
		 	delete_Select
		 elif [ $x = 42 ]; then #EXIT
		 	break
		 fi
	elif [ "${KEY}" = "[A" ]; then  #up
		echo " "
		x=50
		y=24
		selectMark
	elif [ "${KEY}" = "[B" ]; then #down
		echo " "
		x=2
		y=28 
		selectMark
	elif [ "${KEY}" = "[C" ]; then #right
		if [ $x = 9 ]; then
			echo " "
			x=23
			selectMark
		elif [ $x = 23 ]; then
			echo " "
			x=42
			selectMark
		elif [ $x = 42 ]; then
			continue
		fi
	elif [ "${KEY}" = "[D" ]; then #left
		if [ $x = 9 ]; then
			continue
		elif [ $x = 23 ]; then
			echo " " 
			x=9
			selectMark
		elif [ $x = 42 ]; then
			echo " "
			x=23
			selectMark
		fi
	else
		continue	
	fi
	;;
	
	"24") 
	if [ "${KEY}" = "[A" ]; then  #up
		lastLine=`expr $lastLine - 6`
	elif [ "${KEY}" = "[B" ]; then #down
		if [ $lastLine -eq $chatCount ]; then
			echo " "
			x=9
			y=26
			selectMark
		else
			lastLine=`expr $lastLine + 6`
		fi
			
	else
		continue	
	fi
	;;
	
	esac
done
}


delete_Select(){
	x=2
	y=28
	mode=Delete
	deleteSetting
	DeleteView
	chatCount=`wc -l<chatLog${roomNum}.txt`
	lastLine=$chatCount
while :
do  
	
	showChat ${lastLine}
	selectMark
	
	read -sn 3 KEY
	case "$y"
	in
	"28")
	if [[ -z ${KEY} ]]; then  
		sleep 2 
		
	elif [ "${KEY}" = "[A" ]; then  #up
		echo " "
		x=25
		y=26	
		selectMark
	else
		continue
	fi	
	;;
	"26")
	if [[ -z ${KEY} ]]; then  
		break  
	elif [ "${KEY}" = "[A" ]; then  #up
		x=9
		y=24
		selectMark
	elif [ "${KEY}" = "[B" ]; then #down
		x=2
		y=28
			
	else
		continue	
	fi
	;;
	
	"24") 
	if [ "${KEY}" = "[A" ]; then  #up
		lastLine=`expr $lastLine - 6`
	elif [ "${KEY}" = "[B" ]; then #down
		if [ $lastLine -eq $chatCount ]; then
			echo " "
			x=25
			y=26
			selectMark
		else
			lastLine=`expr $lastLine + 6`
		fi
			
	else
		continue	
	fi
	;;
	
	esac
done
x=2
y=28
tput cup $y $x
mode=Default
}


Room_Select
