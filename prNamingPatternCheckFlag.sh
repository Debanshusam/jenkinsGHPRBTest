#!/bin/bash
#if [[ "GCPID:XXXX-testjob" =~ GCPID:[\sXx\d]{0,1}-[a-zA-Z]{0,}[-]{0,1}[a-zA-Z\d]{0,} ]]; then echo "matched";else echo "false";fi
word='GCPID: XXXX-testjob'
pattern="[Gg][Cc][Pp][Ii][Dd][:\W\S\sXx\d]{0,}[-]*[a-zA-Z]{0,}[-]{0,1}[a-zA-Z\d]{0,}"
echo $pattern
echo $word
#if [[ "$pattern" =~ [\"\'][Gg][Cc][Pp][Ii][Dd][:\sXx\d]{0,}-[a-zA-Z]{0,}[-]{0,1}[a-zA-Z\d]{0,}[\"\'] ]]; then echo "matched";else echo "false";fi
if [[ $word =~ $pattern ]]; then echo "matched";else echo "false";fi