#! /bin/bash

export roomName

#방향키 입력 받는 함수
input_key() {  
    read -s -n 3 INPUT
    echo $INPUT
}


RoomList() {
    clear
    cat ./Source/Support/defaultView.txt
    tput civis
    tput cup 2 18; echo "[Room List]"
    num=`wc -l ./Data/Room/Roomlist.txt | cut -b 1` # 파일의 길이 -> 채팅방 목록에 번호 할당을 위해서
    declare -a roomNum
    declare -a roomName_a
	##
    num=8

    for(( i=1; i<=$num; i++ )) # 채팅방 목록에 각각 번호 할당
	    do
		    roomNum[$i]=`sed -n ${i}p < ./Data/Room/Roomlist.txt | cut -d ":" -f 1-2`
	    done
    for(( i=1; i<=$num; i++ ))
	    do
		    roomName_a[$i]=`sed -n ${i}p < ./Data/Room/Roomlist.txt | cut -d ":" -f 2`
	    done
    tput cup 5 13; echo "Add Room                          Exit"

	  line=8
	  for(( n=1; n<=$num; n++ ))   #채팅방 목록 출력, 방마다 삭제 옵션 출력
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
		    if [[ $line = 5 ]]; then       # 엔터 -> 방추가를 눌렀을 경우
			    if [[ $x = 7 ]]; then
				    if [[ $num == 8 ]]; then
					    clear
					    tput cup 5 15; echo "delete another room to Add room"
					    sleep 2
				    else
					    clear
					    bash ./Source/Support/Addroom.sh
				    fi
			    elif [[ $x == 42 ]]; then     # 엔터 -> 나가기를 눌렀을 경우
				    clear
				    tput cup 5 20; echo "*** Exit ***"
				    sleep 2
				    clear
				    tput cnorm
				    exit
			    fi

		    elif [[ $line -ge 8 ]] && [[ $line -le `expr $num + 7` ]]; then # 엔터 -> 채팅방 목록중에 하나를 선택했을 경우
			    if [[ $x == 7 ]]; then          # 특정 채팅방 선택
				    clear
				    n=`expr $line - 7`
				    roomName=${roomName_a[$n]}
				    
				    if [[ -n `sed -n ${n}p < ./Data/Room/Roomlist.txt | cut -d ":" -f 4` ]]; then
				    cat ./Source/Support/defaultView.txt
				    tput cup 7 19; echo "Enter < ${roomName} Room >"
				    tput cnorm
				    tput cup 10 15; echo -n "Enter password: "
				    read passwd
					    if [[ "`sed -n ${n}p < ./Data/Room/Roomlist.txt | cut -d ":" -f 4`" == "$passwd" ]]; then
						    bash ./Source/View/room.sh
					    else 
						    tput cup 12 15; echo "incorrect passwd"
						    sleep 2
					    fi
				    else
					    bash ./Source/View/room.sh 
				    fi
			    elif [[ $x == 42 ]]; then       # 특정라인의 방삭제를 입력했을 경우
				    n=`expr $line - 7`
				    if [[ ${username} == `sed -n ${n}p ./Data/Room/Roomlist.txt | cut -d ":" -f 3` ]]; then
					    `sed -i ${n}d ./Data/Room/Roomlist.txt` # 해당 채팅방 만든 사람만 삭제 가능
				    else 
					    echo "access denied"        # 해당 채팅방 만든 사람아니면 삭제 불가
				    sleep 2
				    fi
				  fi
		    fi
		    break
    fi
    
# 방향키 위, 아래, 왼쪽, 오른쪽 움직임 알고리즘
	    if [[ $input = [A ]];         # 위
	    then
		    tput cup $line $x; echo "  "
		    line=`expr $line - 1`       # 아래
	    elif [[ $input = [B ]];
	    then
		    tput cup $line $x; echo "  "
		    line=`expr $line + 1`
		    if [[ $line -lt 8 ]]; 
	    then
			    line=8
		    fi
	    elif [[ $input = [D ]];       # 왼쪽
		    then
		    tput cup $line $x; echo "  "
			    x=7
	    elif [[ $input = [C ]];       # 오른쪽
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


