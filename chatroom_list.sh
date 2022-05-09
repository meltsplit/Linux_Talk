#! /bin/bash


chatroom_select() {
    PS3='Enter the number of the chat room you want? : '
    select chat_num in "chatroom1" "chatroom2" "chatroom3" "chatroom4"
    do
	    break;
    done
    
    if [ "${chat_num}" == "chatroom1" ] ; then
	    echo "welcome to chatroom1"
	    sh ./send.sh

    else echo "Test"
    fi
}

chatroom_select
