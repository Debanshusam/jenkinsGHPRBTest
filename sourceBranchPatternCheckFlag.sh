
#if [[ 'feature/gcpid-xxxx-testjob' =~ feature/[Gg][Cc][Pp][Ii][Dd]-[Xx\d]{0,}-[a-zA-Z]{0,}[-]{0,1}[\d]{0,} ]]; then echo "matched";else echo "false";fi

word='feature/gcpid-xxxx-testjob';pattern="feature/[Gg][Cc][Pp][Ii][Dd][-]*[Xx\d]{0,}[-]*[a-zA-Z]{0,}[-]{0,1}[\d]{0,}"

#if [[ "$pattern" =~ [\"\'][Gg][Cc][Pp][Ii][Dd][:\sXx\d]{0,}-[a-zA-Z]{0,}[-]{0,1}[a-zA-Z\d]{0,}[\"\'] ]]; then echo "matched";else echo "false";fi
if [[ $word =~ $pattern ]]; then echo "matched";else echo "false";fi