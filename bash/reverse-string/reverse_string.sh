  main () {
    # echo $1 | rev
    rev <<< "$1"
  }

  main "$@"


# # Here's someone else's solution, that shows how to do a for loop
# #!/bin/bash
#
# string=$*                       # get all arguments as one
# length=${#string}               # this is how to get the length
#
# for((i=$length-1;i>=0;i--));
# do
#   rev="$rev${string:$i:1}";
# done
#
#
# echo $rev
