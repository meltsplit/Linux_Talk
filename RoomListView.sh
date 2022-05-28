#! /bin/bash

ip=$1

RoomListView() {
	export opt_R=0
	
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
		if [ "${opt_R}" = "1" -o "${opt_R}" = "2" -o "${opt_R}" = "3" -o "${opt_R}" = "4" ]; then
			break
		fi
	done
	
	if [ "${opt_R}" = "4" ]; then
		break
	else
		bash Room.sh ${ip}  #RoomListView -> RoomView
	fi

	done

}

RoomListView


