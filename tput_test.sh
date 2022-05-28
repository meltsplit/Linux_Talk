#! /bin/bash

Room_View(){
tput cup 0 0
clear
echo "----------------------------------------------------------" #60
echo "|                                                        |"
echo "|                                                        |"
echo "|                                                        |"
echo "|                                                        |"
echo "|         [Find]         [Delete]          [Exit]        |"
echo "|                                                        |"
echo "|                                                        |"
echo "|                                                        |"
echo "|                                                        |"
echo "----------------------------------------------------------"
}

Room_View
x=15
y=5

while :
do  
	tput cup $y $x
	tput cnorm
	read -sn 3 INPUT
	if [ "${INPUT}" = "[A" ]; then  #up
		continue
	elif [ "${INPUT}" = "[B" ]; then #down
		continue 
	elif [ "${INPUT}" = "[C" ]; then # right
		if [ $x -ge 45 ]; then
		continue
		else
			x=`expr $x + 15`
		fi
	elif [ "${INPUT}" = "[D" ]; then #left
		if [ $x -le 15 ]; then
		continue
		else
			x=`expr $x - 15`
		fi
	else
		if [ $x -eq 15 -a $y -eq 5 ]; then
			clear 
			echo "Find"
		elif [ $x -eq 30 -a $y -eq 5 ]; then
			clear
			echo "Delete"	
		elif [ $x -eq 45 -a $y -eq 5 ]; then
		clear
		echo "Quit"	
		fi
	
	fi
done

 

