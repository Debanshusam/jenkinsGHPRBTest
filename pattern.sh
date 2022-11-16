word=$1;pattern=$2;
if [[ $word =~ $pattern ]]; then echo "matched";else echo "false";fi