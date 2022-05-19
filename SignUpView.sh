#! /bin/bash

SignUpView() {
    clear
    echo -n "Your username? : "
    read username

    echo -n "Your password? : "
    read -s password

    echo "${username};${password}" >> userID.txt
    echo -e "\n"

}


SignUpView
./ChattingProgram.sh
