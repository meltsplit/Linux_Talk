#! /bin/bash


input_key(){                    # 방향키 입력 받는 함수방향키 입력 받는 함수
    read -s -n 3 INPUT
    echo $INPUT
}

Add_room(){
    line=7
    x=5
while [ true ]
do
    clear
    cat defaultView.txt         # 기본 UI 틀 출력
    tput civis                  # 커서 숨기기

    tput cup 2 21; echo "[ Add Room ]"    # 기본 UI 출력
    tput cup 5 20; echo "<< Room Type >>"
    tput cup 6 1; echo "------------------------------------------------------"
    tput cup 7 8; echo "[Secret]       [Public]       [exit]"
    tput cup 8 1; echo "------------------------------------------------------"
    tput cup $line $x; echo "->"         # 방향키 움직임 구현

    input=$(input_key)

    if [[ -z $input ]]; then
	    if [[ $x == 5 ]]; then
		    tput cup 9 8; echo "Type : Secret talk"
		    secret
	    elif [[ $x == 20 ]]; then
		    tput cup 9 8; echo "Type : Public talk"
		    public
	    elif [[ $x == 35 ]]; then
		    tput cup 9 8; echo "Exit [ Add Room ]"
		    exit
	    fi
    fi
#5,20,35
    if [[ $input = [D ]]; then
	    tput cup 7 $x; echo "  "
	    x=`expr $x - 15`
    elif [[ $input = [C ]]; then
	    tput cup 7 $x; echo "  "
	    x=`expr $x + 15`
    fi

    if [[ $x -le 5 ]]; then
	    x=5
		elif [[ $x -gt 35 ]]; then
	    x=35
    fi

done
}

public(){                      # 오픈채팅방 생성 함수

    tput cnorm
    tput cup 10 14; echo -n "room name: "
    read public_room

    if [[ ${#public_room} -ge 15 ]]; then          # 글자수 제한
	    tput cup 12 14; echo "Room name maximum : 15"
	    sleep 3
	    tput cup 12 14; echo "                      "
    else
    echo "(Public) Room:${public_room}:${username}" >> Roomlist.txt
    touch chatLog_${public_room}.txt
    tput cup 12 14; echo "Add ${public_room} Room success!"
    sleep 2
    exit
    fi
}

secret(){                      # 비밀 채팅방 생성 함수

    tput cnorm
    tput cup 10 14; echo -n "room name: "
    read secret_room

    if [[ ${#public_room} -ge 15 ]]; then          # 글자수 제한
	    tput cup 12 14; echo "Room name maximum : 15"
	    sleep 3
	    tput cup 12 14; echo "                      "
    else
    tput cup 11 14; echo -n "enter passwd: "
    read -s secret_room_p

    echo "(Secret) Room:${secret_room}:${username}:${secret_room_p}" >> Roomlist.txt
    touch chatLog_${secret_room}.txt

    tput cup 13 14; echo "Add ${secret_room} Room success!"
    sleep 2
    exit
    fi
    
}


Add_room
