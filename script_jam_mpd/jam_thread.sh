#!/bin/bash
FIRST=$1
LAST=$2
DIR2=$3
until [ "$FIRST" == "$LAST" ]; do
    IN=$(head -n $FIRST db | tail -n 1)
    sh ./jamendo.sh $IN $DIR2 
    echo $IN >> db.fin
    let FIRST=$FIRST+1
done


