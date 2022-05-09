#! /bin/bash

PS3='Enter the number of the chat room you want? : '


select chat_num in "chatroom1" "chatroom2" "chatroom3" "chatroom4"
do
    if [ ${chat_num}=="chatroom1" ] ; then
	    echo "welcome to ${chat_num}"

	    else echo "Test"
    fi
done
