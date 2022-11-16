#!/bin/bash
#if [[ "GCPID:XXXX-testjob" =~ GCPID:[\sXx\d]{0,1}-[a-zA-Z]{0,}[-]{0,1}[a-zA-Z\d]{0,} ]]; then echo "matched";else echo "false";fi
if [[ "GCPID:XXXX-testjob" =~ [Gg][Cc][Pp][Ii][Dd]:[\\sXx\\d]{0,}-[a-zA-Z]{0,}[-]{0,1}[a-zA-Z\\d]{0,} ]]; then echo "matched";else echo "false";fi