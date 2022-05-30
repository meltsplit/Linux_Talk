declare -i ten_Minute=600
GREP_COLOR="46"
ip=`ip route get 8.8.8.8 | cut -d ' ' -f 7 | tr -s '\n'`

sendMessage(){
	tput cup 28 12
	tput cnorm
	read msg

	echo "$(date);${username};${msg};${ip};|" >> chatLog_${roomName}.txt
	bash msgsend.sh
}

deleteMessage(){
    tput cup 28 13
	tput cnorm
	declare -i lineNum=1

	read d
		
  	while read line;
	do

		time=`echo ${line}|cut -d ';' -f 1`
		user=`echo ${line}|cut -d ';' -f 2`
		message=`echo ${line}|cut -d ';' -f 3`

		delNum=`echo ${line}|cut -d '|' -f 2`

		if [ "${d}" = "${delNum}" ]; then
                sed -i "${lineNum}s/.*/${time};${user};---(Delete Message)---;|/g" chatLog_${roomName}.txt
		fi

		lineNum=`expr $lineNum + 1`

	done < chatLog_${roomName}.txt
		

}
deleteUnsetting(){
    sed -i 's/|.*/|/g' chatLog_${roomName}.txt
}



deleteSetting(){	
	declare -i delNum=1
	declare -i lineNum=1
	deleteUnsetting
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
				if [ "${message}" != "---(Delete Message)---" ]; then
				sed -i "${lineNum}s/.*/${time};${user};${message};|$delNum/g" chatLog_${roomName}.txt
				delNum=`expr $delNum + 1`
				fi
			fi
		fi
		lineNum=`expr $lineNum + 1`
	done < chatLog_${roomName}.txt
	
}

showChat(){
	${mode}View
	x_chat=3
	y_chat=3
	tput cup $y_chat $x_chat
	prev_Date=0
	count=1
	
	timeout 1s nc -l 1234
	timeout 1s nc -l 1234 > chatLog_${roomName}.txt

    if [ "${findExist}" != "true" ]; then
        findMsg="|||"
    fi

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
	
	line=`sed -n ${i}p < chatLog_${roomName}.txt`    
	
	
	time=`echo ${line}|cut -d ';' -f 1`
	user=`echo ${line}|cut -d ';' -f 2`
	message=`echo ${line}|cut -d ';' -f 3`

	deleteNum=`echo ${line}|cut -d '|' -f 2`
	
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
		if [ "${mode}" = "Delete" -a "${deleteNum}" != "" ]; then
			tput cup `expr ${y_chat} + 1` `expr 44 - ${userLength}`
			echo "[31m[${deleteNum}][0m (${time_HH_MM}) [[32m${user}[0m] "
		else
			tput cup `expr ${y_chat} + 1` `expr 48 - ${userLength}`
			echo "(${time_HH_MM}) [[32m${user}[0m] "
		fi
		tput cup `expr ${y_chat} + 2` `expr 58 - ${chatLength}`	
	else 
		tput cup `expr ${y_chat} + 1` $x_chat
		echo "[[34m${user}[0m] (${time_HH_MM})"
		
		tput cup `expr ${y_chat} + 2` $x_chat	
	fi
        
    if [ "${mode}" = "Find" -a "`echo "${message}" | grep ${findMsg}`" != ""  ]; then
        echo "${message}" | grep --color ${findMsg}
        tput cup `expr ${y_chat} + 2` 60
        echo "|"
    else
        echo "${message}"
	fi
	
	y_chat=`expr ${y_chat} + 3`
	
	count=`expr ${count} + 1`
	done
}

findMessage(){
    tput cup 28 13
	tput cnorm
	
	findArray=()
	declare -i lineNum=1

	read findMsg

    chatLog_${roomName}.txt | cut -d ';' -f 3 | grep -c ${findMsg}
    findArray=( `cat chatLog_${roomName}.txt | cut -d ';' -f 3 | grep -n  ${findMsg}| cut -d ':' -f 1` )
    findCount=${#findArray[*]}
    findNum=${findCount}

    if [ $findCount -gt 0 ]; then
        findExist=true
    fi

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
echo "${roomName}" 

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
echo "|   [Delete]                                                |"  #28,2
echo "|                                                           |"
echo "*-----------------------------------------------------------*"

tput cup 1 23
echo "Delete Mode" 

}


FindView(){
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
echo "|          [Prev]          [Next]          [Exit]           |"  #find 26,9 delete 26,23 26,42
echo "|-----------------------------------------------------------|"
echo "|   [Find]                                                  |"  #28,2
echo "|                                                           |"
echo "*-----------------------------------------------------------*"

tput cup 1 23
echo "Find Mode" 

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
	chatCount=`wc -l<chatLog_${roomName}.txt`
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
		chatCount=`wc -l<chatLog_${roomName}.txt`
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
		 	Find_Select
		 elif [ $x = 23  ]; then #DELETE
		 	Delete_Select
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


Delete_Select(){
	x=2
	y=28
	mode=Delete
	deleteSetting
	DeleteView
	chatCount=`wc -l<chatLog_${roomName}.txt`
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
		deleteMessage 
		deleteSetting
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

deleteUnsetting

mode=Default
}


Find_Select(){
	x=2
	y=28

	FindView 
    mode=Find
    findExist=false
	chatCount=`wc -l<chatLog_${roomName}.txt`
	lastLine=$chatCount

    findCount=0
    findNum=0
while :
do 
	showChat ${lastLine}
	selectMark

	tput cup 28 63
    echo "${findNum}/${findCount}"

	read -sn 3 KEY
	case "$y"
	in
	"28")
	if [[ -z ${KEY} ]]; then  
		findMessage
        if [ "$findExist" = "true" ]; then
		    lastLine=`expr ${findArray[findNum-1]} + 3`
        fi
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
		 if [ $x = 9 ]; then #prev
            if [ $findNum -gt 1 ]; then
		 	 findNum=`expr $findNum - 1`
             lastLine=`expr ${findArray[findNum-1]} + 3`
             else 
                continue
            fi
		 elif [ $x = 23  ]; then #next
		 	if [ $findNum -lt ${findCount} ]; then
		 	        findNum=`expr $findNum + 1`
             		 lastLine=`expr ${findArray[findNum-1]} + 3`
             else 
                continue
            fi
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

x=2
y=28
tput cup $y $x
findExist=false
mode=Default
}



Room_Select
