#!/bin/bash

# Goes through all jpeg and ORF and get's list of all files in current directory
# Add get diff from allready created database

while read line 
do

# ORF 
if [[ $line == *.ORF  ]] ; then
    sh ./photo_orf.sh	$( find . -name $line ) 
fi

#JPG
if [[ $line == *.JPG ||  $line == *.jpg || $line == *.jpeg ]] ; then
    sh ./photo_jpg.sh	$(find . -name $line ) 
fi

done < $1


