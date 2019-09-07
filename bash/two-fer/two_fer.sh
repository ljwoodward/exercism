#!/usr/bin/env bash

  main () {
    you=$1
    if [ -z "$1" ]
    then
      you=you
    fi
    echo "One for ${you}, one for me."
  }

  main "$@"
