#!/bin/bash

#Script for creating file for dvd-slideshow with kenburts on faces in mind
#Using facedetect so i can now where  are faces

########################################################################
########################################################################
#Configuration for slideshow
########################################################################
########################################################################
#Best-if some face is to away from best remove it
CONFIG_BEST="on"
#Factor that gives scale for distance in best
CONFIG_BEST_SCALE=1
########################################################################
#Biggest-if some face is to away from biggest remove it
CONFIG_BIGGEST="on"
#Fator that gives scale for distance in biggest
CONFIG_BIGGEST_SCALE=1
########################################################################
#Small face check
CONFIG_SMALL="off"
#Small face scale
CONFIG_SMALL_SCALE=2
########################################################################
#Center faces only
CONFIG_CENTER="on"
#Scale on/off
CONFIG_CENTER_SCALE_STATE="on"
#Center faces box if scale is off
CONFIG_CENTER_WIDTH=500
CONFIG_CENTER_HEIGHT=100
#Dimension of center box in precentege(size in pix. dep. on image size) 
CONFIG_CENTER_SCALE=70
########################################################################
#Scale of start box this goes in conf directly 
CONFIG_START_BOX_PER="100%"
#Width/Height of start box
CONFIG_START_BOX_WIDTH=
CONFIG_START_BOX_HEIGHT=
#Start location of box (left right center topleft etc. and per)P.S. in 'man dvd-slideshow' 
CONFIG_START_BOX_LOCATION="bottomleft"
#Start location height and Width
CONFIG_START_BOX_LOCATION_WIDTH=
CONFIG_START_BOX_LOCATION_HEIGHT=
########################################################################
#Scale of end box 
CONFIG_END_BOX_PER=80
#Width/Height of end box
CONFIG_END_BOX_WIDTH=
CONFIG_END_BOX_HEIGHT=
########################################################################
#Duration of every slide (s)
CONFIG_DURATION=5
########################################################################
#Effect between pictures/Transitions
CONFIG_TRANSITION="crossfade"    #fadein/out, crossfade, wipe
#Transition durationi (s)
CONFIG_TRANSITION_DURATION=2
########################################################################
#Is realy necessry to get ImageSize for every file
CONFIG_ONCE="yes"
########################################################################
#Default file extesion
CONFIG_DEFAULT_EXTENSION=".JPG"
#Extension by user
CONFIG_EXTENSION=""


#Output file
if [[ "$1" == "" ]]; then 
    conf=slideshow # $1 this would be
else
    conf=$1
fi

touch $conf 

#Extension
if [[ "$2" == "" ]]; then 
    CONFIG_EXTENSION=$CONFIG_DEFAULT_EXTENSION
else
    CONFIG_EXTENSION=$2
fi



