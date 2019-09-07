#!/usr/bin/env bash
declare -A colors

# Associative Array:
colors=( [black]=0 [brown]=1 [red]=2 [orange]=3 [yellow]=4 [green]=5 [blue]=6 [violet]=7 [grey]=8 [white]=9)

get_resistor_strength () {
  echo ${colors[$1]}${colors[$2]}
}

check_errors () {
  declare -i valid1=0
  declare -i valid2=0
  for key in ${!colors[@]}; do
    if [[ $1 == ${key}  &&  $2 == ${key} ]]
    then
      valid1+=2
    elif [[ $1 == ${key}  ||  $2 == ${key} ]]
    then
      valid1+=1
    fi
  done
  if  (( ${valid1} != 2 ))  #||  (( ${valid2} < 1 ))
  then
    echo invalid color
    exit 1
  fi
}

main () {
  check_errors "$@"
  get_resistor_strength "$@"
}

main "$@"
#


# # Some other solutions:
# # 1.

# main() {
# 	declare -A bands=(["black"]=0 ["brown"]=1 ["red"]=2 ["orange"]=3 ["yellow"]=4 ["green"]=5 ["blue"]=6 ["violet"]=7 ["grey"]=8 ["white"]=9)
#
# 	local resistance=""
# 	for k in "$@"; do
# 		if ! [[ "${bands["$k"]}" ]];  then
# 			echo "invalid color"
# 			exit  1
# 		fi
# 		resistance="${resistance}${bands["$k"]}"
# 	done
# 	echo "$resistance"
# }
#
#
# main "$@"


# # 2.

# for color in "$@"
# do
#   case "$color" in
#     black)
#     color=0
#     ;;
#     brown)
#     color=1
#     ;;
#     red)
#     color=2
#     ;;
#     orange)
#     color=3
#     ;;
#     yellow)
#     color=4
#     ;;
#     green)
#     color=5
#     ;;
#     blue)
#     color=6
#     ;;
#     violet)
#     color=7
#     ;;
#     grey)
#     color=8
#     ;;
#     white)
#     color=9
#     ;;
#     *)
#     echo "invalid color"
#     exit 1
#   esac
#   printf "$color"
# done
#
# echo


# # 3.
#
# declare -A resistances=( ["black"]="0" ["brown"]="1" ["red"]="2" ["orange"]="3" ["yellow"]="4" ["green"]="5" ["blue"]="6" ["violet"]="7" ["grey"]="8" ["white"]="9")
#
# if [ -z "${resistances[$1]}" ] || [ -z "${resistances[$2]}" ]; then
# 	echo 'invalid color'
# 	exit 1
# fi
#
# if (( $# != 2 )); then
# 	echo 'Usage: resistor_color_duo <color1> <color2>'
# 	exit 1
# fi
#
# echo "${resistances[$1]}${resistances[$2]}"
