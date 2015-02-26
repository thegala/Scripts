#!/bin/bash
#
#Script for reading stack and parsing line to wget so I can easily download files
#to old comp

#Basic configuration
READ_FILE=$1
DOWNLOAD_DIR=$2
LOG_DIR=$3
LOG_FILE=$LOG_DIR/
OVER_FILE=$LOG_DIR/

#While loop that go to download dir
#remove line that contain link 1st line
#and move link to log over file
while read line 
do
    cd $DOWNLOAD_DIR
    nohup wget $line > $LOG_FILE &
    sed '1d'
    echo $line >> $OVER_FILE 
done < $READ_FILE

    

