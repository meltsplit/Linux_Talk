#! /bin/bash

: << END
사용자의 입력을 받아 일치하는 부분을 다른 색깔로 표시(카카오톡과 유사한 방식, 일치하지 않는 부분도 모두 출력됨).
grep에 의해 표시된 부분의 뒤쪽의 글자의 색이 하얀색으로 바뀌는 문제가 발생, 해결 필요
END

room=$1
read -p "Input message: " msg
nl -w 1 -s ": " ${room} | GREP_COLOR="48;2;100;120;210" grep -C 4 -E --color=always ${msg}
