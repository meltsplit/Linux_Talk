#! /bin/bash

# ip route get 8.8.8.8 | cut -d ' ' -f 7`로 하면 "wifi0" 같은 네트워크 인터페이스없이 ip만 뽑아올 수 있음.
read -p "msg: " msg
ip=`ifconfig | grep -A 1 -E "wifi0" | grep "inet" | tr -s ' ' | cut -d ' ' -f 3`
echo ${msg} | nc -q 0 ${ip} 1234
echo "Msg sent"
