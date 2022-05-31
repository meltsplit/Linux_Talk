#! /bin/bash

#nc -l 1234; nc -l 1234 > chatLog1.txt와 같은 식으로 코드를 작성해야 연속적인 동작이 가능합니다.

declare -a iparr
nc -lk 1234 > rtext.txt &
nc -lk 2222 > rtext.txt &

port1=1234
port2=2222

#not actual var

transmitT() {
	sed -i 's/\x0//g' rtext.txt
	if [ ! -z "$(echo $(cat rtext.txt))" ]; #원래는 -n을 사용하려 했으나 작동 X
	then
		cat rtext.txt > chatLog.txt
		cat /dev/null > rtext.txt
	fi
}

ipGet() {

	tarr=($(echo $(cut -d ';' -f 4 chatLog.txt))) #echo의 개행을 whitespace로 변환하는 특성을 이용하여서 배열 생성
	iparr=($(echo "${tarr[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))

}

while [ true ]
do
	transmitT
	ipGet
	for ip in "${iparr[@]}"
	do
#	timeout 1s nc -z ${ip} ${port} #전송 대상 포트 개방 확인
	timeout 1s nc ${ip} ${port1} < chatLog.txt #파일 전송
	timeout 1s nc ${ip} ${port2} < chatLog.txt #파일 전송
	done
done

