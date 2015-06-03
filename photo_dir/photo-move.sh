#!/bin/sh

# Get md5sum for all picutre files and make diff_list based on all files in a list - move = diff_list

dir=$PWD
db(){
    tmp=$(echo $f | tr  '*' ' ')    #hack
    file=$(echo $tmp | awk '{printf $2"/"$1}')
    sum=$(md5sum $file)
    echo -e $f"\t"$sum >> move
}

# ORF 
for f in $(find . -name '*.ORF' -printf "%f***%h\n"); do db ; done   #FASTER METHOD

#JPG
for f in $(find . -name '*.JPG' -printf "%f***%h\n" );do db ; done
for f in $(find . -name '*.jpg' -printf "%f***%h\n" );do db ; done
for f in $(find . -name '*.jpeg' -printf "%f***%h\n" );do  db ; done

cp /media/RAIDVOL2/A_foto/list /tmp/list
cp $dir/move /tmp/diff_list

cd /tmp
while read line 
do
    sum=$(echo $line | awk '{printf $2}')
    if [ "$sum" == ""  ] ; then
	echo 
    else
	sed -i "$sum"d /tmp/diff_list 
    fi
done <  list

cp /tmp/diff_list $dir



