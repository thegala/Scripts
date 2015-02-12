#!/bin/sh

#Check su m form db in list and reomove same files so i only move 
#not moved files
cp /media/RAIDVOL2/A_foto/list /tmp/diff_list
cp /media/RAIDVOL2/A_foto_date/db /tmp/db


cd $1
cd /tmp
while read line 
do
    sum=$(echo $line | awk '{printf $2}')
    if [ "$sum" == ""  ] ; then
	echo 
    else
	sed -i '/$sum/d' /tmp/diff_list 
    fi
done < db 

cp diff_list /media/RAIDVOL2/A_foto/

