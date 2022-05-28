#!/bin/bash

#-----------------------------------------------------
# Project 1

# TITLE
TITLE() {
tput civis
tput setab 6
tput setaf 0
tput cup 0 0
echo "File Explorer                                                     2015405060_OSC"
}

# UI
UI() {
tput sivis
tput setab 7
tput cup 1 0
echo "--------------------------------------------------------------------------------"
tput cup 2 0
echo "|                                                                              |"
tput cup 3 0
echo "--------------------------------------------------------------------------------"

for (( i = 4; i<29; i++ ))
do
    tput cup $i 0
    echo "|                                      |                                       |"
done

tput cup 29 0
echo "--------------------------------------------------------------------------------"
tput cup 30 0
echo "|                                                                              |"
tput cup 31 0
echo "--------------------------------------------------------------------------------"
}

# 현재 경로 출력
show_pwd() {
tput setaf 5
tput cup 2 1
echo "Current path: `pwd`"

}

#현재 경로의 파일 출력
file_show() {

        ls_lahs=($(ls -lahs))          # ls -lahs 명령어를 배열에 초기화
        ls_lahs[2]="-"
        ls_lahs[12]="-"
        l=4                            #입력할 행의 위치

        #디렉토리 출력
        for(( i=3; i<203; i+=10 ))
        do
                if [ "${ls_lahs[$i]:0:1}" = "d" ]; then
                    tput setaf 4
                    tput cup $l 1
                    echo ${ls_lahs[$i+8]}
                    tput cup $l 18
                    echo ${ls_lahs[$i]}
                    tput cup $l 33
                    echo ${ls_lahs[$i - 1]}
                    ls_home[$l]=$l
                    ls_home[$l+20]=${ls_lahs[$i+8]}
                    ls_home[$l+40]=${ls_lahs[$i]}
                    ls_home[$l+60]=${ls_lahs[$i - 1]}

                    l=`expr $l + 1`
                fi
        done
        #실행파일 출력
        for (( i=3; i<203; i+=10 ))
        do
                if [ "${ls_lahs[$i]:0:1}" = "-" -a "${ls_lahs[$i]:3:1}" = "x" ]; then
                    tput cup $l 1
                    tput setaf 2
                    echo ${ls_lahs[$i+8]}
                    tput cup $l 18
                    echo ${ls_lahs[$i]}
                    tput cup $l 33
                    echo ${ls_lahs[$i - 1]}
                    ls_home[$l]=$l
                    ls_home[$l+20]=${ls_lahs[$i+8]}
                    ls_home[$l+40]=${ls_lahs[$i]}
                    ls_home[$l+60]=${ls_lahs[$i - 1]}

                    l=`expr $l + 1`
                fi
        done
        #일반파일 출력
        for (( i=3; i<203; i+=10 ))
        do
                if [ "${ls_lahs[$i]:0:1}" = "-" -a "${ls_lahs[$i]:3:1}" = "-" ]; then
                    tput cup $l 1
                    tput setaf 0
                    echo ${ls_lahs[$i+8]}
                    tput cup $l 18
                    echo ${ls_lahs[$i]}
                    tput cup $l 33
                    echo ${ls_lahs[$i - 1]}
                    ls_home[$l]=$l
                    ls_home[$l+20]=${ls_lahs[$i+8]}
                    ls_home[$l+40]=${ls_lahs[$i]}
                    ls_home[$l+60]=${ls_lahs[$i - 1]}

                    l=`expr $l + 1`
                fi
        done
}

# 디렉토리 파일 수 출력, 총 용량 출력
dfc_show() {
        tput setaf 0
        tput cup 30 6
        echo "Directory : `ls -l | grep ^d | wc -l`  File : `ls -l | grep ^- | wc -l`      Current Directory Size : `du -sh 2>/dev/null |cut -d$'\t' -f 1`" 
}

