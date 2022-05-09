#!/bin/bash

updateUI(){
    clear
    echo "<<Update UI>>"
    cat chatLog1.txt

}

sendMessage(){
    clear
    updateUI
    echo " <<Send Message>> " 
    read -p "Input Message: " msg

}
deleteMessage(){
    clear
    updateUI
    echo " <<delete Message>> "

}
findMessage(){
    clear
    updateUI
    echo " <<Find Messeage>> "

}
exitRoom(){
    clear
    updateUI
    echo " <<Exit Room>> "

}
errorMode(){
    clear
    updateUI
    echo "not valid mode"

}

selectMode() {

    #1 = send
    #2 = delete
    #3 = find 
    #4 = exit
    
    select opt in "Send" "Delete" "Find" "Exit"
    do
    case ${opt} in
    "Send") sendMessage break;;
    "Delete") deleteMessage break;;
    "Find") findMessage break;;
    "Exit") exitRoom break;;
    *) errorMode break;;
    esac
    done
}

room1(){
    while [ true ] 
    do
        echo " << Room1 >> "
        updateUI
        selectMode 
    done
}

#code start point 

room1


