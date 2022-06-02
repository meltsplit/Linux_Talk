declare -i ten_Minute=600

GREP_COLOR="46"

#새로운 메시지 수신 알림, 백그라운드로 실행하여서 지속적으로 메세지를 확인할 수 있도록 한다.
notifyCh(){ 
	declare -i showFlag=1
	declare -i alertCount=0
	echo -n 0 > ./Data/User/"prevNum_${username}"
	while [ true ]
	do
		watchCount="$(wc -l < ./Data/Chat/"chatLog_${roomName}.txt")" #현재 채팅 파일의 줄의 수
		chatCount=$(cat ./Data/User/"prevNum_${username}") #프로그램에서 출력되고 있는 채팅의 줄의 수
		if [ -n "${chatCount}" ]; #채팅 파일의 줄의 수의 값이 존재할 때(프로그램이 실행되었을 때)
		then
			if [ "${chatCount}" != "${watchCount}" ]; #채팅 파일과 화면 상에 사용된 채팅 파일의 줄의 수가 다를 시에
			then
				tput sc
				tput cup 28 45
				echo -ne "\e[5m\e[92mNew Message\e[0m" #새로운 메세지 수신 시 커서 깜박이기
				tput rc
				sleep 4s
			fi
		fi
	done
}

#호출 상황: Room뷰에서 Send 기능을 눌렀을 때
sendMessage(){
	tput cup 28 12
	tput cnorm
	read msg     #메세지 입력을 받는다.

	#메세지를 보낸 시간와 보낸 사용자, 메세지의 내용을 필드 ';'로 구분하여 chatLog파일에 추가.
	# delete 가능한 함수는 임시적으로 | 뒤에 숫자를 지정한다.
	echo "$(date);${username};${msg};|" >> ./Data/Chat/"chatLog_${roomName}.txt" 
}

#호출 상황: Delete뷰에서 Delete 기능을 눌렀을 때
#Delete 조건: 자신이 10분 이내에 작성한 메세지. 자신 && 10분 이내
deleteMessage(){
    tput cup 28 13
	tput cnorm

	declare -i lineNum=1 #현재 line이 몇번 째 행인지 저장하는 변수.

	read d # 사용자가 delete가능한 메시지 중 삭제하고 싶은 메세지의 번호를 입력한다.
		
  	while read line; #chatLog파일을 한 줄씩 읽어 line에 저장한다. 이를 마지막 줄까지 반복한다.
	do

		time=`echo ${line}|cut -d ';' -f 1` #line에서 시간 정보를 time에 저장
		user=`echo ${line}|cut -d ';' -f 2` #line에서 사용자 이름를 user에 저장
		message=`echo ${line}|cut -d ';' -f 3` #line에서 메세지 내용를 message에 저장

		delNumber=`echo ${line}|cut -d '|' -f 2` #line에서 delete 번호를 delNum에 저장

		# 사용자가 입력한 번호가 delNum와 일치한다면. (사용자가 삭제하고 싶은 메시지)
		if [ "${d}" = "${delNumber}" ]; then  
				# 그 메세지중 message 부분을 ---(Delete message)---로 치환한다.
                sed -i "${lineNum}s/.*/${time};${user};---(Delete Message)---;|/g" ./Data/Chat/"chatLog_${roomName}.txt"
		fi

		# lineNum은 몇번째 행인지 나타내는 변수. 1씩 증가하도록 해줌.
		lineNum=`expr $lineNum + 1`

	done < ./Data/Chat/"chatLog_${roomName}.txt" 

}

#Delete 가능한 메세지 여부를 표시한 번호들을 모두 삭제한다. 
deleteUnsetting(){
	# ex) "date;user;msg;|1" -> "date;user;msg;|"  
	# 위와 같이 가장 끝에 할당된 삭제 가능 번호를 지우는 기능을 구현한다.

    sed -i 's/|.*/|/g' ./Data/Chat/"chatLog_${roomName}.txt"
}


