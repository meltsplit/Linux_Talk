#! /bin/bash

declare -a arr
declare -i num
export username="default name"



mainView(){
    	opt=0
	while [ $opt != 3 ]
	do
	clear
    	echo "[ Main View ]"
	echo "1) Sign In"
	echo "2) Sign up"
	echo "3) Exit"
	while [ true ]
	do
		read -p "Choose menu(1-3): " opt
		if [ ${opt} == 1 -o ${opt} == 2 -o ${opt} == 3 ]; then
			break
		fi
	done
	
	case ${opt} in
	"1") bash SignInView.sh ;; #화면 전환
	"2") bash SignUpView.sh ;; #화면 전환
	"3") ;;
	*) errorMode break;;
	esac

	done
}

main(){
    mainView
    echo "<<Program End>>"
}

#code start point
main
