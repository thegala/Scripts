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
		echo $CAT1 > tmp
		tr  '[:lower:]'  '[:upper:]' < tmp > tmp2
		CAT=$(cat tmp2 )
		TEXT=$(echo "<s>" $CAT "</s>"  )
		echo $TEXT >> veprad
	done
	x=$(( $x + 1 ))
done

y=0
while [ $y -le 1 ]
do
	for file in /home/mirko/CMUSphinx/wav/VEPRAD/www.inf.uniri.hr/~ivoi/CROSPEECH/podaci/tekst/06_02/Muski/tmp$y/*.txt
	do 
		PATHNAME=$(echo ${file%%.txt})
		echo $PATHNAME > m
		NAME=$(cut -c 96-150 m)
		echo $NAME
		NAMETXT=$(echo $PATHNAME".txt" )
		echo $NAMETXT
		CAT1=$(cat $NAMETXT)
		echo $CAT1 > tmp
		tr  '[:lower:]'  '[:upper:]' < tmp > tmp2
		CAT=$(cat tmp2 )
		TEXT=$(echo "<s>" $CAT "</s>"  )
		echo $TEXT >> veprad
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
		echo $CAT1 > tmp
		tr  '[:lower:]'  '[:upper:]' < tmp > tmp2
		CAT=$(cat tmp2 )
		TEXT=$(echo "<s>" $CAT "</s>"  )
		echo $TEXT >> veprad
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
		echo $CAT1 > tmp
		tr  '[:lower:]'  '[:upper:]' < tmp > tmp2
		CAT=$(cat tmp2 )
		TEXT=$(echo "<s>" $CAT "</s>"  )
		echo $TEXT >> veprad
	done
	d=$(( $d + 1 ))
done

rm tmp*
