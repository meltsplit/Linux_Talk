#! /bin/bash

ip=$1
#not actual var
port=$2
switch=1
rnum=1

requestOp() {

	ior=`nc -l 1234`
	ip=`echo ${ior} | cut -d ' ' -f 1`
	port=`echo ${ior} | cut -d ' ' -f 2`
	opt=`echo ${ior} | cut -d ' ' -f 3`
	pas=`echo ${ior} | cut -d ' ' -f 4`


}

while [ "${switch}" = 1 ]
do
	if [ "${ior}" = 1 ];
	then
		${msg} >> chatLog${rnum}.txt
done
