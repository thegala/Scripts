#!/bin/sh

# Goes through all jpeg and ORF and get's list of all files in current directory
# Add get diff from allready created database

# ORF 
for f in $( find . -name '*.ORF' ); do sh ./photo_orf.sh ; done   #FASTER METHOD

#JPG
for f in $(find . -name '*.JPG' -or -name '*.jpg'  ); do sh ./photo_jpg.sh ; done
for f in $(find . -name '*.jpeg'  ); do sh ./photo_jpg.sh ; done



