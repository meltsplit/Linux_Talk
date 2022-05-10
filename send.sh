#! /bin/bash

username=$1

echo "[32m$(date "+%m-%d %l:%M %^p") ; [34m${username} [0m ; ${msg_s}"
echo "[32m$(date "+%m-%d%l:%M %^p") ; [34m${username} [0m ; ${msg_s}" >> chatLog1.txt
