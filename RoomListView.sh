#! /bin/bash

IP=$1
PORT=$2

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
<<<<<<< HEAD
		bash Room.sh ${IP} ${PORT} #RoomListView -> RoomView
=======
		bash room.sh  #RoomListView -> RoomView
>>>>>>> df64381b4a9f296ab023e8f51ade58176c3b8926
	fi

	done

}

RoomListView