cursor(){
#방향키,커서,엔터 구현
w=4
h=40
xlim=`expr $lim * 4`

while :
do
        lim=`expr $l - 2`

         tput sgr0
         Clear
         tput civis
         TITLE
         UI
         show_pwd
         file_show
         dfc_show

        tput cup $w 1

        for (( i=4; i<25; i++ ))
        do
        if [ ${ls_home[$i]} == $w ]; then
         if [ "${ls_home[$i+40]:0:1}" = "d" ]; then
         tput setab 4
         echo "                                      "
         tput setaf 7
         tput cup $w 1
         echo ${ls_home[$i+20]}
         tput cup $w 18
         echo ${ls_home[$i+40]}
         tput cup $w 33
         echo ${ls_home[$i+60]}
         tput setaf 0
         break
         elif [ "${ls_home[$i+40]:0:1}" = "-" -a "${ls_home[$i+40]:3:1}" = "x" ]; then
         tput setab 2
         echo "                                      "
         tput setaf 7
         tput cup $w 1
         echo ${ls_home[$i+20]}
         tput cup $w 18
         echo ${ls_home[$i+40]}
         tput cup $w 33
         echo ${ls_home[$i+60]}
         tput setaf 0
         break
         elif [ "${ls_home[$i+40]:0:1}" = "-" -a "${ls_home[$i+40]:3:1}" = "-" ]; then
         tput setab 0
         echo "                                      "
         tput setaf 7
         tput cup $w 1
         echo ${ls_home[$i+20]}
         tput cup $w 18
         echo ${ls_home[$i+40]}
         tput cup $w 33
         echo ${ls_home[$i+60]}
         tput setaf 0
         break
         fi
         fi
         done

        read -sn 3 key

        if [ "$key" = "[A" ]; then
           if [ $w -lt 5 ]; then
              continue
           else
              w=`expr $w - 1`
           fi


        elif [ "$key" = "[B"  ]; then
           if [ $w -gt $lim ]; then
              continue
           else
              w=`expr $w + 1`
           fi

        elif [ "$key" = "[C" ]; then
                continue
        elif [ "$key" = "[D" ]; then
                continue;

        else
              for (( i=4; i<24; i++ ))
               do
               if [ "${ls_home[$i]}" == "$w" ];then
                if [ "${ls_home[$i+40]:0:1}" = "d" ]; then
                 cd ${ls_home[$i+20]}
                 w=4
               else

        cp `pwd`/${ls_home[$i+20]} /tmp/osc
        tput sgr0
        Clear

        ImailCnt=`expr $ImailCnt + 1`
        SendedCnt=`expr $SendedCnt + 1`
        echo $ImailCnt > /tmp/osc/ImailCnt
        echo $SendedCnt > /tmp/osc/SendedCnt
#0 From
        echo "${ID_List[$UserNum]}" >> /tmp/osc/ImportMail
        echo "${ID_List[$UserNum]}" >> /tmp/osc/SendedArr
#1 To
        echo "${SendList[$MailNum]}" >> /tmp/osc/ImportMail
        echo "${SendList[$MailNum]}" >> /tmp/osc/SendedArr
#2 Title
        echo "$title" >> /tmp/osc/ImportMail
        echo "$title" >> /tmp/osc/SendedArr
#3 File O/X
        echo "O" >> /tmp/osc/ImportMail
        echo "I" >> /tmp/osc/SendedArr
#4 Time
        echo "`date '+%Y-%m-%d/%H:%M:%S'`" >> /tmp/osc/ImportMail
        echo "`date '+%Y-%m-%d/%H:%M:%S'`" >> /tmp/osc/SendedArr
#5 File Name
        echo "${ls_home[$i+20]}" >> /tmp/osc/ImportMail
        echo "${ls_home[$i+20]}" >> /tmp/osc/SendedArr

        ImportMail=(`cat /tmp/osc/ImportMail`)
        ImailCnt=`cat /tmp/osc/ImailCnt`
        SendedArr=(`cat /tmp/osc/SendedArr`)
        SendedCnt=`cat /tmp/osc/SendedCnt`

        unset content

        tput civis
        Main_UI
        Main_Select
        break
fi
               fi
              done
        fi
done
}



#------------------------------------------------
#Project 2

#리눅스 사용자들끼리 mail을 주고 받는 프로그램

Main()
{

mkdir /tmp/osc

chmod 777 /tmp/osc

touch /tmp/osc/User.txt
touch /tmp/osc/Password.txt
touch /tmp/osc/MailArr
touch /tmp/osc/ImportMail
touch /tmp/osc/mailCnt
touch /tmp/osc/ImailCnt
touch /tmp/osc/SendedArr
touch /tmp/osc/SendedCnt

chmod 777 /tmp/osc/User.txt
chmod 777 /tmp/osc/Password.txt
chmod 777 /tmp/osc/MailArr
chmod 777 /tmp/osc/ImportMail
chmod 777 /tmp/osc/mailCnt
chmod 777 /tmp/osc/ImailCnt
chmod 777 /tmp/osc/SendedArr
chmod 777 /tmp/osc/SendedCnt

Clear

count=-1
ImailCnt=-1
mailCnt=-1
SendedCnt=-1
readCnt=-1
SendedListCnt=-1
ID_List=()
Password_List=()
MailArr=()
ReadArr=()
ImportMail=()
SendedArr=()
SendedLis=()

ID_List=(`cat /tmp/osc/User.txt`)
Password_List=(`cat /tmp/osc/Password.txt`)
MailArr=(`cat /tmp/osc/MailArr`)
ImportMail=(`cat /tmp/osc/ImportMail`)
SendedArr=(`cat /tmp/osc/SendedArr`)
mailCnt=`cat /tmp/osc/mailCnt`
ImailCnt=`cat /tmp/osc/ImailCnt`
SendedCnt=`cat /tmp/osc/SendedCnt`

listcnt=`wc -l < /tmp/osc/User.txt`

count=`expr $listcnt - 1`

Start_UI
Start_Select
}

