#! /bin/bash


chatroom_select() {
    PS3='Enter the number of the chat room you want? : '
    select chat_num in "room1" "room2" "room3" "room4"
    do
	    case ${chat_num} in
		    "room1") sh ./room1.sh;;
		    "room2") echo "need script";;
		    "room3") echo "need script";;
		    "room4") echo "need script";;
	    esac
		done
}

chatroom_select
