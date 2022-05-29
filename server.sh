#! /bin/bash

ip=$1
port=$2
#not actual var
roomNum=1

requestOp() {

	# 입력은 [ ip port 수행명령 전달대상 ] 의 형식으로 설정

	read input <<< `timeout 2s nc -l 1234`
	ip=`echo ${input} | cut -d ' ' -f 1`
	port=`echo ${input} | cut -d ' ' -f 2`
	opt=`echo ${input} | cut -d ' ' -f 3`
	pas=`echo ${input} | cut -d ' ' -f 4`

}


while [ true ]
do
	requestOp
	if [ "${opt}" = "Send" ];
	then
		${msg} >> chatLog${roomNum}.txt
	elif [ "${opt}" = "Delete" ];
	then
		export opt="Delete"
	elif [ "${opt}" = "Exit" ]
	then
		break
	else
		nc -w2 -N ${ip} ${port} < chatLog${roomNum}.txt
	fi
done