# Delete가능한 조건 
#   1. 현재 사용자가 입력했는가? 
#   2. 10분 이내에 입력했는가?
# 두 조건을 만족하는 메세지에 번호를 할당해준다.
deleteSetting(){	
	delNum=0
	declare -i lineNum=1
	deleteUnsetting


  	while read line; #파일 한 줄씩 읽는다
	do
		# 각 정보 추출
		time=`echo ${line}|cut -d ';' -f 1`
		user=`echo ${line}|cut -d ';' -f 2`
		message=`echo ${line}|cut -d ';' -f 3`
		
		# 시간 비교
		declare -i dateNow_s=`date '+%s'` # 현재 시각을 UNIX TIMESTAMP 형식으로 저장.
		declare -i time_s=`date -d "$time" '+%s'` # 채팅 시각을 UNIX TIMESTAMP 형식으로 저장.
		declare -i timeInterval=`expr ${dateNow_s} - ${time_s}` #현재 시각과 채팅 시각을 비교한 값을 저장.

		if [ "${username}" = "${user}" ]; then # 조건 1: 사용자가 입력한 메시지인가?
			if [ ${timeInterval} -le ${ten_Minute} ]; then # 조건 2: 10분 이내의 메세지 인가?
				if [ "${message}" != "---(Delete Message)---" ]; then # 추가 조건: 이미 삭제된 메세지는 다시 삭제할 수 없다.
				delNum=`expr $delNum + 1` # delNum이 1씩 증가하도록 설정
				# 위의 조건들을 성립한다면 해당 라인의 말단에 delNum 값을 추가한다.
				sed -i "${lineNum}s/.*/${time};${user};${message};|$delNum/g" ./Data/Chat/"chatLog_${roomName}.txt" 
				

				fi
			fi
		fi
		lineNum=`expr $lineNum + 1` # lineNum이 1씩 증가하도록 설정
	done < ./Data/Chat/"chatLog_${roomName}.txt" 
	
}

# 채팅 부분을 갱신해주는 함수.
# 총 세가지 모드가 있다. 1. Default, 2.Find, 3.Delete
# 매커니즘을 똑같지만 모드마다 부가적인 기능이 추가된다.
# 화면 당 7개의 메세지를 보여준다.
# 어떤 메시를 보여줄지는 lastLine의 값에 따라 결정된다.
# lastLine에 해당하는 채팅은 화면 최하단에 표시된다.
# lastLine 그 위로 6개의 채팅을 더 보여준다.

