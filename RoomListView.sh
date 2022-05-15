#! /bin/bash




RoomListView() {
	opt_R=0
	while [ $opt_R != 4 ]
	do
	clear
        echo "[ Room List View ]"
	echo "1) Room1"
	echo "2) Room2"
	echo "3) Room3"
	echo "4) Exit"
	while [ true ]
	do
		read -p "Choose a room number: " opt_R
		if [ ${opt_R} == 1 -o ${opt_R} == 2 -o ${opt_R} == 3 -o ${opt_R} == 4 ]; then
			break
		fi
	done
	export opt_R	
	case ${opt_R} in
		"1") bash Room.sh ${username} ${opt_R} ;; #화면 전환
		"2") bash Room.sh ${username} ${opt_R} ;; 
		"3") bash Room.sh ${username} ${opt_R} ;; 
		"4") break;; # RoomListView -> SignInView
	esac

	done

}

RoomListView


