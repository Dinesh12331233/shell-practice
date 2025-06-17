#!/bin/bash

USERID=$(id -u)

if [ $USERID -ne 0 ]
then 
    echo "Error: you must have root access to install"
    
fi 

dnf install mysql -y