showChat(){
	${mode}View #mode에 따라 받는 뷰를 표시한다.
	
	# 다른 컴퓨터에서 전송했다면 chatCount와 currentChatCount가 다를 것이다
	currentChatCount=`wc -l < ./Data/Chat/"chatLog_${roomName}.txt"`
	echo -n "${chatCount}" > ./Data/User/"prevNum_${username}"

	
	#만약 채팅방이 빈방이라면 접근하지 못하게 하여 에러 가능성을 줄인다. chatCount는 그 방의 메세지 개수를 저장하는 변수이다.
	if [ "" != "$chatCount" ]; then 
	
	# 다른 컴퓨터에서 전송했다면 chatCount와 currentChatCount가 다를 것이다
	currentChatCount=`wc -l < ./Data/Chat/"chatLog_${roomName}.txt"`
	
		#만약 다른 컴퓨터에서 채팅로그를 수정했다면 조건문 안으로 들어간다.
		if [ "$chatCount" != "$currentChatCount" ]; then
			chatCount=$currentChatCount #바뀐 줄에 맞춰서 chatCount를 다시 늘린다.
			lastLine=$chatCount #lastLine 또한 가장 마지막줄로 다시 할당한다. 
		fi

		# 예외처리: lastLine이 없는 값에 접근하는 오류. 
		if [ $lastLine -lt 7 ];then 
			lastLine=7
		elif [ $lastLine -gt $chatCount ]; then
			lastLine=$chatCount
		fi 
		
		# 예외 처리: chatCount가 1일때도 페이지가 0이라고 계산되는 오류.
		if [ $chatCount -le 1 ]; then 
			chatCount=7
		fi

		# 페이지를 계산하는 수학 식.
		currentPage=`expr \( ${lastLine} + 4 \) / 6` 
		totalPage=`expr \( ${chatCount} + 4 \)  / 6` 
		
		
		tput cup 1 49
		echo "${currentPage}/${totalPage} page" #페이지 우측 상단에 페이지 나타냄.
		
		#화면에 어느 위치에 채팅이 출력될 것인지 설정한다.
		x_chat=3
		y_chat=3
		tput cup $y_chat $x_chat

		# 반복문 마다 1씩 증가.
		count=1

		# find 
		if [ "${findExist}" != "true" ]; then
			findMsg="|||" #의미 없는 값을 넣은 것임.
		fi

		# 채팅 출력할 반복문 시작
		# lastLine-6 부터 lastLine 까지의 메시지를 출력한다.
		for (( i=`expr ${lastLine} - 6`;i<=${lastLine};i++ ))
		do
		
		# 이전 메시지와 지금 메시지의 날짜가 다르다면 채팅에 날짜를 출력할 것이다.
		# 이전 메시지 값을 저장한다.
		prev_Date=${time_Date}
		
		# 예외처리: 0 이하의 행에 접근하는 오류
		if [ $i -le 1 ]; then
			i=1
		fi

		# 첫 반복문에는 prev_Date값이 초기화 되지 않는다. 기본으로 0으로 설정한다.
		if [ $count = 1 ]; then
			prev_Date=0
		fi
		
		# chatLog의 i 번째 행을 line에 저장한다.
		line=`sed -n ${i}p < ./Data/Chat/"chatLog_${roomName}.txt"` 
		
		# line의 각 정보 cut으로 추출
		time=`echo ${line}|cut -d ';' -f 1`
		user=`echo ${line}|cut -d ';' -f 2`
		message=`echo ${line}|cut -d ';' -f 3`

		deleteNum=`echo ${line}|cut -d '|' -f 2`
		
		# 추출한 time을 입맛에 맞게 수정
		time_HH_MM=`date -d "$time" '+%H:%M'` # ex) 15:00 
		time_Date=`date -d "$time" '+%m월 %d일'` # ex) 6월 17일
		
		# 내 메세지는 우측에 구현된다. 
		# 우측 통일을 맞추기 위해 미리 사용자와 메세지 길이를 저장한다.
		userLength=`echo ${#user}`    
		chatLength=`echo ${#message}`
		
		# 만약 이전 메세지와 다른 날짜라면  
		if [ "$prev_Date" != "$time_Date" ]; then # prevDate 기본 값 0이므로 처음엔 무조건 참.
			tput cup $y_chat 23 
			echo "(${time_Date})" # 현재 메세지의 날짜를 출력한다. ()
		else
			tput cup $y_chat $x_chat
			echo " " # 날짜가 같다면 아무것도 출력하지 않는다.
		fi
		
	
		if [ "$user" = "" ]; then 	# 예외 처리: line에서 읽은 정보가 없을 수도 있다. 이땐 아무것도 출력하지 않는다. 대신 3줄은 차지한다. 
			tput cup ${y_chat} $x_chat	
			echo " "
			tput cup `expr ${y_chat} + 1` $x_chat	
			echo " "
			tput cup `expr ${y_chat} + 2` $x_chat	
			echo " "
		
		# 출력 시작
		elif [ "${user}" = "${username}" ]; then # 메세지가 보낸 이가 나라면.
			if [ "${mode}" = "Delete" -a "${deleteNum}" != "" ]; then #[Delete] 모드 일 때
				tput cup `expr ${y_chat} + 1` `expr 44 - ${userLength}` # 우측 정렬 좌표
				echo "[31m[${deleteNum}][0m (${time_HH_MM}) [[32m${user}[0m] " # 삭제번호,시간,유저명 출력
			else                                                      #[Delete] 모드 아닐 때
				tput cup `expr ${y_chat} + 1` `expr 48 - ${userLength}` # 우측 정렬 좌표
				echo "(${time_HH_MM}) [[32m${user}[0m] " # 시간, 초록색 유저명 출력 
			fi
			tput cup `expr ${y_chat} + 2` `expr 58 - ${chatLength}`	
		else  # 메세지 보낸 이가 상대라면 
			tput cup `expr ${y_chat} + 1` $x_chat # 좌측 정렬 좌표
			echo "[[34m${user}[0m] (${time_HH_MM})" # 파란색 유저명, 시각 출력
			
			tput cup `expr ${y_chat} + 2` $x_chat #좌측 정렬 좌표
		fi
			
		if [ "${mode}" = "Find" -a "`echo "${message}" | grep ${findMsg}`" != ""  ]; then #[Find] 모드 일 때
			echo "${message}" | grep --color ${findMsg} # 찾은 메세지에 색깔을 입힌다.
			
			# 예외 처리: echo grep 사용시 우측 뷰 깨지는 오류 해결
			tput cup `expr ${y_chat} + 2` 60
			echo "|"
		else #[Find] 모드 아닐 때
			echo "${message}" #메세지 출력
		fi
		
		# 채팅은 세줄을 차지한다
		#1 빈칸 or 날짜
		#2 (시간) [유저명]
		#3 메세지

		# 한 메세지 당 3줄을 차지하므로 다음 y좌표가 3씩 증가하게 설정한다.
		y_chat=`expr ${y_chat} + 3`
		
		# 메시지당 count가 1씩 증가하도록 설정.
		count=`expr ${count} + 1`
		done #이를 7번 반복한다.
	fi
}

