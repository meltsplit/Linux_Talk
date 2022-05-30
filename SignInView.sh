#! /bin/bash

declare exist="false"

#방향키 입력 받는 함수
input_key() {  
    read -s -n 3 INPUT
    echo $INPUT
}

check_passwd() {
    while [ true ]
    do
    
    tput cup 9 15; echo -n "Password: "
    read -s password
    tput cup 12 1; echo "------------------------------------------------------"
    tput cup 14 19; echo " login        exit"

    line=14
    x=17
    while [ true ] 
    do
    tput cup $line $x; echo "->"
    tput civis
    input=$(input_key)

    if [[ -z $input ]]; then
	    if [[ $x = 17 ]]; then
		    tput cup 14 17; echo "  "
		    break
	    elif [[ $x = 30 ]]; then
		    exit
	    fi
    fi
    
    if [[ $input = [C ]]; then
	    x=30
	    tput cup $line 17; echo "  "
    elif [[ $input = [D ]]; then
	    x=17
	    tput cup $line 30; echo "  "
    fi
    done

    if [ "${password}" == "`grep -w $username userID.txt | cut -d ";" -f 2`" ]; then #Success
		bash RoomListView.sh  # 화면 전환
		break 
    else 
    	sleep 1
    	tput cup 14 19; echo "${password}                      "
	    tput cup 15 19
	    tput blink; echo "Wrong Password!!"
	    tput sgr0
        sleep 4
	    tput cup 14 19; echo "                                 "
	    tput cup 15 19; echo "                                 "
	    tput cup 9 4; 
	    tput blink; echo "[Re-enter] "
	    tput sgr0
    fi
    done
}


LogIn() {  #로그인시작(아이디입력)
	    tput cup 3 23; echo "[ Login ]"
	    tput cup 6 15; echo -n "Username: "
	    read username
	    
    while read line; 
    do
        if [ "${username}" == "`echo $line | cut -d ";" -f 1`" ]; then
			    exist="true" #ID가 존재
			    break
        fi
    done < userID.txt
    
	    if [ $exist == "true" ]; then # 아이디 존재 하는 경우
		    check_passwd
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
		    while [ true ]
		    do
			    tput cup $line $x; echo "->"
			    tput civis
			    input=$(input_key)

			    if [[ -z $input ]]; then
				    if [[ $x = 23 ]]; then
					    bash SignUpView.sh 
				    fi
				    break
			    fi
			    
		    if [[ $input = [C ]]; then
			    x=37
			    tput cup $line 23; echo "  "
		    elif [[ $input = [D ]]; then
			    x=23
			    tput cup $line 37; echo "  "
		    fi
		    done
		fi
}


SignInView() {
    while [ true ]
	do
    clear
    tput cnorm
    cat defaultView.txt
    LogIn
	done
}

SignInView