#Main for loop proces all files with this extensions TODO($2)
for file in *$CONFIG_EXTENSION; do

    # Do this one time if all files are same size
    if [[ "$CONFIG_ONCE" == "yes" ]];  then
            width=$(exiftool  -s -ImageWidth $file| awk '{print $3}')
            height=$(exiftool  -s -ImageHeight $file|awk '{print $3}')
            once=""	#once is some other var so we dont get into loop
    elif [[ "$CONFIG_ONCE" == "no" ]];  then
            width=$(exiftool  -s -ImageWidth $file| awk '{print $3}')
            height=$(exiftool  -s -ImageHeight $file|awk '{print $3}')
    fi

    #Find if there is any face 
    python2.7 ./facedetect  "$file" | while read x y w h;
    do 
        echo $x $y $w $h >> .tmp-all
    done  

    #test if there is any face at all
    if  (test -e .tmp-all) ; then #Test for file

        python2.7 ./facedetect --best "$file" | while read x y w h;
	do 
	    echo $x >> .tmp-best
            echo $y >> .tmp-best
	    echo $w >> .tmp-best
	    echo $h >> .tmp-best
        done  

        python2.7 ./facedetect --biggest "$file" | while read x y w h;
	do 
	    echo $x >> .tmp-biggest
            echo $y >> .tmp-biggest
	    echo $w >> .tmp-biggest
	    echo $h >> .tmp-biggest
        done  

	#Center
        python2.7 ./facedetect -c --best "$file" | while read x y w h;
	do 
	    echo $x >> .tmp-best-c
            echo $y >> .tmp-best-c
	    echo $w >> .tmp-best-c
	    echo $h >> .tmp-best-c
        done  

        python2.7 ./facedetect -c --biggest "$file" | while read x y w h;
	do 
	    echo $x >> .tmp-biggest-c
            echo $y >> .tmp-biggest-c
	    echo $w >> .tmp-biggest-c
	    echo $h >> .tmp-biggest-c
	done 

	python2.7 ./facedetect -c "$file" | while read x y w h;
	do 
	    echo $x $y $w $h >> .tmp-all-c
        done

    fi

    #Setup what faces we whant -face check 
    if  (test -e .tmp-all) ; then #Test for file

    #If some face is very of scale from --best than ignore it 
    #eg. by  some factor sqrt((x1-x2)^2,(y1-y2)^2) > ImageSize - width(1,2)/2,height(1,2)/2    
    if [[ "$CONFIG_BEST" == "on" ]]; then
	f=.tmp-all-c
	fe=.tmp-all
	lines=$(wc -l $f | awk '{print $1}')
	for (( i=1 ; i<$lines+1 ; i=$i+1 )); do
	    line=$(head -n $i $f | tail -n 1)  #Get line
	    x1=$(echo $line | awk '{print $1}')
	    y1=$(echo $line | awk '{print $2}')
	    x2=$(cat .tmp-best-c | awk '{print $1}')
	    y2=$(cat .tmp-best-c | awk '{print $2}')
	    #Math operations 
	    a1=`echo "$width/2"|bc`
	    a2=`echo "$height/2"|bc`
	    b1=`echo "$a1+$a2"|bc`
	    factor=`echo "$b1*$CONFIG_BEST_SCALE"|bc`
	    #######################################
	    a1=`echo "$x1-$x2"|bc`
	    a2=`echo "$y1-$y2"|bc`
	    b1=`echo "$a1*$a1"|bc`
	    b2=`echo "$a2*$a2"|bc`
	    c1=`echo "$b1+$b2"|bc`
	    distance=`echo "$sqrt(c1)"|bc -l`
	    if (( $distance > $factor  )); then
		let "he=$i-1"
		let "ta=$lines-$i-1"
		touch .tmp
		#now is one line less
		i=$i-1
		lines=$lines-1
		cat $fe | head -n $he >> .tmp
		cat $fe | tail -n $ta >> .tmp
		rm $fe
		mv .tmp $fe
	    fi
	done
    fi

    #If some face is very of scale from --biggest than ignore it 
    #eg. by  some factor sqrt((x1-x2)^2,(y1-y2)^2) > ImageSize - width(1,2)/2,height(1,2)/2    
    if [[ "$CONFIG_BIGGEST" == "on" ]]; then
	f=.tmp-all-c
	fe=.tmp-all
	lines=$(wc -l $f | awk '{print $1}')
	for (( i=1 ; i<$lines+1 ; i=$i+1 )); do
	    line=$(head -n $i $f | tail -n 1)  #Get line
	    x1=$(echo $line | awk '{print $1}')
	    y1=$(echo $line | awk '{print $2}')
	    x2=$(cat .tmp-biggest-c | awk '{print $1}')
	    y2=$(cat .tmp-biggest-c | awk '{print $2}')
	    factor=`echo "($width/2+$height/2)*$CONFIG_BIGGEST_SCALE"|bc`
	    distance=`echo "sqrt(($x1-$x2)*($x1-$x2)+($y1-$y2)*($y1-$y2))"|bc`
	    if (( $distance > $factor  )); then
		let "he=$i-1"
		let "ta=$lines-$i-1"
		touch .tmp
		cat $fe | head -n $he >> .tmp
		cat $fe | tail -n $ta >> .tmp
		#now is one line less
		i=$i-1
		lines=$lines-1
		rm $fe
		mv .tmp $fe
	    fi
	done
    fi

    #if some face is very small ignore it
    #eg. ImageSize/(width,height) >10,9,8... (some my factor) 
    #preferably 2 or some small nuber 3,4 
    if [[ "$CONFIG_SMALL" == "on" ]]; then
	f=.tmp-all
	lines=$(wc -l $f | awk '{print $1}')
	for (( i=1 ; i<$lines+1; i=i+1 )); do
	    line=$(head -n $i $f | tail -n 1)  #Get line
	    w=$(echo $line | awk '{print $3}')
	    h=$(echo $line | awk '{print $4}')
	    scale = `echo "($width/$w+$height/$h)/2" | bc `
	    if (( $scale < $CONFIG_SMALL_SCALE  )); then
		let "he=$i-1"
		let "ta=$lines-$i"
		touch .tmp
		cat $f| head -n $he >> .tmp
		cat $f | tail -n $ta >> .tmp
		#now is one line less
		i=$i-1
		lines=$lines-1
		rm $f
		mv .tmp $f
	    fi
	done
    fi


    #if some face is not in center ignore it
    #eg. define new box ImageSize*??%  start cordinates x=width*??%/2 ...
    if [[ "$CONFIG_CENTER" == "on" ]]; then
	f=.tmp-all-c
	fe=.tmp-all
	lines=$(wc -l $f | awk '{print $1}')

	#Define scale_width/height
	if [[ "$CONFIG_CENTER_SCALE_STATE" == "on" ]]; then 
	    scale_width=$width*$CONFIG_CENTER_SCALE
	    scale_height=$height*$CONFIG_CENTER_SCALE
	else
	    scale_width=$CONFIG_CENTER_WIDTH
	    scale_height=$CONFIG_CENTER_HEIGHT
	fi

	#Define x1/2 and y1/2 start of this center box
	let "x1=($width-$scale_width)/2"
	let "y1=($height-$scale_height)/2"
	let "x2=$x1+$scale_width"
	let "y2=$y1+$scale_height"

	#Iterate trought faces
	for (( i=1 ; i<$lines+1 ; i=$i+1 )); do
	    line=$(head -n $i $f | tail -n 1)  #Get line
	    x=$(echo $line | awk '{print $1}')
	    y=$(echo $line | awk '{print $2}')
	    remove="false"
	    if (( $x<$x1 || $x>$x2 )); then
		remove="true"
	    fi
	    if (( $y<$y1 || $y>$y2 )); then
		remove="true"
	    fi
	    #Remove face
	    if [[ "$remove" == "true" ]]; then
		let "he=$i-1"
		let "ta=$lines-$i"
		touch .tmp
		cat $fe | head -n $he >> .tmp
		cat $fe | tail -n $ta >> .tmp
		#now is one line less
		i=$i-1
		lines=$lines-1
		rm $fe
		cat .tmp
		mv .tmp $fe
	    fi
	done
    fi
    
    #etc..
    fi    #End of .tmp-all and configuratin of boxes

    #End boxes 
    if  (test -e .tmp-all) ; then
	f=.tmp-all
	lines=$(wc -l $f | awk '{print $1}')
	#Start value
	x1=$width
	x2=0
	y1=$height
	y2=0

	#x1
	for (( i=1 ; i<$lines+1 ; i=$i+1 )); do
	    line=$(head -n $i $f | tail -n 1)  #Get line
	    x=$(echo $line | awk '{print $1}')
	    if (( $x < $x1 )); then
		x1=$x
	    fi
	done

	#y1
	for (( i=1 ; i<$lines+1 ; i=$i+1 )); do
	    line=$(head -n $i $f | tail -n 1)  #Get line
	    y=$(echo $line | awk '{print $2}')
	    if (( $y<$y1 )); then
		y1=$y
	    fi
	done

	#x2
	for (( i=1 ; i<$lines+1 ; i=$i+1 )); do
	    line=$(head -n $i $f | tail -n 1)  #Get line
	    x=$(echo $line | awk '{print $1}')
	    w=$(echo $line | awk '{print $3}')
	    let "x=$x+$w"
	    if (( $x>$x2 )); then
		x2=$x
	    fi
	done

	#y2
	for (( i=1 ; i<$lines+1 ; i=$i+1 )); do
	    line=$(head -n $i $f | tail -n 1)  #Get line
	    y=$(echo $line | awk '{print $2}')
	    h=$(echo $line | awk '{print $4}')
	    let "y=$y+$h"
	    if (( $y>$y2 )); then
		y2=$y
	    fi
	done

	w_c=$x2-$x1
	h_c=$y2-$y1
	echo 	$width $height
	#TODO-not need but would be good
	#Box must be square or in other words constrains with picture
	#if (( $w_c/$h_c == $width/$height )); then
	#    c_x=0
	#else
	#    let "c_x=$w_c/2"
	#    let "c_y=$h_c/2"
	#    if (( $w_c < $h_c )); then
    	#	let "h_c=($height/$width)*$w_c"
	#	let "y1=$c_y-$h_c/2"
    	#	let "y2=$c_y+$h_c/2"
	#   else
	#	let "w_c=3*$h_c/2"
	#	let "x1=$c_x-$w_c/2"
	#	let "x2=$c_x+$w_c/2"
	#   fi
	#fi

	#Write it in file
	echo $x1 $y1 $x2 $y2 >> .tmp-end
    fi

    #TODO resize end box * some factor

    #TODO Start box
    
    #TODO add here a chek what is in config ==""
    #	  so we can now what to use
    #Write in config file
    if  (test -e .tmp-end) ; then #Test for file
	slide="$file:$CONFIG_DURATION::kenburns:$CONFIG_START_BOX_PER;$CONFIG_START_BOX_LOCATION;$x1,$y1;$x2,$y2"
	cat .tmp-end >> test
	touch $conf
	echo $slide >> $conf
	echo $CONFIG_TRANSITION:$CONFIG_TRANSITION_DURATION >> $conf
    fi

    # BE sure that tmp is gone
    if  (test -e .tmp-all) ; then #Test for file
        rm .tmp*
    fi
done
