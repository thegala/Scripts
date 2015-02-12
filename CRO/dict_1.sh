#!/bin/bash

#This script prepare transcipt for java tokinezer and phoner

#Global variables input from user
final=$2

#Name of file of sphinx tran
name=$1

var=0
lines=`cat $name | wc -l`

#Read tran and clean file and put to $final
while [ "$var" -lt "$lines" ]
do
    orig=`cat $name | head -n $var | tail -n 1 `
    echo $orig > temp

    #Remove non text
    sed 's/<\/.*>.*//g' temp  > temp2
    sed 's/<.*>//g' temp2  > temp
    cat temp >> $final
    var=`expr $var + 1`          
done

#Last cleanLw
rm temp temp2
exit
