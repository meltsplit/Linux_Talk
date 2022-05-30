#! /bin/bash

input_key() {
    read -s -n 3 INPUT
    echo $INPUT
}

SignUpView() {
    clear
    cat defaultView.txt
	    tput cnorm
	    tput cup 5 10; echo -n "Your username? : "
	    read username  #글자수 제한하고 싶은데 -n 옵션하면 백스페이스 키가 안먹는다?

	    if [[ ${#username} -ge 25 ]]; then
		    tput cup 6 10; echo "error: maximum ID name : 25"
		    tput cup 8 10; echo "Re - Enter please"
		    sleep 4
		    exit
	    
	    else
	    existing_id=`cat userID.txt | cut -d ";" -f 1 | grep -w "$username"`

		    while [ "$username" = "$existing_id" ]
			    do
				    tput cup 5 10; echo "   ** ID already exists **         "
				    sleep 2
				    tput cup 5 10; echo -n "Please enter another ID : "
				    read username
				    existing_id=`cat userID.txt | cut -d ";" -f 1 | grep -w "$username"`
			    done

    tput cup 7 10; echo -n "Your password? : "
    read -s password

    tput cup 10 15; echo "*-----------------------*"
    tput cup 11 15; echo "|                       |"
    tput cup 12 15; echo "|    confirm the ID?    |"
    tput cup 13 15; echo "|                       |"
    tput cup 14 15; echo "|      yes     no       |"
    tput cup 15 15; echo "*-----------------------*"
    line=14
    x=20
while [ true ]
do
    tput cup $line $x; echo "->"
    tput civis
    input=$(input_key)

    if [[ -z $input ]]; then
	    if [[ $x = 20 ]]; then
		    echo "${username};${password}" >> userID.txt
		    echo -e "\n"
		    SignUp_success
		    break
	    elif [[ $x = 28 ]]; then
		    break
	    fi
    fi

    if [[ $input = [C ]]; then
	    x=28
	    tput cup $line 20; echo "  "
    elif [[ $input = [D ]]; then
	    x=20
	    tput cup $line 28; echo "  "
    fi
done
fi
}


SignUp_success() {
    clear
    cat defaultView.txt
    tput cup 5 17; echo "*----------------------*"
    tput cup 6 17; echo "|                      |"
    tput cup 7 17; echo "|   Sign Up success!   |"
    tput cup 8 17; echo "|                      |"
    tput cup 9 17; echo "*----------------------*"
    sleep 2

}


SignUpView
tput cnorm
