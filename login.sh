#! /bin/bash

declare -a arr
declare -i num
PS3="Input number(1-3): "

SignIn() {
    checkID
    checkPassword
}
checkID() {
    echo -n "Username: "
    read username
    declare -i exist=0
    while read line; do
        if [ "${username}" = "`echo $line | cut -d ":" -f 1`" ]; then
            echo "--if in--"
		    exist=1
            break
        fi
    done < userID.txt

    if [ $exist -eq 0 ]; then
        echo "Invalid ID"
	    checkID
    fi
}
checkPassword(){
    echo -n "Password: "
    read -s password
    echo -e "\n"
    if [ "${password}" = "`grep $username userID.txt | cut -d ":" -f 2`" ]; then
        echo "success"
		./chatroom_list.sh ${username}
    exit
    else
        echo "fail"
    fi
}


SignUp() {
    echo -n "Your username? : "
    read username
    arr[0]=${username}
    echo -n "Your password? : "
    read -s password
    arr[1]=${password}
    echo "${username}:${password}" >> userID.txt
    echo -e "\n"
}

echo "MAIN MENU"
select ch in "sign in" "sign up" "exit"
do
case "${ch}" in
"sign in") echo "sign in"
SignIn ;;
"sign up") echo "sign up"
SignUp ;;
"exit") echo "quit"
break ;;
*) echo "[31mInvalid[0m"
echo -ne "MAIN MENU\n1) sign in\n2) sign up\n3) exit\n" ;;
esac
done
