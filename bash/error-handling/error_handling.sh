#!/usr/bin/env bash

hello () {
  echo "Hello, ${1}"
}

error_handling () {
  usage="Usage: ./error_handling <greetee>"
  if [[ $# -ne 1 ]]
  then
    echo "${usage}"
    exit 1
  fi
}

main () {
  error_handling "$@"
  hello "$1"
}

main "$@"
