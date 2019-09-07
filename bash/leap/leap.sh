#!/usr/bin/env bash
is_leap () {
  res=false
  if (( $1 % 4 == 0 ))
  then
    res=true
  fi
  if (( $1 % 100 == 0 ))
  then
    res=false
  fi
  if (( $1 % 400 == 0 ))
  then
    res=true
  fi
  echo ${res}
}

check_for_errors () {
  usage="Usage: leap.sh <year>"
  if ! [[ $1 =~ ^[0-9]+$ ]] || [ $# -ne 1 ]  # if the first argument is not a number and there is only one argument.
  then
    echo ${usage}
    exit 1
  fi
}

main () {
  check_for_errors "$@"
  is_leap "$@"
}

main "$@"
