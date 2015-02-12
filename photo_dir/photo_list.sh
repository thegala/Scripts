#!/bin/sh

# Goes through all jpeg and ORF and create list of all files

db(){
    tmp=$(echo $f | tr  '*' ' ')    #hack
    file=$(echo $tmp | awk '{printf $2"/"$1}')
    sum=$(md5sum $file)
    echo -e $f"\t"$sum >> list
}

# ORF 
for f in $(find . -name '*.ORF' -printf "%f***%h\n"); do db ; done   #FASTER METHOD

#JPG
for f in $(find . -name '*.JPG' -printf "%f***%h\n" );do db ; done
for f in $(find . -name '*.jpg' -printf "%f***%h\n" );do db ; done
for f in $(find . -name '*.jpeg' -printf "%f***%h\n" );do  db ; done



