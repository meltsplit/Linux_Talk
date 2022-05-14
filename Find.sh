#! /bin/bash

: << END
사용자의 입력을 받아 일치하는 부분을 다른 색깔로 표시(카카오톡과 유사한 방식).
grep에 의해 표시된 부분의 뒤쪽의 글자의 색이 하얀색으로 바뀌는 문제가 발생, 해결 필요
END

room=$1
read -p "Input message: " msg
GREP_COLOR="46" grep -E --color=always "|${msg}" ${room}
# GREP_COLOR="38;2;R;G;B" grep -E --color=always "|${msg}" ${room} 으로 원하는 색 지정 가능; R, G, B에 각각 (0~255) 입력;
