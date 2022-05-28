declare exist="false"

IP=`ip route get 8.8.8.8 | cut -d ' ' -f 7`
PORT="$(($RANDOM% 1001+1111))"

LogIn() {
    while [ true ]
    do
    clear
    echo "[ Login View ]"
    echo -e "\n\n"
    echo -n "Username: "
    read username
    
    if [ "${username}" = "quit" ]; then
        break
    fi
    
    while read line; do
        if [ "${username}" == "`echo $line | cut -d ";" -f 1`" ]; then
		    exist="true" #ID가 존재
              	    break
        fi
    done < userID.txt

    if [ $exist == "true" ]; then
    	checkPassword 
	break
    else
    	echo -e "\n"
        echo "Invalid ID"
        sleep 1
    fi
    done
}
checkPassword(){

    echo -n "Password: "
    read -s password
    echo -e "\n"
    
    if [ "${password}" == "quit" ]; then
        break
    fi

    if [ "${password}" == "`grep $username userID.txt | cut -d ";" -f 2`" ]; then
        #Success
		bash RoomListView.sh ${IP} ${PORT} # 화면 전환 
    else 
    	sleep 1
    	echo ${password}
        echo "Wrong Password!!"
        sleep 1
    fi

}

SignInView(){
    LogIn
}

SignInView
