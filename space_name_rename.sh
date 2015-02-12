#!/bin/bash
ls -R > /tmp/list
# we have to make the list file in a separate
# directory so that it doesn't get included
# in the list of the current directory!
mv /tmp/list ./list
cat list | tr ' ' '_' > listnew
# this turns spaces into underscores
FILE_COUNT=$(wc -l list | awk '{print $1}')
LOOP=1
while [ "$LOOP" -le "$FILE_COUNT" ]
do
     AWKFEED="FNR=="$LOOP
   # the command to feed awk
   # output will be 'FNR==1', 'FNR==2', ..
     OLDFILE=$(awk $AWKFEED list)
     NEWFILE=$(awk $AWKFEED listnew)
     mv "$OLDFILE" "$NEWFILE"
   # keep the quotes to make the shell read file
   # names with spaces as one file
     LOOP=$(($LOOP+1))
done
rm list
rm listnew
exit 0
