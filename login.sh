#! /bin/bash

declare -a arr
declare -i num
PS3="Input number(1-3): "

echo "MAIN MENU"
select ch in "sign in" "sign up" "exit"
do
case "${ch}" in
"sign in") echo "sign in"
break ;;
"sign up") echo "sign up"
break ;;
"exit") echo "quit"
break ;;
*) echo "[31mInvalid[0m" ;;
esac
done
