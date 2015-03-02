#!/bin/bash
#
#Script for reading stack and parsing line to wget so I can easily download files
#to old comp

#Basic configuration
READ_FILE=$1
DOWNLOAD_DIR=$2
LOG_DIR=$3
LOG_FILE=$LOG_DIR/$4
OVER_FILE=$LOG_DIR/$5

#While loop that go to download dir
#remove line that contain link 1st line
#and move link to log over file
stack(){
    while read line 
    do
        cd $DOWNLOAD_DIR
        nohup wget $line >> $LOG_FILE &
        sed -i '1d' $READ_FILE
        echo $line >> $OVER_FILE 
    done < $READ_FILE
}

while true
do
    stack
    sleep 5m
done