Save()
{
ID_List=(`cat /tmp/osc/User.txt`)
Password_List=(`cat /tmp/osc/Password.txt`)
MailArr=(`cat /tmp/osc/MailArr`)
ImportMail=(`cat /tmp/osc/ImportMail`)
SendedArr=(`cat /tmp/osc/SendedArr`)
mailCnt=`cat /tmp/osc/mailCnt`
ImailCnt=`cat /tmp/osc/ImailCnt`
SendedCnt=`cat /tmp/osc/SendedCnt`


listcnt=`wc -l < /tmp/osc/User.txt`

count=`expr $listcnt - 1`

}
#UI
Start_UI()
{
Save
    tput civis
    tput cup 0 0
echo "*--------------------------------------------*"
echo "|                  Mail Box                  |"
echo "|--------------------------------------------|"
echo "|                                            |"
echo "|--------------------------------------------|"
echo "|                                            |"
echo "|                   Sign in                  |"
echo "|                                            |"
echo "|                                            |"
echo "|                   Sign up                  |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "*--------------------------------------------*"

}

SignUp_UI()
{
Save
    tput cup 0 0i
echo "*--------------------------------------------*"
echo "|                  Mail Box                  |"
echo "|--------------------------------------------|"
echo "|                                            |"
echo "|--------------------------------------------|"
echo "|                                            |"
echo "| Input ID:                                  |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "*--------------------------------------------*"

}

SignIn_UI()
{
Save
    tput cup 0 0
echo "*--------------------------------------------*"
echo "|                  Mail Box                  |"
echo "|--------------------------------------------|"
echo "|                                            |"
echo "|--------------------------------------------|"
echo "|                                            |"
echo "| ID:                                        |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "*--------------------------------------------*"

}

Main_UI()
{
Save
    tput cup 0 0
echo "*--------------------------------------------*"
echo "|                  Mail Box                  |"
echo "|--------------------------------------------|"
echo "| user:                                      |"
echo "|--------------------------------------------|"
echo "|                                            |"
echo "|     read mail                              |"
echo "|                                            |"
echo "|     send mail                              |"
echo "|                                            |"
echo "|     sended                                 |"
echo "|                                            |"
echo "|     search                                 |"
echo "|                                            |"
echo "|     trash can                              |"
echo "|                                            |"
echo "|     exit                                   |"
echo "|                                            |"
echo "*--------------------------------------------*"

Show_nowUser
}

Show_nowUser()
{
Save
    tput cup 3 8
    echo "${ID_List[$UserNum]}"
}

ReadList_UI()
{
Save
    tput cup 0 0
echo "*--------------------------------------------*"
echo "|                  Mail Box                  |"
echo "|--------------------------------------------|"
echo "| user:                                      |"
echo "|--------------------------------------------|"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "*--------------------------------------------*"

tput cup 5 4
tput setaf 1
echo "prev"
tput sgr0
tput civis

Show_nowUser
ReadList_Show
}

ReadMail_UI()
{
Save
    tput cup 0 0
echo "----------------------------------------------"
echo "from.                                         "
echo "----------------------------------------------"
echo "title:                                        "
echo "----------------------------------------------"
echo "content:"

tput cup 1 6
echo "${ID_List[$UserNum]}"
}

SendList_UI()
{
Save
    tput cup 0 0
echo "*--------------------------------------------*"
echo "|                  Mail Box                  |"
echo "|--------------------------------------------|"
echo "| user:                                      |"
echo "|--------------------------------------------|"
echo "| who?                                       |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "*--------------------------------------------*"

tput cup 6 4
tput setaf 1
echo "prev"
tput sgr0
tput civis

Show_nowUser
SendList_Show

}

