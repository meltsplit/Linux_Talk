#! /bin/bash

username=$1

RoomListView() {
    clear

    PS3="choose a room for chatting: "
    select chat_num in "room1" "room2" "room3" "room4" "Exit"
    do
	    case ${chat_num} in
		    "room1") bash room1.sh ${username};; #화면 전환
		    "room2") echo "need script";;
		    "room3") echo "need script";;
		    "room4") echo "need script";;
			"Exit") break;;
	    esac
	done
}

RoomListView

