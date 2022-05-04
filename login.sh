#! /bin/bash

declare -a arr
declare -i num
PS3="Input number(1-3): "

SignIn() {
    echo -n "Username: "
    read username
    arr[0]=${username}
    echo -n "Password: "
    read -s password
    echo -e "\n"
    arr[1]=${password}
    if [ "${username} ${password}" = "`grep ${username} userID.txt`" ];
    then
        echo "login success"
    else
        echo "login failed"
    fi
}


SignUp() {
    echo -n "Your username? : "
    read username
    arr[0]=${username}
    echo -n "Your password? : "
    read -s password
    arr[1]=${password}
    echo "${username} ${password}" >> userID.txt
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