SendMail_UI()
{
Save
    tput cup 0 0
echo "----------------------------------------------"
echo "to.                                           "
echo "----------------------------------------------"
echo "title:                                        "
echo "----------------------------------------------"
echo "content:"
}

CreateID_UI()
{
Save
Start_UI
tput cup 6 11
echo "*=======================*"
tput cup 7 11
echo ":                       :"
tput cup 8 11
echo ":   New ID is created   :"
tput cup 9 11
echo ":                       :"
tput cup 10 11
echo "*=======================*"
sleep 1s
}

Sended_UI()
{
Save
    tput cup 0 0
echo "*--------------------------------------------*"
echo "|                  Mail Box                  |"
echo "|--------------------------------------------|"
echo "| user:                                      |"
echo "|--------------------------------------------|"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "*--------------------------------------------*"

tput cup 5 4
tput setaf 1
echo "prev"
tput sgr0
tput civis

Show_nowUser
Sended_Show

}

Search_UI()
{
Save
    tput cup 0 0
echo "*--------------------------------------------*"
echo "|                  Mail Box                  |"
echo "|--------------------------------------------|"
echo "| user:                                      |"
echo "|--------------------------------------------|"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "*--------------------------------------------*"

tput cup 5 4
tput setaf 1
echo "prev"
tput sgr0
tput civis

Show_nowUser

tput cup 9 19
echo "No Data"
tput cup 11 16
echo "Enter to Exit"
}

Trash_UI()
{
Save
    tput cup 0 0
echo "*--------------------------------------------*"
echo "|                  Mail Box                  |"
echo "|--------------------------------------------|"
echo "| user:                                      |"
echo "|--------------------------------------------|"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "|                                            |"
echo "*--------------------------------------------*"

tput cup 5 4
tput setaf 1
echo "prev"
tput sgr0
tput civis

Show_nowUser

tput cup 9 19
echo "No Data"
tput cup 11 16
echo "Enter to Exit"
}

SendMail_Check()
{
Save
tput cup 7 9
echo "*=======================*"
tput cup 8 9
echo "| 1. Regular Mail       |"
tput cup 9 9
echo "| 2. Important Mail     |"
tput cup 10 9
echo "| 3. With File          |"
tput cup 11 9
echo "| 4. Reset              |"
tput cup 12 9
echo "| 5. Exit               |"
tput cup 13 9
echo "| * Select[1-5] :       |"
tput cup 14 9
echo "*=======================*"
}

#Clear
Clear()
{
tput clear
}

#방향키 이동
Start_Select()
{
row=6
tput cup $row 18
echo ">"

while :
do

    read -sn 3 key

    if [ "$key" = "[A" ]; then
        row=6
        Start_UI
        tput cup $row 18
        echo ">"

    elif [ "$key" = "[B" ]; then
        row=9
        Start_UI
        tput cup $row 18
        echo ">"

    elif [ "$key" = "[C" ]; then
        continue

    elif [ "$key" = "[D" ]; then
        continue

    else
        if [ $row -eq 6 ]; then
            Clear
            SignIn_UI
            SignIn
            break
        elif [ $row -eq 9 ]; then
            Clear
            SignUp_UI
            SignUp
            break
        fi
    fi
done
}

SignUp_Select()
{
tput cup 12 18
echo "*sign up?*"
tput cup 14 13
echo "yes               no"

column=11
tput cup 14 $column
echo ">"

while :
do

    read -sn 3 key

    if [ "$key" = "[A" ]; then
        continue

    elif [ "$key" = "[B" ]; then
        continue

    elif [ "$key" = "[C" ]; then
        tput cup 14 $column
        echo " "
        column=29
        tput cup 14 $column
        echo ">"

    elif [ "$key" = "[D" ]; then
          tput cup 14 $column
          echo " "
          column=11
          tput cup 14 $column
          echo ">"
    else
        Clear
        if [ $column -eq 11 ]; then
            CreateID_UI
            SignUp_Yes
        fi
        Start_UI
        Start_Select
        break
    fi
done

}

