#! /bin/bash

username=$1

chatroom_select() {
    clear
    PS3="choose a room for chatting: "
    select chat_num in "room1" "room2" "room3" "room4"
    do
	    case ${chat_num} in
		    "room1") bash room1.sh ${username};;
		    "room2") echo "need script";;
		    "room3") echo "need script";;
		    "room4") echo "need script";;
	    esac
		break;
		done
		chatroom_select
}

chatroom_select

