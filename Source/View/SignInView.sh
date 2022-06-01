#! /bin/bash

declare exist="false"

# 방향키 입력 받는 함수
input_key() {  
    read -s -n 3 INPUT
    echo $INPUT
}

# 입력한 암호를 검사하는 함수
check_passwd() {
    while [ true ]
    do
    
    tput cup 9 15; echo -n "Password: "   # 패스워드를 입력 받기 위해서
    read -s password				# 패스워드 입력을 -s 옵션으로 받아서 저장한다.
    tput cup 12 1; echo "------------------------------------------------------"  
    tput cup 14 19; echo " login        exit"  # 패스워드 입력하고 엔터를 누를 경우 "login"하기 옵션과 "exit"옵션 중에서 선택할 수 있음

    line=14
    x=17
    while [ true ] 
    do
    tput cup $line $x; echo "->"		# 방향키 움직임을 화살표로 나타내기 위해서
    tput civis					# 커서를 안보이게 하기 위해서
    input=$(input_key)				# 방향키 입력을 저장받는 곳

    if [[ -z $input ]]; then			# 엔터를 눌렀을 경우
	    if [[ $x = 17 ]]; then			# "login" 항목을 눌렀을 경우
		    tput cup 14 17; echo "  "
		    break					# while 문에서 빠져나온다.
	    elif [[ $x = 30 ]]; then			# "exit" 항목을 눌렀을 경우
		    exit					# 쉘 종료
	    fi
    fi
    
    if [[ $input = [C ]]; then			# 우 방향키를 누를 경우
	    x=30
	    tput cup $line 17; echo "  "			# 이전 화살표를 지우기 위해서
    elif [[ $input = [D ]]; then			# 좌 방향키를 누를 경우
	    x=17
	    tput cup $line 30; echo "  "			# 이전 화살표를 지우기 위해서
    fi
    done

	# "login" 항목을 눌렀을 경우
    if [ "${password}" == "`grep -w $username ./Data/User/userID.txt | cut -d ";" -f 2`" ]; then # 암호가 저장된 파일 내용과 일치 하는 경우
		bash ./Source/View/RoomListView.sh  # 채팅방목록 프로그램 실행
		break 
    else 											# 암호가 저장된 파일 내용과 일치 하지 않는 경우
    	sleep 1
    	tput cup 14 19; echo "${password}                      "
	    tput cup 15 19
	    tput blink; echo "Wrong Password!!"		# 잘못된 암호라고 깜박이면서 출력
	    tput sgr0						# 깜박거리는 효과 없애기
        sleep 4
	    tput cup 14 19; echo "                                 "		# 입력한 부분을 지우기 위해서
	    tput cup 15 19; echo "                                 "
	    tput cup 9 4; 
	    tput blink; echo "[Re-enter] "					# 깜박거리는 효과와 함께 다시 암호 입력을 받는다.
	    tput sgr0								# 깜박거리는 효과 없애기
    fi
    done
}


LogIn() {             # 로그인시작(아이디입력)
    while [ true ]
	do
	    cat ./Source/View/defaultView.txt   		# 기본 UI 틀 출력
	    tput cup 3 23; echo "[ Login ]"			
	    tput cup 6 15; echo -n "Username: "		# 아이디 입력받아서 저장하는 곳
	    read username
	    
	    if [ -z "$username" ]; then			# 아무입력 하지 않고 엔터를 눌렀을 경우 -> 종료
		    break
	    fi

	    if [ "${username}" == "`grep -w ${username} ./Data/User/userID.txt | cut -d ";" -f 1`" ]; then
		    exist="true" 	# ID가 존재하는 경우
	    fi
    
	    if [ $exist == "true" ]; then 	# 아이디 존재 하는 경우
		    check_passwd		# 암호 검사 함수 실행	
	    else   # 아이디 존재 하지 않는 경우 -> 아이디 생성 권유
		    tput cup 8 15; echo "Invalid ID"
		    sleep 1
		    tput cup 8 15; echo "*--------------------------------*"
		    tput cup 9 15; echo "| Would you like to create an ID?|"
		    tput cup 10 15; echo "|                                |"
		    tput cup 11 15; echo "|         yes           no       |"
		    tput cup 12 15; echo "*--------------------------------*"
		    line=11
		    x=23
		    while [ true ]		# 아이디 생성 권유 목록에서 "yes" "no"를 방향키로 입력하도록 만들기 위해서 while 문 사용
		    do
			    tput cup $line $x; echo "->"		# 방향키 움직임을 나타내기 위해서
			    tput civis					# 커서 안보이게 하기 위해서
			    input=$(input_key)				# 방향키 입력을 저장받는 곳

			    if [[ -z $input ]]; then		# 엔터를 눌렀을 경우
				    if [[ $x = 23 ]]; then		# "yes" 항목을 눌렀을 경우
					    bash ./Source/View/SignUpView.sh		# SignUp 프로그램 실행
					    break
				    elif [[ $x = 37 ]]; then		# "no" 항목을 눌렀을 경우
				    	    clear
				    	    tput cnorm                 # 커서 보이게 하기 위해서 (다시 아이디부터 입력하기 때문에 커서가 보여야 함)
					    break                      	# 다시시작
				    fi
			    fi
			    
		    if [[ $input = [C ]]; then                      # 우 방향키 눌렀을 경우 "no" 항목으로 이동
			    x=37
			    tput cup $line 23; echo "  "              # 이전 방향키는 지운다.
		    elif [[ $input = [D ]]; then                    # 좌 방향키 눌렀을 경우 "yes" 항목으로 이동
			    x=23
			    tput cup $line 37; echo "  "              # 이전 방향키는 지운다.
		    fi
		    done
		fi
done
}


SignInView() {
    while [ true ]
	do
    clear
    tput cnorm   # 커서를 나타내기 위해서

    LogIn        # 로그인 함수 시작
	
	done
}

SignInView
