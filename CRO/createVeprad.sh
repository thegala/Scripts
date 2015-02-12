#!/bin/bash

x=1
while [ $x -le 9 ]
do
	for file  in /home/mirko/CMUSphinx/wav/VEPRAD/www.inf.uniri.hr/~ivoi/CROSPEECH/podaci/tekst/06_02/Muski/m0$x/*.txt
	do 
		PATHNAME=$(echo ${file%%.txt})
		echo $PATHNAME > m
		NAME=$(cut -c 96-150 m)
		echo $NAME
		NAMETXT=$(echo $PATHNAME".txt" )
		echo $NAMETXT
		CAT1=$(cat $NAMETXT)
		echo $CAT1 > M1
		tr  '[:lower:]'  '[:upper:]' < M1 > f.txt
		CAT=$(cat f.txt )
		TEXT=$(echo "<s>" $CAT "</s>" "("$NAME")" )
		echo $TEXT >> veprad.transcription 
	done
	x=$(( $x + 1 ))
done

y=0
while [ $y -le 1 ]
do
	for file in /home/mirko/CMUSphinx/wav/VEPRAD/www.inf.uniri.hr/~ivoi/CROSPEECH/podaci/tekst/06_02/Muski/m1$y/*.txt
	do 
		PATHNAME=$(echo ${file%%.txt})
		echo $PATHNAME > m
		NAME=$(cut -c 96-150 m)
		echo $NAME
		NAMETXT=$(echo $PATHNAME".txt" )
		echo $NAMETXT
		CAT1=$(cat $NAMETXT)
		echo $CAT1 > M1
		tr  '[:lower:]'  '[:upper:]' < M1 > f.txt
		CAT=$(cat f.txt )
		TEXT=$(echo "<s>" $CAT "</s>" "("$NAME")" )
		echo $TEXT >> veprad.transcription 
	done
	y=$(( $y + 1 ))
done

z=1
while [ $z -le 9 ]
do
	for file in /home/mirko/CMUSphinx/wav/VEPRAD/www.inf.uniri.hr/~ivoi/CROSPEECH/podaci/tekst/06_02/Zenski/z0$z/*.txt
	do 
		PATHNAME=$(echo ${file%%.txt})
		echo $PATHNAME > m
		NAME=$(cut -c 97-150 m)
		echo $NAME
		NAMETXT=$(echo $PATHNAME".txt" )
		echo $NAMETXT
		CAT1=$(cat $NAMETXT)
		echo $CAT1 > M1
		tr  '[:lower:]'  '[:upper:]' < M1 > f.txt
		CAT=$(cat f.txt )
		TEXT=$(echo "<s>" $CAT "</s>" "("$NAME")" )
		echo $TEXT >> veprad.transcription 
	done
	z=$(( $z + 1 ))
done

d=0
while [ $d -le 1 ]
do
	for file in /home/mirko/CMUSphinx/wav/VEPRAD/www.inf.uniri.hr/~ivoi/CROSPEECH/podaci/tekst/06_02/Zenski/z1$d/*.txt
	do 
		PATHNAME=$(echo ${file%%.txt})
		echo $PATHNAME > m
		NAME=$(cut -c 97-150 m)
		echo $NAME
		NAMETXT=$(echo $PATHNAME".txt" )
		echo $NAMETXT
		CAT1=$(cat $NAMETXT)
		echo $CAT1 > M1
		tr  '[:lower:]'  '[:upper:]' < M1 > f.txt
		CAT=$(cat f.txt )
		TEXT=$(echo "<s>" $CAT "</s>" "("$NAME")" )
		echo $TEXT >> veprad.transcription 
	done
	d=$(( $d + 1 ))
done

awk '!/TITLE/' CRO_train.transcription  > temp && mv temp CRO_train.transcription
