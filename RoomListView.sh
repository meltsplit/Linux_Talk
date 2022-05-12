#! /bin/bash

username=$1

RoomListView() {
	opt=0
	while [ $opt != 4 ]
	do
	clear
        echo "[ Room List View ]"
	echo "1) Room1"
	echo "2) Room2"
	echo "3) Room3"
	echo "4) Exit"
	while [ true ]
	do
		read -p "Choose a room number: " opt
		if [ ${opt} == 1 -o ${opt} == 2 -o ${opt} == 3 -o ${opt} == 4 ]; then
			break
		fi
	done
	
	case ${opt} in
		"1") bash Room.sh ${username} ;; #화면 전환
		"2") bash ${username} ;; 
		"3") bash ${username} ;; 
		"4") break;; # RoomListView -> SignInView
	esac

	done

}

RoomListView


