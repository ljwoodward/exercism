#!/usr/bin/env bash

main () {
  declare -A brackets
  brackets["("]=")"
  brackets["["]="]"
  brackets["{"]="}"
  declare open
  for i in $(seq 0 ${#1})
  do
    if [[ ${1:i:1} =~ [{\[\(] ]]
    then
      open="${open}${1:i:1}"
    elif [[ ${1:i:1} =~ []\)}] ]]
    then
      if [ -z $open ]
      then
        echo false
        exit 0
      elif [[ ${brackets[${open:${#open}-1:1}]} != ${1:i:1} ]]
      then
        echo false
        exit 0
      else
        open=${open:0:${#open}-1}
      fi
    fi
  done
  if [ -z $open ]
  then
    echo true
  else
    echo false
  fi
}

main "$@"


# # Nice other solutions:
# declare -A brackets=(
#     ["]"]="["
#     [")"]="("
#     ["}"]="{"
# )
# stack=""
#
# for ((i=0; i<${#1}; i++)); do
#     char=${1:i:1}
#     case $char in
#         "[" | "(" | "{")
#             stack+=$char
#             ;;
#         "]" | ")" | "}")
#             if [[ -z $stack || $stack != *"${brackets[$char]}" ]]; then
#                 echo false
#                 exit
#             else
#                 stack=${stack%?}
#             fi
#             ;;
#     esac
# done
#
# [[ -z $stack ]] && echo true || echo false

# # Another:
# string="$1"
#
# declare -a stack=()
# declare -i string_length="${#string}"
#
# for (( i=0; i < "$string_length"; i++)); do
#     letter="${string:i:1}"
#     case "$letter" in
#     '{')
#         stack+=('}')
#         ;;
#     '[')
#         stack+=(']')
#         ;;
#     '(')
#         stack+=(')')
#         ;;
#     '}' | ']' | ')')
#         if (( ${#stack} == 0 )); then
#             echo 'false'
#             exit 0
#         fi
#         head="${stack[-1]}"
#         if [[ $head != "$letter" ]]; then
#             echo 'false'
#             exit 0
#         fi
#         unset 'stack[${#stack[@]}-1]'
#         ;;
#     esac
# done
#
# (( ${#stack} == 0 )) && echo 'true' || echo 'false'

# # Similar to first:
# main () {
#     (( $# == 1 )) || exit 1
#
#     length=${#1}
#     stack=""
#     for ((i = 0; i < length; i++)); do
#         c="${1:i:1}"
#         case $c in
#             \( )
#                 stack="${stack})";;
#             \[ )
#                 stack="${stack}]";;
#             \{ )
#                 stack="${stack}}";;
#             [\)\]\}] )
#                 if [[ "$c" != "${stack: -1:1}" ]]; then
#                     echo "false"
#                     exit
#                 fi
#                 stack="${stack:0:-1}"
#                 ;;
#         esac
#     done
#
#     if [[ -z "$stack" ]]; then
#         echo "true"
#     else
#         echo "false"
#     fi
# }
#
# main "$@"
