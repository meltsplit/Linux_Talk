#! /bin/bash


# 방향키를 입력받는 함수
input_key() {
    read -s -n 3 INPUT
    echo $INPUT
}


# "SignUp" 프로그램 시작
SignUpView() {
    clear
    cat ./Source/View/defaultView.txt      # UI의 테두리 부분을 출력한다.
	    tput cnorm                      # 커서를 보이게 한다. (아이디 입력하는 부분을 표시하기 위해서 )
	    tput cup 5 10; echo -n "Your username? : "     
	    read username                   # 아이디를 입력 받는다.

	    if [[ ${#username} -ge 25 ]]; then              # 아이디가 너무 길어지면 UI 테두리를 벗어난다. 그것을 방지하기 위해 글자수 제한
		    tput cup 6 10; echo "error: maximum ID name : 25"
		    tput cup 8 10; echo "Re - Enter please"
		    sleep 4
		    exit
	    
	    else 
	    existing_id=`cat ./Data/User/userID.txt | cut -d ";" -f 1 | grep -w "$username"`  # 아이디 중복검사, 저장된 파일에 이미 있는 아이디인지 판단

		    while [ "$username" = "$existing_id" ]
			    do
				    tput cup 5 10; echo "   ** ID already exists **         " # 이미 있는 아이디라고 출력
				    sleep 2
				    tput cup 5 10; echo -n "Please enter another ID : " 
				    read username                                             # 다른 아이디를 입력받는다.
				    existing_id=`cat ./Data/User/userID.txt | cut -d ";" -f 1 | grep -w "$username"` # 새로 입력받은 아이디 중복검사
			    done

    tput cup 7 10; echo -n "Your password? : "          # 아이디가 중복되지 않으면 패스워드 입력 받는다.
    read -s password                                    # 비밀번호이기 때문에 -s 옵션을 사용하여 안보이게 했다.

    tput cup 10 15; echo "*-----------------------*"    # 아이디 만드는 것을 확정할 것인지 물어본다.
    tput cup 11 15; echo "|                       |"
    tput cup 12 15; echo "|    confirm the ID?    |"
    tput cup 13 15; echo "|                       |"
    tput cup 14 15; echo "|      yes     no       |"
    tput cup 15 15; echo "*-----------------------*"
    line=14
    x=20
while [ true ]           # 바로 위에 "yes", "no" 둘 중에 하나를 방향키로 선택할 수 있도록 만듦
do
    tput cup $line $x; echo "->"                  # 방향키 이동을 나타나기 위해서 화살표모양으로 표현
    tput civis                                    # 커서를 안보이게 하기 위해서
    input=$(input_key)                            # 방향키 입력을 저장하는 곳

    if [[ -z $input ]]; then                      # 엔터를 입력했을 경우
	    if [[ $x = 20 ]]; then                # "yes" 위치에서 엔터를 입력한 경우
		    echo "${username};${password}" >> ./Data/User/userID.txt    # txt 파일에 아이디와 비밀번호를 저장한다.
		    echo -e "\n"
		    SignUp_success  # signUp_success 함수 실행
		    break
	    elif [[ $x = 28 ]]; then              # "no" 위치에서 엔터를 입력한 경우
		    break
	    fi
    fi

    if [[ $input = [C ]]; then           # 좌,우 방향키를 누를경우 이동을 yes no 둘 중에 하나 이동하기 위해서
	    x=28                                   # 우 방향키를 누를경우 "no" 로 이동
	    tput cup $line 20; echo "  "           # 이전 화살표는 지운다.
    elif [[ $input = [D ]]; then                 # 좌 방향키를 누를경우 "yes" 로 이동
	    x=20
	    tput cup $line 28; echo "  "           # 이전 화살표는 지운다.
    fi
done
fi
}


SignUp_success() {   # 회원가입이 성공적으로 되었다는 것을 알려주기 위한 함수
    clear
    cat ./Source/View/defaultView.txt
    tput cup 5 17; echo "*----------------------*"    #" 회원가입이 성공되었다고 출력"
    tput cup 6 17; echo "|                      |"
    tput cup 7 17; echo "|   Sign Up success!   |"
    tput cup 8 17; echo "|                      |"
    tput cup 9 17; echo "*----------------------*"
    sleep 2

}


SignUpView
tput cnorm    # 커서 다시 나타내기 위해서
