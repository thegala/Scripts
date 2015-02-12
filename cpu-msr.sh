#!/bin/bash

#Script for iterate over cpu msr and save guess msr code


I=0
MAX=$1
touch msr
echo -e "code_in\tout_d\t\t\tout_x" > msr
until [ "$I" == "$MAX" ]; do
    rdmsr -d 0x$I
    #CODE=$(cat msr1)
    OUT=$?
    if [ $OUT -eq 0 ];then
      echo "YES!!"
      CODE_D=$(rdmsr -d 0x$I)
      CODE_X=$(rdmsr  0x$I)
      echo -e "0x$I\t$CODE_D\t\t\t$CODE_X" >> msr
    else
	echo "NO!!"
    fi
    let I=$I+1
done
