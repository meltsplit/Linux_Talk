#! /bin/bash

export username="default name"     # 로그인한 아이디(username) 전역 변수로 설정

<<<<<<< HEAD
ssh -p 1234 test@111.111.111.111
ssh-keygen -t rsa -C "rsa Key" < input_key.txt
ssh-copy-id id_rsa.pub -p 1234 test@111.111.111.111

tutorial(){
=======

# 전체화면을 하지 않으면 화면이 깨지기 때문에 전체화면으로 할 것을 권유해주는 함수
# enter를 누르면 메인 프로그램 시작
tutorial(){                        
>>>>>>> master
tput cup 0 0

while :
do
clear
echo "*-----------------------------------------------------------*" #0
echo "|                                                           |"
echo "|                                                           |"
echo "|                                                           |" #3
echo "|                                                           |"
echo "|                     Use Full Screen!                      |"
echo "|                                                           |"
echo "|                                                           |"
echo "|             You should resize console screen              |"
echo "|                to show this box correctly                 |"
echo "|                                                           |"
echo "|                                                           |"
echo "|                                                           |"
echo "|                   If you confirm this                     |"
echo "|                                                           |"
echo "|                      press [Enter]                        |"
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
echo "*-----------------------------------------------------------*"





input=$(input_key)   				# 방향키를 입력을 저장
if [[ -z $input ]]; then			# 엔터를 누를 경우 본 프로그램 시작
	break
fi
done

}

# 방향키를 입력받는 함수
input_key() {
    read -s -n 3 INPUT
    echo $INPUT

}


# 선택한 항목을 색깔로 표시해주기 위한 함수
items() {
    if [ $1 = $2 ];
    then
	    echo -e "|\t\t     \033[01;43m${items[i]}\033[0m    \t\t|"  # 선택한 항목이면 배경색이 있다.
	    echo -e "|\t\t\t  \t\t\t|"
	    echo -e "|\t\t\t  \t\t\t|"
    else
	    echo -e "|\t\t     \033[01m${items[i]}\033[0m       \t\t|"  # 선택하지 않은 항목이면 배경색이 없다.
	    echo -e "|\t\t\t  \t\t\t|"
	    echo -e "|\t\t\t  \t\t\t|"
    fi
}

# 메인 프로그램 시작
main_view() {

    SELECTED=1  # 시작하면 "Signin" 항목이 선택되어 있도록 만들기 위해서

    while [ True ]
    clear
    do
	    echo -e "*-----------------------------------------------*"      # UI 나타나기 위해서
	    echo -e "|\t\t   <Main View>   \t\t|"
	    echo -e "|\t\t\t  \t\t\t|"
	    echo -e "|\t\t\t  \t\t\t|"
	    echo -e "|\t\t\t  \t\t\t|"
	    echo -e "|\t\t\t  \t\t\t|"

	    for (( i=1 ; i<=3 ; i++ ))                                  # 항목을 표시하기 위한 반복문
	    do
		    items "$i" "$SELECTED"
	    done
	    echo -e "|\t\t\t  \t\t\t|"
	    echo -e "*-----------------------------------------------*"


	    input=$(input_key)           # 방향키를 입력을 저장하는 곳

	    if [[ -z $input ]];          # 엔터를 눌렀을 경우
	    then
		    echo "select: ${items[$SELECTED]}"
		    break                # while 반복문을 나가서 "signin" or "signup" or "exit" 중 하나 실행
	    fi
	    if [[ $input = [A ]];      # up 방향키를 눌렀을 경우
	    then
		    SELECTED=`expr $SELECTED - 1`
	    elif [[ $input = [B ]];    # down 방향키를 눌렀을 경우
	    then
		    SELECTED=`expr $SELECTED + 1`
	    fi

	    if [[ $SELECTED -lt 1 ]];    # up 방향키 눌렀을 때 범위 제한
	    then SELECTED=1
	    elif [[ $SELECTED -gt 3 ]];  # down 방향키 눌렀을 때 범위 제한
	    then SELECTED=3
	    fi

    done
}


selected_item(){
    	case ${items[$SELECTED]} in
	    "1.sign in") bash ./Source/View/SignInView.sh ;; #화면 전환 -> "sign in" 실행
	    "2.sign up") bash ./Source/View/SignUpView.sh ;; #화면 전환 -> "sign up" 실행
	    "3.exit   ") ;;                                  #프로그램 종료
	    *) errorMode break;;
	esac
}

main(){
	tutorial # 맨위 튜토리얼 함수 시작
    timedatectl set-timezone Asia/Seoul	# 채팅하는 시간을 한국시간으로 통일하기 위해서
    items=("start" "1.sign in" "2.sign up" "3.exit   ")    # 선택할 수 있는 목록들
	    SELECTED=0
	    while [ "${items[$SELECTED]}" != "3.exit   " ]  # "exit"를 선택했으면 종료 / 그 외의 경우 while 반복문
		    do
		    tput civis
		    main_view "${items[@]}"
		    selected_item
		
		    done

	echo "<<Program End>>"
}

tput civis    # 커서 안보이기 위해서
main
