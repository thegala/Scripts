#!/bin/bash

#Script for iterate over jamendo db list

NUM_DB=$(wc -l db | awk '{printf $1}')

I=20001
until [ "$I" == "25000" ]; do
    IN=$(head -n $I db | tail -n 1)
    sh ./jamendo.sh $IN
    echo $IN >> db.fin
    let I=$I+1
done