# 호출 상황: Find 기능을 눌렀을 떄 
findMessage(){
    tput cup 28 13
	tput cnorm
	
	# 찾은 메세지가 포함된 행의 번호를 모두 배열에 저장할 것이다.
	findArray=()
	declare -i lineNum=1

	read findMsg # 사용자에게 찾을 메세지 단어를 입력받는다.

	#1. chatLog에서 출력
	#2. 메세지 부분만 출력되게 cut
	#3. 출력된 메세지 중 해당 단어가 있는 지 grep 찾고 출력. -n 옵션으로 몇번 째 행인지 구한다. ex) 1: message here
	#4. 몇번 째 행인지만 나타나게 1번 필드만 cut.
	#5. 이 값들을 Array에 저장.
    findArray=( `cat ./Data/Chat/"chatLog_${roomName}.txt" | cut -d ';' -f 3 | grep -n ${findMsg}| cut -d ':' -f 1` )

    findCount=${#findArray[*]} # 찾은 단어가 몇개인지 저장
    findNum=${findCount} # 찾은 단어가 몇개인지 저장. 

	# 1개 이상이면 단어를 Exist값을 true로 설정 (리눅스에 bool타입은 없지만 표기상 true)
    if [ $findCount -gt 0 ]; then
        findExist=true
    fi

}

DefaultView(){
clear
tput cup 0 0
echo "*-----------------------------------------------------------*" 
echo "|                                                           |"
echo "|-----------------------------------------------------------|" 
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
echo "|                                                           |"  # 상단 행: y=24 x=50           
echo "|-----------------------------------------------------------|"                              
echo "|          [Find]        [Delete]          [Exit]           |"  # 중간 행: y=26 x=9 or 23 or 26 
echo "|-----------------------------------------------------------|"                              
echo "|   [Send]                                                  |"  # 하단행: y=28 x=2              
echo "|                                                           |"
echo "*-----------------------------------------------------------*"


roomHalfLength=`expr ${#roomName} / 2`
tput cup 1 `expr 30 - ${roomHalfLength}`
echo "${roomName}" # 방 이름을 중앙 상단에 표기

}


DeleteView(){
clear
tput cup 0 0
echo "*-----------------------------------------------------------*" 
echo "|                                                           |"
echo "|-----------------------------------------------------------|" 
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
echo "|                                                           |"   # 상단 행: y=24 x=50           
echo "|-----------------------------------------------------------|"                               
echo "|                          [Exit]                           |"   # 중간 행: y=26 x=25
echo "|-----------------------------------------------------------|"                                               
echo "|   [Delete]                                                |"   # 하단행: y=28 x=2                                 
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
echo "|                                                           |"  # 상단 행: y=24 x=50                  
echo "|-----------------------------------------------------------|"                                                             
echo "|          [Prev]          [Next]          [Exit]           |"  # 중간 행: y=26 x=9 or 23 or 26   
echo "|-----------------------------------------------------------|"                                  
echo "|   [Find]                                                  |"  # 하단행: y=28 x=2                 
echo "|                                                           |"
echo "*-----------------------------------------------------------*"

tput cup 1 23
echo "Find Mode" 

}

# 현재 커서 위치 나타내는 함수.
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

	#chatLog에 몇개의 메세지(행)가 저장되어 있는지 확인.
	chatCount=`wc -l < ./Data/Chat/"chatLog_${roomName}.txt"`

	
	#lastLine행의 기본 값: 가장 마지막 메세지의 행.
	lastLine=$chatCount 
while :
do  
    mode=Default # 기본모드 설정.
	showChat #메시지 출력 함수
	selectMark 
	
	read -sn 3 KEY #사용자에게 상하좌우 커서 입력 받음

	case "$y" #현재 커서의 위치에 따라 케이스 나눔. 
	in

	"28") #하단 행
	if [[ -z ${KEY} ]]; then  # [Enter] 누름
		sendMessage  #함수 이동.
		chatCount=`wc -l < ./Data/Chat/"chatLog_${roomName}.txt"` # chatLog의 파일이 수정되었으니 채팅 개수 초기화
		lastLine=$chatCount #마지막 라인도 초기화 하여 가장 하단 메세지가 보이게.
		
	elif [ "${KEY}" = "[A" ]; then  # [UP] 누름
		echo " "
		x=9
		y=26	# 중간 행으로 이동.
		selectMark 
	else
		continue
	fi	
	;;
	
	"26") #중간 행
	if [[ -z ${KEY} ]]; then  # [Enter] 눌렀을 때. (눌렀을 때의 해당 좌표에 따라 다른 동작 수행)
		 if [ $x = 9 ]; then #FIND 좌표일 때 
		 	Find_Select #find 함수 호출
		 elif [ $x = 23  ]; then #Delete 좌표일 때
		 	Delete_Select #delete함수 호출
		 elif [ $x = 42 ]; then #Exit 좌표일 때 
		 	kill ${bgPid} #새로운 메시지 확인 프로세스 종료
		 	break # Room -> RoomListView로 나감.
		 fi
	elif [ "${KEY}" = "[A" ]; then  # [UP] # 커서이동
		echo " " 
		x=58
		y=24
		selectMark
	elif [ "${KEY}" = "[B" ]; then # [Down] # 커서이동
		echo " "
		x=2
		y=28 
		selectMark 
	elif [ "${KEY}" = "[C" ]; then # [Right]
		if [ $x = 9 ]; then # 커서이동
			echo " "
			x=23 
			selectMark
		elif [ $x = 23 ]; then
			echo " "
			x=42
			selectMark
		elif [ $x = 42 ]; then #이미 가장 우측 좌표라면
			continue #아무것도 하지 않는다.
		fi
	elif [ "${KEY}" = "[D" ]; then # [Left]
		if [ $x = 9 ]; then # 이미 가장 좌측좌표라면
			continue #아무고토 안함.
		elif [ $x = 23 ]; then  # 커서이동
			echo " " 
			x=9
			selectMark
		elif [ $x = 42 ]; then # 커서이동
			echo " "
			x=23
			selectMark
		fi
	else
		continue	
	fi
	;;
	
	"24") # 상단 행 / 채팅을 상 하로 움직일 수 있는 행.
	if [ "${KEY}" = "[A" ]; then  #[Up]

	# lastLine을 6씩 줄이며 더 상단 채팅을 보여준다.
	# 화면에 보여지는 채팅은 7개이지만 6씩 줄여서 페이지를 옮겨도 한개의 채팅은 겹치게 구현
		lastLine=`expr $lastLine - 6` 
	elif [ "${KEY}" = "[B" ]; then #[Down]

		#만약 이미 가장 하단 채팅을 보여주고 있을 때 Down 버튼을 누른다면
		if [ $lastLine -eq $chatCount ]; then 
			echo " "
			x=9
			y=26 #중간 행으로 커서 이동
			selectMark
		#가장 하단 채팅이 아니라면
		else 
			lastLine=`expr $lastLine + 6` #6씩 늘려 하단에 있는 채팅을 보여준다.
		fi
			
	else
		continue	
	fi
	;;
	
	esac
