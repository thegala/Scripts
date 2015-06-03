#!/bin/sh

#Only creates db or file with name and a hash sum in list

db(){
    tmp=$(echo $f | tr  '*' ' ')    #hack
    file=$(echo $tmp | awk '{printf $2"/"$1}')
    sum=$(md5sum $file)
    echo -e $f"\t"$sum >> db
}

# ORF 
for f in $(find . -name '*.ORF' -printf "%f***%h\n"); do db ; done   #FASTER METHOD

#JPG
for f in $(find . -name '*.JPG' -printf "%f***%h\n" );do db ; done
for f in $(find . -name '*.jpg' -printf "%f***%h\n" );do db ; done
for f in $(find . -name '*.jpeg' -printf "%f***%h\n" );do  db ; done



