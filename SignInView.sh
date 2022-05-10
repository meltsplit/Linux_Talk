declare -i exist=0

Login() {
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
        if [ "${username}" = "`echo $line | cut -d ":" -f 1`" ]; then
		    exist=1 #ID가 존재
            checkPassword   
        fi
    done < userID.txt

    if [ $exist -eq 0 ]; then
        echo "Invalid ID"
    fi
    done
}
checkPassword(){
    while [ true ]
    do
    echo -n "Password: "
    read -s password
    echo -e "\n"
    
    if [ "${password}" = "quit" ]; then
        break
    fi

    if [ "${password}" = "`grep $username userID.txt | cut -d ";" -f 2`" ]; then
        #Success
		bash RoomListView.sh ${username} # 화면 전환 
    else 
        echo "Wrong Password!!"
    fi
    done
}

SignInView(){
    Login
}

SignInView