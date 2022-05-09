#! /bin/bash


echo ${username}
echo "presse enter if you want to send message, quit:q\n"
read message

while [ "$message" != "q" ];
do

    echo "[32m$(date "+%m-%d%l:%M %^p") ; [34m${username} [0m ; ${message}"
    echo "$(date "+%m-%d%l:%M %^p");${username};${message}" >> chatLog1.txt
    read message
done
/bin/bash `pwd`/chatroom_list.sh
