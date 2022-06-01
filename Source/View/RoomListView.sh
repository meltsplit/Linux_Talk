#! /bin/bash

export roomName    # 선택한 방 이름을 전역변수로 설정

# 방향키 입력 받는 함수
input_key() {  
    read -s -n 3 INPUT
    echo $INPUT
}


# 채팅방 목록 프로그램 시작
RoomList() {
    clear
    cat ./Source/View/defaultView.txt			# 기본 UI 틀 출력
    tput civis						# 커서 안보이게 하기 위해서
    tput cup 2 18; echo "[Room List]"
    num=`wc -l ./Data/Room/Roomlist.txt | cut -b 1` # 채팅방 목록 파일의 길이 계산 -> 채팅방 목록에 번호 할당을 위해서
    declare -a roomNum					# 각각의 채팅방을 변수로 저장하기 위해서 배열로 선언
    declare -a roomName_a				# 채팅방의 이름만 저장하기 위해서 배열로 선언
	##
    if [[ $num -ge 8 ]]; then    		# 채팅방 최대 생성을 8개로 제한하기 위해서
    	num=8
    fi

    for(( i=1; i<=$num; i++ )) # 각각의 채팅방 속성(오픈방, 비밀번호방)과 채팅방 이름을 배열로 저장
	    do
		    roomNum[$i]=`sed -n ${i}p < ./Data/Room/Roomlist.txt | cut -d ":" -f 1-2`
	    done
    for(( i=1; i<=$num; i++ )) # 각각의 채팅방 이름을 배열로 저장
	    do
		    roomName_a[$i]=`sed -n ${i}p < ./Data/Room/Roomlist.txt | cut -d ":" -f 2`
	    done
    tput cup 5 13; echo "Add Room                          Exit"   # 방추가, 나가기 옵션 UI 출력

	  line=8
	  for(( n=1; n<=$num; n++ ))   # 각각의 채팅방의 속성과 이름을 출력, 방마다 삭제 옵션 출력
	    do
		    tput cup $line 10; echo ${roomNum[$n]}
		    tput cup $line 45; echo "[Delete]"
		    line=`expr $line + 1`
	    done

    
	  line=8
	  x=7
    while :
	do
	    tput cup $line $x; echo "->"     # 방향키 움직임 화살표로 표현

    input=$(input_key)                 # 방향키나 엔터를 입력받기 위해서

     if [[ -z $input ]];               # 엔터를 눌렀을 경우
	    then
		    clear
		    if [[ $line = 5 ]]; then       		# 엔터 -> 방 추가를 눌렀을 경우
			    if [[ $x = 7 ]]; then
				    if [[ $num == 8 ]]; then			# 방 개수가 최대 개수인 8개일 경우
					    clear
					    tput cup 5 15; echo "delete another room to Add room"	# 더이상 방 추가를 할 수 없다고 출력
					    sleep 2
				    else					# 방 개수가 8개가 아닌 경우 -> 방추가 쉘 실행
					    clear
					    bash ./Source/View/AddRoomView.sh
				    fi
			    elif [[ $x == 42 ]]; then     	# 엔터 -> 나가기를 눌렀을 경우
				    clear
				    tput cup 5 20; echo "*** Exit ***"
				    sleep 2
				    clear
				    tput cnorm
				    exit				# 쉘 종료
			    fi
		
		# 엔터 -> 채팅방 목록중에 하나를 선택했을 경우
		    elif [[ $line -ge 8 ]] && [[ $line -le `expr $num + 7` ]]; then 
			    if [[ $x == 7 ]]; then          # 특정 채팅방을 선택한 경우
				    clear
				    n=`expr $line - 7`
				    roomName=${roomName_a[$n]}	# 선택한 채팅방을 전역변수에 저장
				    
				    # 비밀번호가 있는 방을 선택한 경우
				    if [[ -n `sed -n ${n}p < ./Data/Room/Roomlist.txt | cut -d ":" -f 4` ]]; then
				    cat ./Source/View/defaultView.txt
				    tput cup 7 19; echo "Enter < ${roomName} Room >"
				    tput cnorm
				    tput cup 10 15; echo -n "Enter password: " # 비밀번호 있는 방 -> 암호를 입력받는다
				    read passwd				 # 입력받은 암호 저장
					    if [[ "`sed -n ${n}p < ./Data/Room/Roomlist.txt | cut -d ":" -f 4`" == "$passwd" ]]; then # 암호 일치
						    bash ./Source/View/RoomView.sh			# 해당 채팅방 실행
					    else 											  # 암호 불일치
						    tput cup 12 15; echo "incorrect passwd"		# 잘못된 암호라고 출력
						    sleep 2
					    fi
				    # 비밀번호가 없는 방을 선택한 경우
				    else
					    bash ./Source/View/RoomView.sh 	# 해당 채팅방 실행
				    fi
				    
			    elif [[ $x == 42 ]]; then       # 특정 채팅방의 "[delete]"를 입력했을 경우
				    n=`expr $line - 7`
				    maker=`sed -n ${n}p ./Data/Room/Roomlist.txt | cut -d ":" -f 3`  # 해당 채팅방을 만든 사람을 변수로 저장
				    if [[ ${username} == ${maker} ]]; then
					    `sed -i ${n}d ./Data/Room/Roomlist.txt` # 해당 채팅방을 만든 사람만 삭제 가능
				    else # 해당 채팅방 만든 사람아니면 삭제 불가
				    	    cat ./Source/View/defaultView.txt
				    	    tput cup 6 7; echo "*----------------------------------------*"
					    tput cup 7 7; echo "|  Only \" ID: ${maker}\" can delete this Room |"
					    tput cup 8 7; echo "*----------------------------------------*"
				    sleep 4
				    fi
				  fi
		    fi
		    break
    fi
    
# 방향키 위, 아래, 왼쪽, 오른쪽 움직임 알고리즘
	    if [[ $input = [A ]];		# 위
	    then
		    tput cup $line $x; echo "  "
		    line=`expr $line - 1`
	    elif [[ $input = [B ]];		# 아래
	    then
		    tput cup $line $x; echo "  "
		    line=`expr $line + 1`
		    if [[ $line -lt 8 ]]; 
	    then
			    line=8
		    fi
	    elif [[ $input = [D ]];		# 왼쪽
		    then
		    tput cup $line $x; echo "  "
			    x=7
	    elif [[ $input = [C ]];		# 오른쪽
		    then
			    tput cup $line $x; echo "  "
			    x=42
	    fi

   # 방향키 범위 설정
	    if [[ $line -lt 8 ]] ;
	    then
	      line=5
	    elif [[ $line -gt `expr $num + 7` ]] ;
	    then
	      line=`expr $num + 7`
	    
	    fi

done
}

while :
do
    RoomList
done