Main_Select()
{
Save

row=6
tput cup $row 4
echo ">"

while :
do
    read -sn 3 key

    if [ "$key" = "[A" ]; then
        if [ $row -le 6 ]; then
            continue
        else
            row=`expr $row - 2`
            Main_UI
            tput cup $row 4
            echo ">"
        fi

    elif [ "$key" = "[B" ]; then
        if [ $row -ge 16 ]; then
            continue
        else
            row=`expr $row + 2`
            Main_UI
            tput cup $row 4
            echo ">"
        fi
    elif [ "$key" = "[C" ]; then
        continue
    elif [ "$key" = "[D" ]; then
        continue
    else
        if [ $row -eq 6 ]; then
            Clear
            ReadList_UI
            ReadList_Select
            break
        elif [ $row -eq 8 ]; then
            Clear
            SendList_UI
            SendList_Select
            break
        elif [ $row -eq 10 ]; then
            Clear
            Sended_UI
            Sended_Select
            break
        elif [ $row -eq 12 ]; then
            Clear
            Search_UI
            Search
            break
        elif [ $row -eq 14 ]; then
            Clear
            Trash_UI
            Trash
            break
        elif [ $row -eq 16 ]; then
            Clear
            Start_UI
            Start_Select
            break
        break
        fi
    fi
done
}

ReadList_Select()
{
readlist=`expr $readCnt + 6`
row=5
tput cup $row 2
echo ">"

while :
do
read -sn 1 fkey
if [ "$fkey" = "" ]; then

    read -sn 2 key

    if [ "$key" = "[A" ]; then
        if [ $row -le 5 ]; then
            continue
        else
            row=`expr $row - 1`
            ReadList_UI
            tput cup $row 2
            echo ">"
        fi

    elif [ "$key" = "[B" ]; then
        if [ $row -ge $readlist ]; then
            continue
        else
            row=`expr $row + 1`
            ReadList_UI
            tput cup $row 2
            echo ">"
        fi
    elif [ "$key" = "[C" ]; then
        continue
    elif [ "$key" = "[D" ]; then
        continue
    fi
elif [ "$fkey" = '' ]; then
    if [ $row -eq 5 ]; then
        Clear
        Main_UI
        Main_Select
        break
     else
        ReadMail
        break
     fi
fi
done

}

SendList_Select()
{
sendlist=`expr $count + 6`
row=6
tput cup $row 2
echo ">"

while :
do
read -sn 1 fkey
if [ "$fkey" = "" ]; then
    
    read -sn 2 key

    if [ "$key" = "[A" ]; then
        if [ $row -le 6 ]; then
            continue
        else
            row=`expr $row - 1`
            SendList_UI
            tput cup $row 2
            echo ">"
        fi

    elif [ "$key" = "[B" ]; then
        if [ $row -ge $sendlist ]; then
            continue
        else
            row=`expr $row + 1`
            SendList_UI
            tput cup $row 2
            echo ">"
        fi
    elif [ "$key" = "[C" ]; then
        continue
    elif [ "$key" = "[D" ]; then
        continue
    else
        if [ $row -eq 6 ]; then
            Clear
            Main_UI
            Main_Select
            break
        fi
    fi
elif [ "$fkey" = "S" ]; then
tput cup 20 20
echo "You puy S"
elif [ "$fkey" = '' ]; then
    if [ $row -eq 6 ]; then
        Clear
        Main_UI
        Main_Select
        break
    else
        for (( i=0; i <= $SendNum; i++ ))
        do
            sendindex=`expr $i + 7`
                if [ $row -eq $sendindex ]; then
                    Clear
                    SendMail_UI
                    tput cup 1 4
                    echo "${SendList[$i]}"
                    MailNum=$i
                    SendMail
                    break
                 fi
         done
     fi
fi
done

}

Sended_Select()
{
Sendedlist=`expr $SendedListCnt + 6`
row=5
tput cup $row 2
echo ">"

while :
do
read -sn 1 fkey
if [ "$fkey" = "" ]; then

    read -sn 2 key
        
        if [ "$key" = "[A" ]; then
        if [ $row -le 5 ]; then
            continue
        else
            row=`expr $row - 1`
            Sended_UI
            tput cup $row 2
            echo ">"
        fi

    elif [ "$key" = "[B" ]; then
        if [ $row -ge $Sendedlist ]; then
            continue
        else
            row=`expr $row + 1`
            Sended_UI
            tput cup $row 2
            echo ">"
        fi
    elif [ "$key" = "[C" ]; then
        continue
    elif [ "$key" = "[D" ]; then
        continue
    fi
elif [ "$fkey" = '' ]; then
    if [ $row -eq 5 ]; then
        Clear
        Main_UI
        Main_Select
        break
     else
        Sended
        break
     fi
fi
done

}


