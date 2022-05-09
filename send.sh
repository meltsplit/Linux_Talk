#! /bin/bash
:<<"END"
./send.sh {사용자 이름} {채팅 내용} {현재 채팅방} 같은 형식으로 두 개의 인자를 받아서 처리하는
스크립트입니다.
다른 스크립트에서 인자를 받아오게 하면 될 것 같습니다.
e.g. ./send.sh ${username} ${message} ${dest}
END

source ./login.sh
echo username

username=$1
message=$2
dest=$3

echo "${username} [32m$(date "+%m-%d-%l:%M %^p")[0m : ${message}" >> ${dest}