done
}

# Room_Select와 동일 매커니즘이므로 추가 코드만 주석 달겠음.
Delete_Select(){
	x=2
	y=28
	mode=Delete

	#delete셋팅 함수를 호출하여 삭제가능한 메세지에 번호 할당하는 작업 실행.
	deleteSetting
	DeleteView

	chatCount=`wc -l < ./Data/Chat/"chatLog_${roomName}.txt"`
	lastLine=$chatCount
while : #키보드를 입력 받고 다시 반복.
do  
       
	showChat
	selectMark
	
	tput cup 1 3
    	echo "deleteable:" $delNum
	
	read -sn 3 KEY

	case "$y"
	in
	"28") #하단 행
	if [[ -z ${KEY} ]]; then # Delete를 눌렀을 때  
		deleteMessage #delete 함수 호출

		# deletesetting을 통해 delete 가능 메세지 다시 할당.
		#(이미 삭제한 메세지에도 삭제가능 번호 계속 부여되는 경우 방지)
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
	"26") #중간 행
	if [[ -z ${KEY} ]]; then  
		break  
	elif [ "${KEY}" = "[A" ]; then  #up
		x=50
		y=24
		selectMark
	elif [ "${KEY}" = "[B" ]; then #down
		x=2
		y=28
			
	else
		continue	
	fi
	;;
	
	"24") #상단행
	if [ "${KEY}" = "[A" ]; then  #up
		lastLine=`expr $lastLine - 6` #채팅 위로
	elif [ "${KEY}" = "[B" ]; then #down
		if [ $lastLine -eq $chatCount ]; then
			echo " "
			x=25
			y=26 # 커서 변경
			selectMark
		else
			lastLine=`expr $lastLine + 6` #채팅 아래로
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
	chatCount=`wc -l< ./Data/Chat/"chatLog_${roomName}.txt"`
	lastLine=$chatCount

    findCount=0
    findNum=0
