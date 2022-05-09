#! /bin/bash

username=$1

echo "[32m$(date "+%m-%d%l:%M %^p") ; [34m${username} [0m ; ${msg}"
echo "[32m$(date "+%m-%d%l:%M %^p") ; [34m${username} [0m ; ${msg}" >> chatLog1.txt