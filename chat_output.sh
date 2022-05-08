#!/bin/bash

time=`date +%T`
while read line || [ -n "$line" ];
do
  echo $time
  echo "$line" | cut -d ':' -f 1,2
done < userID.txt
