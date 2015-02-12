#!/bin/bash

#Convert pdf tp grayscale inverted pdf or ps or just images  
curdir=`pwd`
mkdir /tmp/convert
out=/tmp/convert/out.pdf
outjpg=/tmp/convert/out
outname=$1".pdf"

if [[ -t 1 ]]
then
    if [[ $1 == *".pdf" ]]
    then
	pages=`pdfinfo $1 | grep Pages | awk '{printf $2}'`
	#make pdf grayscale
	gs -sDEVICE=pdfwrite  -sProcessColorModel=DeviceGray  -sColorConversionStrategy=Gray  -dOverrideICC  -o $out -f $1 
	gs -sDEVICE=jpeg -o $outjpg-%d.jpg -dJPEGQ=80 -r300x300 $out 
	i=0
	#invert all jpg's 
	while [[ "$i" != "$pages"  ]] ; do
	    i=`expr $i + 1`
	    name="/tmp/convert/out-"$i".jpg"
	    convert $name -negate $name
	done
	convert /tmp/convert/*.jpg $outname 
	rm -r /tmp/convert/*
	rmdir /tmp/convert
    fi
fi
	    

