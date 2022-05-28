#! /bin/bash

:<< EX
nc를 통해 클라이언트 에게서 신호를 받으면 그 신호를 토대로 명령을 수행, 받은 신호는 inopt.txt에 추가하며 수행이 완료된 명령은 "executed"로 치환되어서 수행하였음을 표시
입력을 한 번밖에 받지 않는 문제가 있음. 해결 시급
EX

ip=$1
#not actual var
port=$2
roomNum=1

nc -lkd 1234 >> inopt.txt &
nc -lkd 1400 >> inopt.txt &

while true
do
	input=`tail -n 1 inopt.txt 2>/dev/null`
	if [ "${input}" = "\"executed\"" -o -z "${input}" ];
	then
		echo "Idle state"
	else
		sed '$s/.*/"executed"/' -i inopt.txt
		echo "${input}"
	fi
	sleep 0.4
	echo $RANDOM
done

requestOp() {

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
		nc -w4 -N ${ip} ${port} < chatLog${roomNum}.txt
	fi
done

