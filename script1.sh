#!/bin/bash


VAR1="this is from script1"
echo "$VAR1"
echo "PID of script1:$$"

source ./script2.sh 
echo "$VAR2"