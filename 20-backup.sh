#!/bin/bash

USERID=$(id -u) 
SOURCE_DIR=$1
DEST_DIR=$2 
DAYS=${3:-14} 

LOGS_FOLDER="/var/log/shellscript-logs"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log" 
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

mkdir -p $LOGS_FOLDER 

#checking the user has root access or not
if [ $USERID -ne 0 ]
then
    echo -e "$R Error: you must have root access to execute the script $N " | tee -a $LOG_FILE
    exit 1
else 
    echo "you are root user.you have root access" | tee -a $LOG_FILE
fi 

USAGE(){
    echo -e "$R USAGE:: $N sh 20-backup.sh <source-dir> <dest-dir> <days(optional)>"
}

VALIDATE() {

if [ $1 -ne 0 ]
    then 
        echo -e "$2....$R FAILURE $N" | tee -a $LOG_FILE
        exit 1
    else
        echo -e "$2....$G SUCCESS $N" | tee -a $LOG_FILE
    fi         
}

if [ $# -lt 2 ]
then 
    USAGE
fi 

if [ ! -d $SOURCE_DIR ]
then 
    echo -e "$R Source Directory $SOURCE_DIR does not exist. please check $N"
    exit 1
fi 

if [ ! -d $DEST_DIR ]
then 
    echo -e "$R Destination Directory $DEST_DIR does not exist. please check $N"
    exit 1
fi

FILES=$(find $SOURCE_DIR -name "*.log" -mtime +$DAYS) 

if [ ! -z "$FILES" ]
then 
    echo "files to zip are: $FILES"
    TIMESTAMP=$(date +%F-%H-%M-%S) 
    ZIP_FILE="$DEST_DIR/app-logs-$TIMESTAMP.zip" 
    find $SOURCE_DIR -name "*.log" -mtime +$DAYS | zip -@ "$ZIP_FILE"  

    if [ -f $ZIP_FILE ]
    then 
        echo -e "Zip file creation....$G SUCCESS $N" 

        while IFS= read -r FILEPATH 
        do 
            echo "deleting file: $FILEPATH" | tee -a $LOG_FILE
            rm -rf $FILEPATH  
        done <<< $FILES 

        echo -e "Removing log files olderthan $DAYS days from the source directory....$G SUCCESS $N" 

    else 
        echo -e "Zip file creation....$R FAILURE $N" 
    fi     
else 
    echo -e "No log files found olderthan 14 days $Y SKIPPING $N" 
fi 



