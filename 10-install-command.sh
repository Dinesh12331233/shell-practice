#!/bin/bash

USERID=$(id -u)

if [ $USERID -ne 0 ]
then 
    echo "Error: you must have root access to install"
    exit 1
fi 

dnf list installed mysql

if [ $? -ne 0 ]
then
    echo "mysql is not installed.hence we are installing now"
    
    dnf install mysql -y

        if [ $? -ne 0 ]
        then
            echo "installing mysql....FAILURE"
            exit 1
        else
            echo "installing mysql....SUCCESS"
        fi        
else
    echo "mysql is already installed."  
fi       

         