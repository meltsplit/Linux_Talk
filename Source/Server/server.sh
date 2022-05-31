#! /bin/bash

#nc -l 1234; nc -l 1234 > chatLog1.txt와 같은 식으로 코드를 작성해야 연속적인 동작이 가능합니다.

declare -a iparr
nc -lk 1234 > ./Source/Server/rtext.txt &
port=1234

#not actual var

transmitT() {

	if [ ! -z "$(echo $(cat ./Source/Server/rtext.txt))" ]; #원래는 -n을 사용하려 했으나 작동 X
	then
		cat ./Source/Server/rtext.txt > ./Source/Server/chatLog.txt
		cat /dev/null > ./Source/Server/rtext.txt
	fi
}

ipGet() {

	tarr=($(echo $(cut -d ';' -f 4 ./Source/Server/chatLog.txt))) #echo의 개행을 whitespace로 변환하는 특성을 이용하여서 배열 생성
	iparr=($(echo "${tarr[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))

}

while [ true ]
do
	transmitT
	ipGet
	for ip in "${iparr[@]}"
	do
#	timeout 1s nc -z ${ip} ${port} #전송 대상 포트 개방 확인
	timeout 1s nc ${ip} ${port} < ./Source/Server/chatLog.txt #파일 전송
	done
done

