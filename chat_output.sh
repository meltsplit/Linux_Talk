#!/bin/bash

# 시간 출력하는 변수(날짜추가)
time=`date +%D,%H:%M`

while read line || [ -n "$line" ];
do
  echo "$line" | cut -d ';' -f 1-3
  echo $time
done < userID.txt

# 일단 시간은 그냥 받아오면 돼서 저렇게 추가안해도 되지만
# 그냥 작성해봄
