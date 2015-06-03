#!/bin/bash

cd $1 $2 $3
rm cmd cmd2 cmd3
while read line
do
    echo 'sudo ntfsundelete /dev/sde3 -u -T --force  -i '$line >> cmd
done < $2

while read line
do
    echo ' -o '$line' -d '$PWD >> cmd2
done < $3
paste -d" " cmd cmd2 > cmd3

while read line
do
    $line
done < cmd3



