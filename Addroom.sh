#! /bin/bash


input_key(){
    read -s -n 3 INPUT
    echo $INPUT
}

Add_room(){
    cat defaultView.txt

    line=10
    column=6
while [ true ]
do
    tput cup 8 14; echo "Room Type"
    tput cup 10 8; echo "[private]   [open]      [exit]"
    tput cup $line $column; echo "->"

    input=$(input_key)

    if [[ -z $input ]]; then
	    clear
	    if [[ $column == 6 ]]; then
		    tput cup 10 14; echo "Type : private talk       "
		    private
	    elif [[ $column == 18 ]]; then
		    tput cup 10 14; echo "Type : open talk          "
		    open
	    elif [[ $column == 30 ]]; then
		    tput cup 10 14; echo "Type : Exit            "
	    fi
	    break
    fi
#8,20,32
    if [[ $input = [D ]]; then
	    column=`expr $column - 12`
    elif [[ $input = [C ]]; then
	    column=`expr $column + 12`
    fi

    if [[ $column -le 6 ]]; then
	    column=6
		elif [[ $column -gt 30 ]]; then
	    column=30
    fi
    clear
    tput cup 0 0; cat Addroom.txt

done
}

open(){

    tput cup 8 14; echo -n "room name: "
    read -n 13 openroom

    echo "|           [open] $openroom;  [delete]  |" >> listroom.txt

    tput cup 10 14; echo "Add $openroom Room success!"
    sleep 2
    
}

private(){

    tput cup 8 14; echo -n "room name: "
    read -n 13 privateroom
    echo -n "enter passwd: "
    read privateroom_p

    echo "|           [private] $privateroom;$privateroom_p" >> listroom.txt

    tput cup 12 14; echo "Add $privateroom Room success!"
    sleep 2

    
}

clear
Add_room