#Sign Up
SignUp()
{
Save

tput cup 6 12
tput cnorm
read NewID
  #동일 아이디 있는지 확인 후 에러 메세지 출력
if [ $count -ge 0 ]; then
    for (( i = 0; i <= $count; i++ ))
    do
        if [ "$NewID" == "${ID_List[$i]}" ]; then
            tput cup 8 7
            tput civis
            tput setaf 1
            echo "The name is already in use"
            sleep 1s
            tput sgr0
            tput civis

            SignUp_UI
            SignUp
            break
         fi
     done
fi

passwrd()
{
tput cnorm
tput cup 12 13
echo "                   "
tput cup 8 2
echo "Input password:"
tput cup 8 18
read -s password_i
tput cup 10 2
echo "Confirm password: "
tput cup 10 20
read -s password_c
tput civis

if [ "$password_i" == "$password_c" ]; then
    SignUp_Select
else
    tput cup 12 14
    tput setaf 1
    echo "password error"
    sleep 1s
    tput sgr0
    tput civis

    passwrd
fi
}
passwrd

}

#Sign Up 에서 Yes 선택시
SignUp_Yes()
{
ID_List+=("$NewID")
Password_List+=("$password_i")
count=`expr $count + 1`

echo $NewID >> /tmp/osc/User.txt
echo $password_i >> /tmp/osc/Password.txt
}


#Sign In
SignIn()
{
Save

tput cup 6 6
tput cnorm
read ID
#Check ID
if [ $count -ge 0 ]; then
    UserNum=-1
    for (( i = 0; i <= $count; i++ ))
    do
        if [ "$ID" == "${ID_List[$i]}" ]; then
            UserNum=$i
        fi
    done
    if [ $UserNum -ge 0 ]; then
            tput cup 8 2
            echo "password:"
            tput cup 8 12
            read -s password
            if [ "$password" == "${Password_List[$UserNum]}" ]; then
                tput civis
                Main_UI
                Main_Select
            else
                tput cup 10 14tput cup 7 12
echo "No Data"
tput cup 9 12
echo "Enter to Exit"
                tput civis
                tput setaf 1
                echo "wrong password"
                sleep 1s
                tput sgr0
                tput civis

                SignIn_UI
                SignIn
                break
            fi
    else
            tput cup 8 10
            tput civis
            tput setaf 1
            echo "The ID does not exist"
            sleep 1s
            tput sgr0
            tput civis

            SignIn_UI
            SignIn
            break
         fi
else
    tput cup 8 10
    tput civis
    tput setaf 1
    echo "Please create any IDs"
    sleep 1s
    tput sgr0
    tput civis

    Start_UI
    Start_Select
    break
fi
tput civis
}

ReadList_Show()
{
Save

mailCnt=`expr $mailCnt + 0`
ImailCnt=`expr $ImailCnt + 0`

unset ReadArr
ReadArr=()
readCnt=-1
readRow=6
tput civis
if [ $ImailCnt -ge 0 ]; then
    for (( i = 0; i <= $ImailCnt; i++ ))
    do
        j=`expr $i \* 6`
        if [ "${ID_List[$UserNum]}" == "${ImportMail[$j+1]}" ]; then
            tput cup $readRow 4
            echo "["
            tput cup $readRow 5
            tput setaf 1
            echo "!"
            tput sgr0
            tput civis
            tput cup $readRow 6
            echo "]"
            tput cup $readRow 8
            echo "${ImportMail[$j+2]}  -  ${ImportMail[$j]}"
            tput cup $readRow 25
            echo "${ImportMail[$j+4]}"
            ReadArr+=("$readRow")
            readRow=`expr $readRow + 1`
            readCnt=`expr $readCnt + 1`
            ReadArr+=("${ImportMail[$j]}")
            ReadArr+=("${ImportMail[$j+1]}")
            ReadArr+=("${ImportMail[$j+2]}")
            ReadArr+=("${ImportMail[$j+3]}")
            ReadArr+=("${ImportMail[$j+4]}")
            ReadArr+=("${ImportMail[$j+5]}")
        fi
    done
fi
if [ $mailCnt -ge 0 ]; then
    for (( i = 0; i<= $mailCnt; i++ ))
    do
        j=`expr $i \* 6`
        if [ "${ID_List[$UserNum]}" == "${MailArr[$j+1]}" ]; then
            tput cup $readRow 4
            echo "${MailArr[$j+2]}  -  ${MailArr[$j]}"
            tput cup $readRow 25
            echo "${MailArr[$j+4]}"
            ReadArr+=("$readRow")
            readRow=`expr $readRow + 1`
            readCnt=`expr $readCnt + 1`
            ReadArr+=("${MailArr[$j]}")
            ReadArr+=("${MailArr[$j+1]}")
            ReadArr+=("${MailArr[$j+2]}")
            ReadArr+=("${MailArr[$j+3]}")
            ReadArr+=("${MailArr[$j+4]}")
            ReadArr+=("${MailArr[$j+5]}")
        fi
    done
fi
}

