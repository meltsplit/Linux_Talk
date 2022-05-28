#! /bin/bash

export ip=ip route get 8.8.8.8 | cut -d ' ' -f 7

SignUpView() {
    clear
	    
	    echo -n "Your username? : "
	    read username
	    
	    existing_id=`cat userID.txt | cut -d ";" -f 1 | grep -w "$username"`

		    while [ "$username" = "$existing_id" ]
			    do
				    echo "ID already exists"
				    sleep 2
				    clear
				    read -p "Please enter another ID : " username 
				    existing_id=`cat userID.txt | cut -d ";" -f 1 | grep -w "$username"`


			    done

    echo -n "Your password? : "
    read -s password

    echo "${username};${password}" >> userID.txt
    echo -e "\n"

}


SignUp_success() {
    clear

    echo "Sign Up success!"
    sleep 2

}
SignUpView
SignUp_success
