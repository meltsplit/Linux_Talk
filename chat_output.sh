#!/bin/bash

time=`date +%T`
while read line || [ -n "$line" ];
do
  echo "$line" | cut -d ':' -f 1,2
  echo $time
done < userID.txt