SendList_Show()
{
Save

SendNum=-1
SendList=()
index=7
for (( i = 0; i <= $count; i++ ))
do
    if [ ${ID_List[$i]} == "${ID_List[$UserNum]}" ]; then
        continue
    else
        tput cup $index 4
        echo "${ID_List[$i]}"
        SendList+=(${ID_List[$i]})
        SendNum=`expr $SendNum + 1`
        index=`expr $index + 1`
    fi
done
}

Sended_Show()
{
Save

SendedCntCmp=`expr $SendedCnt + 1`
SendedCnt=`expr $SendedCnt + 0`

unset SendedList
SendedList=()
SendedListCnt=-1
SendedRow=6
tput civis
if [ $SendedCnt -ge 0 ]; then
    for (( i = 0; i < $SendedCntCmp; i++ ))
    do
        j=`expr $i \* 6`
        if [ "${ID_List[$UserNum]}" == "${SendedArr[$j]}" ]; then
            if [ "${SendedArr[$j+3]}" == "I" ]; then
            tput cup $SendedRow 4
            echo "["
            tput cup $SendedRow 5
            tput setaf 1
            echo "!"
            tput sgr0
            tput civis
            tput cup $SendedRow 6
            echo "]"
            tput cup $SendedRow 8
            echo "${SendedArr[$j+2]} - ${SendedArr[$j+1]}"
            elif [ "${SendedArr[$j+3]}" == "R" ]; then
            tput cup $SendedRow 4
            echo "${SendedArr[$j+2]} - ${SendedArr[$j+1]}"
            fi
            tput cup $SendedRow 25
            echo "${SendedArr[$j+4]}"
            
            SendedList+=("$SendedRow")
            SendedRow=`expr $SendedRow + 1`
            SendedListCnt=`expr $SendedListCnt + 1`
            SendedList+=("${SendedArr[$j]}")
            SendedList+=("${SendedArr[$j+1]}")
            SendedList+=("${SendedArr[$j+2]}")
            SendedList+=("${SendedArr[$j+3]}")
            SendedList+=("${SendedArr[$j+4]}")
            SendedList+=("${SendedArr[$j+5]}")
        fi
    done
fi

}

SendMail()
{
IFS_backup="$IFS"
IFS=$'\t'
tput cnorm
tput cup 3 7
read title
touch /tmp/osc/$title

tput cup 6 0
space=" "
while :
do
    read -n 1 content
    if [ "$content" = "" ]; then
        IFS="$IFS_backup"
        echo $contentT >> /tmp/osc/$title
        SendMail_ESC

        break
    elif [ "$content" = '' ]; then
        echo $contentT >> /tmp/osc/$title
        unset contentT
    elif [ "$content" = " " ]; then
        contentT="$contentT$space"
    else
        contentT="$contentT$content"
    fi
done
}

