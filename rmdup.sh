#!/bin/bash

for file /home/mirko/CMUSphinx/etc/CRO* 
do
 TEXT=$(sed 's/ \+ /\t/g' $file)
 sed ( )
 echo $TEXT > $file 
done

