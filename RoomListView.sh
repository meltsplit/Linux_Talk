#! /bin/bash

RoomListView() {
	export roomNum=0
	
	while [ $roomNum != 4 ]
	do
	clear
        echo "[ Room List View ]"
	echo "1) Room1"
	echo "2) Room2"
	echo "3) Room3"
	echo "4) Exit"
	
	while [ true ]
	do
		read -p "Choose a room number: " roomNum
		if [ "${roomNum}" = "1" -o "${roomNum}" = "2" -o "${roomNum}" = "3" -o "${roomNum}" = "4" ]; then
			break
		fi
	done
	
	if [ "${roomNum}" = "4" ]; then
		break
	else
		bash room.sh  #RoomListView -> RoomView
	fi

	done

}

RoomListView