SendMail_ESC()
{
tput civis

 SendMail_Check
 tput cnorm
 tput cup 13 27
    read key

    if [ "$key" == "1" ]; then

        mailCnt=`expr $mailCnt + 1`
        SendedCnt=`expr $SendedCnt + 1`
        echo $mailCnt > /tmp/osc/mailCnt
        echo $SendedCnt > /tmp/osc/SendedCnt
#0 From
        echo "${ID_List[$UserNum]}" >> /tmp/osc/MailArr
        echo "${ID_List[$UserNum]}" >> /tmp/osc/SendedArr
#1 To
        echo "${SendList[$MailNum]}" >> /tmp/osc/MailArr
        echo "${SendList[$MailNum]}" >> /tmp/osc/SendedArr
#2 Title
        echo "$title" >> /tmp/osc/MailArr
        echo "$title" >> /tmp/osc/SendedArr
#3 Content
        echo "X" >> /tmp/osc/MailArr
        echo "R" >> /tmp/osc/SendedArr
#4 Time
        echo "`date '+%Y-%m-%d/%H:%M:%S'`" >> /tmp/osc/MailArr
        echo "`date '+%Y-%m-%d/%H:%M:%S'`" >> /tmp/osc/SendedArr
#4 File Name
        echo "NO_File" >> /tmp/osc/MailArr
        echo "No_File" >> /tmp/osc/SendedArr

        MailArr=(`cat /tmp/osc/MailArr`)
        mailCnt=`cat /tmp/osc/mailCnt`
        SendedArr=(`cat /tmp/osc/SendedArr`)
        SendedCnt=`cat /tmp/osc/SendedCnt`

        unset contentT

        tput civis
        Main_UI
        Main_Select
        break
    elif [ "$key" == "2" ]; then
        ImailCnt=`expr $ImailCnt + 1`
        SendedCnt=`expr $SendedCnt + 1`

        echo $ImailCnt > /tmp/osc/ImailCnt
        echo $SendedCnt > /tmp/osc/SendedCnt
#0 From
        echo "${ID_List[$UserNum]}" >> /tmp/osc/ImportMail 
        echo "${ID_List[$UserNum]}" >> /tmp/osc/SendedArr
#1 To
        echo "${SendList[$MailNum]}" >> /tmp/osc/ImportMail
        echo "${SendList[$MailNum]}" >> /tmp/osc/SendedArr
#2 Title
        echo "$title" >> /tmp/osc/ImportMail
        echo "$title" >> /tmp/osc/SendedArr
#3 Content
        echo "X" >> /tmp/osc/ImportMail 
        echo "I" >> /tmp/osc/SendedArr
#4 Time
        echo "`date '+%Y-%m-%d/%H:%M:%S'`" >> /tmp/osc/ImportMail 
        echo "`date '+%Y-%m-%d/%H:%M:%S'`" >> /tmp/osc/SendedArr
#4 File Name
        echo "NO_File" >> /tmp/osc/ImportMail
        echo "No_File" >> /tmp/osc/SendedArr

        ImportMail=(`cat /tmp/osc/ImportMail`)
        ImailCnt=(`cat /tmp/osc/ImailCnt`) 
        SendedArr=(`cat /tmp/osc/SendedArr`)
        SendedCnt=`cat /tmp/osc/SendedCnt`


        unset contentT

        tput civis
        Main_UI
        Main_Select
        break
    elif [ "$key" == "3" ]; then
    
    unset contentT

        TITLE
        UI
        show_pwd
        file_show
        dfc_show
        cursor
        break
    elif [ "$key" == "4" ]; then
    
    unset contentT
    rm /tmp/osc/$title

        Clear
        SendMail_UI
        tput cup 1 4
        echo "${SendList[$MailNum]}"
        SendMail
    elif [ "$key" == "5" ]; then
    
    unset contentT
    rm /tmp/osc/$title

        tput civis
        Clear
        SendList_UI
        SendList_Select
        break
    fi

}

ReadMail()
{
for (( i=0; i <= readCnt; i++ ))
do
    j=`expr $i \* 7`

    if [ $row == ${ReadArr[$j]} ]; then
        Clear
        ReadMail_UI
        tput cup 3 7
        echo "${ReadArr[$j+3]}"
        tput cup 6 0
        cat /tmp/osc/${ReadArr[$j+3]}

        if [ "${ReadArr[$j+4]}" == "O" ]; then

            tput cup 12 0
            echo "download file? [y/n]"
            tput cnorm
            tput cup 12 21
            read yORn
            if [ "$yORn" == "y" ]; then
                cd
                cp /tmp/osc/${ReadArr[$j+6]} `pwd`/
                tput civis
                Clear
                ReadList_UI
                ReadList_Select
            else
                Clear
                ReadList_UI
                ReadList_Select
            fi

        fi

        enterR
     fi
done

}

enterR()
{

        read -sn 1 key
        if [ "$key" == '' ]; then
            Clear
            ReadList_UI
            ReadList_Select
        else
            enterR
            continue
        fi
}

Sended()
{
for (( i=0; i <= SendedListCnt; i++ ))
do
    j=`expr $i \* 7`
    if [ $row == ${SendedList[$j]} ]; then
        Clear
        ReadMail_UI
        tput cup 3 7
        echo "${SendedList[$j+3]}"
        tput cup 6 0
        cat /tmp/osc/${SendedList[$j+3]}

        enterS
     fi 
done

}

enterS()
{

        read -sn 1 key
        if [ "$key" == '' ]; then
            Clear
            Sended_UI
            Sended_Select
        else
            enterS
            continue
        fi
}

Search()
{

read -sn 1 key
if [ "$key" == '' ]; then
    Clear
    Main_UI
    Main_Select
    break
else
    Search
    continue
fi
}

Trash()
{
read -sn 1 key
if [ "$key" == '' ]; then
    Clear
    Main_UI
    Main_Select
    break
else
    Trash
    continue
fi
}


Main
