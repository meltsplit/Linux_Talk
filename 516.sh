#! /bin/bash


export username="default name"

input_key() {
    read -s -n 3 INPUT

    if [[ ${INPUT} = [A ]]; 
    then
	    echo $INPUT
    elif [[ ${INPUT} = [B ]]; 
    then
	    echo $INPUT
    elif [[ ${INPUT} = "" ]];
    then
	    echo $INPUT
    fi

}

selected_item() {
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
		    selected_item "$i" "$SELECTED"
	    done
	    echo -e "|\t\t\t  \t\t\t|"
	    echo -e "*-----------------------------------------------*"

	    
	    input=$(input_key)
	    
	    if [ -z $input ];
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

items=("test" "1.sign in" "2.sign up" "3.exit   ")
main_view "${items[@]}"

selected_items(){
    case ${items[$SELECTED]} in
	    "1.sign in") bash SignInView.sh ;; #화면 전환
	    "2.sign up") bash SignUpView.sh ;; #화면 전환
	    "3.exit   ") ;;
	    *) errorMode break;;
esac
}

main(){
    mainView
    selected_items
    echo "<<Program End>>"
}

main
