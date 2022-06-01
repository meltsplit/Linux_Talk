#! /bin/bash

export username="default name"

ssh -p 1234 test@111.111.111.111
ssh-keygen -t rsa -C "rsa Key" < input_key.txt
ssh-copy-id id_rsa.pub -p 1234 test@111.111.111.111

tutorial(){
tput cup 0 0

while :
do
clear
echo "*-----------------------------------------------------------*" #0
echo "|                                                           |"
echo "|                                                           |"
echo "|                                                           |" #3
echo "|                                                           |"
echo "|                     Use Full Screen!                      |"
echo "|                                                           |"
echo "|                                                           |"
echo "|             You should resize console screen              |"
echo "|                to show this box correctly                 |"
echo "|                                                           |"
echo "|                                                           |"
echo "|                                                           |"
echo "|                   If you confirm this                     |"
echo "|                                                           |"
echo "|                      press [Enter]                        |"
echo "|                                                           |"
echo "|                                                           |"
echo "|                                                           |"
echo "|                                                           |"
echo "|                                                           |"
echo "|                                                           |"
echo "|                                                           |"
echo "|                                                           |"
echo "|                                                           |"
echo "|                                                           |"
echo "|                                                           |"
echo "|                                                           |"
echo "|                                                           |"
echo "|                                                           |"
echo "*-----------------------------------------------------------*"
input=$(input_key)
if [[ -z $input ]]; then
	break
fi
done

}

input_key() {
    read -s -n 3 INPUT
    echo $INPUT

}

items() {
    if [ $1 = $2 ];
    then
	    echo -e "|\t\t     \033[01;43m${items[i]}\033[0m    \t\t|"
	    echo -e "|\t\t\t  \t\t\t|"
	    echo -e "|\t\t\t  \t\t\t|"
    else
	    echo -e "|\t\t     \033[01m${items[i]}\033[0m       \t\t|"
	    echo -e "|\t\t\t  \t\t\t|"
	    echo -e "|\t\t\t  \t\t\t|"
    fi
}
main_view() {

    SELECTED=1

    while [ True ]
    clear
    do
	    echo -e "*-----------------------------------------------*"
	    echo -e "|\t\t   <Main View>   \t\t|"
	    echo -e "|\t\t\t  \t\t\t|"
	    echo -e "|\t\t\t  \t\t\t|"
	    echo -e "|\t\t\t  \t\t\t|"
	    echo -e "|\t\t\t  \t\t\t|"

	    for (( i=1 ; i<=3 ; i++ ))
	    do
		    items "$i" "$SELECTED"
	    done
	    echo -e "|\t\t\t  \t\t\t|"
	    echo -e "*-----------------------------------------------*"


	    input=$(input_key)

	    if [[ -z $input ]];
	    then
		    echo "select: ${items[$SELECTED]}"
		    break
	    fi
	    if [[ $input = [A ]];
	    then
		    SELECTED=`expr $SELECTED - 1`
	    elif [[ $input = [B ]];
	    then
		    SELECTED=`expr $SELECTED + 1`
	    fi

	    if [[ $SELECTED -lt 1 ]];
	    then SELECTED=1
	    elif [[ $SELECTED -gt 3 ]];
	    then SELECTED=3
	    fi

    done
}


selected_item(){
    	case ${items[$SELECTED]} in
	    "1.sign in") bash ./Source/View/SignInView.sh ;; #화면 전환
	    "2.sign up") bash ./Source/View/SignUpView.sh ;; #화면 전환
	    "3.exit   ") ;;
	    *) errorMode break;;
	esac
}

main(){
	tutorial
    timedatectl set-timezone Asia/Seoul	
    items=("test" "1.sign in" "2.sign up" "3.exit   ")
	    SELECTED=0
	    while [ "${items[$SELECTED]}" != "3.exit   " ]
		    do
		    tput civis
		    main_view "${items[@]}"
		    selected_item
		
		    done

	echo "<<Program End>>"
}

tput civis
main
