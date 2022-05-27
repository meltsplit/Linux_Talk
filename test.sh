#! /bin/bash

read -p "msg: " msg
ip=`ifconfig | grep -A 1 -E "wifi0" | grep "inet" | tr -s ' ' | cut -d ' ' -f 3`
echo ${msg} | nc -q 0 ${ip} 1234
echo "Msg sent"
