#!/bin/bash

#Script for iterate over jamendo db list

NUM_DB=$(wc -l db | awk '{printf $1}')
DIR=/tmp/jam/
mkdir $DIR

I=1
A=0
NUM_START=31400
NUM_END=31472
#Seperate in threads 
THREADS=2
NUM=0
let NUM_DEL=$NUM_END-$NUM_START
let NUM=$NUM_DEL/$THREADS
until [ "$A" == "$THREADS" ]; do 
    FIRST=0
    LAST=0
    let A1=$A+1
    let FIRST=$NUM*$A+1+$NUM_START
    let LAST=$NUM*$A1+$NUM_START
    DIR2=$DIR$A
    mkdir $DIR2
    sh ./jam_thread.sh $FIRST $LAST $DIR2 &
    let A=$A+1
done


