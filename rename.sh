#!/bin/bash 
# Edit naslov
ls $1 > /tmp/list
mv /tmp/list ./list
cat list | grep .wav > list2
cp list2 list
cat list | sed 's/$1//g' $name > listnew

# this turns spaces into underscores
FILE_COUNT=$(wc -l list | awk '{print $1}')
LOOP=1
while [ "$LOOP" -le "$FILE_COUNT" ]
do
    AWKFEED="FNR=="$LOOP
   #the command to feed awk
   #output will be 'FNR==1', 'FNR==2', ..
    OLDFILE=$(awk $AWKFEED list)
    NEWFILE=$(awk $AWKFEED listnew)".wav"
    mv "$OLDFILE" "$NEWFILE"
   #keep the quotes to make the shell read file
   #names with spaces as one file
    LOOP=$(($LOOP+1))
done
rm list
rm listnew
rm list2
exit 0