while :
do 
	showChat 
	selectMark

	tput cup 1 3
    	echo " find: ${findNum}/${findCount}" #좌측 상단에 몇번째 메세지인지, 몇개의 메세지를 찾았는지 표시

	read -sn 3 KEY

	case "$y"
	in
	"28")
	if [[ -z ${KEY} ]]; then  #[Enter] 
		findMessage # find 함수 호출
        if [ "$findExist" = "true" ]; then # 메세지를 찾았다면
		    lastLine=`expr ${findArray[findNum-1]} + 3` # 해당 메세지가 화면의 중간에 오게 lastLine값 변경
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
	if [[ -z ${KEY} ]]; then  #Enter
		 if [ $x = 9 ]; then #prev 버튼 클릭 시

            if [ $findNum -gt 1 ]; then
		 	 findNum=`expr $findNum - 1` # control-F 에서 이전 버튼 이라고 생각하면됨. 이전 메시지 찾음.
             lastLine=`expr ${findArray[findNum-1]} + 3` # 그 찾은 이전 메세지가 화면 중간에 오게 세팅. 
             else 
                continue
            fi
		 elif [ $x = 23  ]; then #next
		 	if [ $findNum -lt ${findCount} ]; then
		 	        findNum=`expr $findNum + 1`  # control-F 에서 이전 버튼 이라고 생각하면됨. 이전 메시지 찾음.
             		 lastLine=`expr ${findArray[findNum-1]} + 3` # 그 찾은 이후 메세지가 화면 중간에 오게 세팅.
             else 
                continue
            fi
		 elif [ $x = 42 ]; then #EXIT
		 	break
		 fi
	elif [ "${KEY}" = "[A" ]; then  #up
		echo " "
		x=58
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

# Room_Select로 나감.
x=2
y=28
tput cup $y $x
findExist=false
mode=Default # 다시 모드 Default로 설정
}

notifyCh &
bgPid=$!
Room_Select
