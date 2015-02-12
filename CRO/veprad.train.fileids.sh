#!/bin/bash
x=1
while [ $x -le 9 ]
do
	for file  in /home/mirko/CMUSphinx/wav/VEPRAD/www.inf.uniri.hr/~ivoi/CROSPEECH/podaci/06_02/Muski/m0$x/*.wav
	do 
		PATHNAME=$(echo ${file%%.wav})
		echo $PATHNAME > tmp
		NAME=$(cut -c 27-150 m)
		echo $NAME
		TEXT=$(echo $NAME)
		echo $TEXT >> veprad.train.fileids 
	done
	x=$(( $x + 1 ))
done

y=0
while [ $y -le 1 ]
do
	for file in /home/mirko/CMUSphinx/wav/VEPRAD/www.inf.uniri.hr/~ivoi/CROSPEECH/podaci/06_02/Muski/m1$y/*.wav
	do 
		PATHNAME=$(echo ${file%%.wav})
		echo $PATHNAME > tmp
		NAME=$(cut -c 27-150 m)
		echo $NAME
		TEXT=$(echo  $NAME  )
		echo $TEXT >> veprad.train.fileids 
	done
	y=$(( $y + 1 ))
done

z=1
while [ $z -le 9 ]
do
	for file in /home/mirko/CMUSphinx/wav/VEPRAD/www.inf.uniri.hr/~ivoi/CROSPEECH/podaci/06_02/Zenski/z0$z/*.wav
	do 
		PATHNAME=$(echo ${file%%.wav})
		echo $PATHNAME > tmp
		NAME=$(cut -c 27-150 m)
		echo $NAME
		TEXT=$(echo  $NAME  )
		echo $TEXT >> veprad.train.fileids 
	done
	z=$(( $z + 1 ))
done

d=0
while [ $d -le 1 ]
do
	for file in /home/mirko/CMUSphinx/wav/VEPRAD/www.inf.uniri.hr/~ivoi/CROSPEECH/podaci/06_02/Zenski/z1$d/*.wav
	do 
		PATHNAME=$(echo ${file%%.wav})
		echo $PATHNAME > tmp
		NAME=$(cut -c 27-150 m)
		echo $NAME
		TEXT=$(echo  $NAME  )
		echo $TEXT >> veprad.train.fileids 
	done
	d=$(( $d + 1 ))
done
awk '!/index/' veprad.train.fileids > temp && mv temp veprad.train.fileids 

rm tmp*
