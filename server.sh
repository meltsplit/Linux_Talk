#! /bin/bash

#nc 명령어 2회 실행을 통해 한 번의 전송을 수행합니다. 그에 따라 클라이언트에서도
#nc -l 1234; nc -l 1234 > chatLog1.txt와 같은 식으로 코드를 작성해야 연속적인 동작이 가능합니다.

declare -a iparr

#not actual var

transmitT() {

	timeout 1s nc -l 1234 # 수신 가능 상태 전달용 nc -z 수신
	timeout 1s nc -l 1234 > rtext.txt
	if [ ! -z "$(cat rtext.txt)" ]; #원래는 -n을 사용하려 했으나 작동 X
	then
		cat rtext.txt > chatLog.txt
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
	timeout 1s nc -z ${ip} ${port} #전송 대상 포트 개방 확인
	nc -q 0 ${ip} ${port} < chatLog${roomNum}.txt #파일 전송
	done
done

