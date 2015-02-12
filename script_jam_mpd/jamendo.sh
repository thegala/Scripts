#!/bin/bash 

#This script is for creation of jamendo database  so mpd can read it
#and in the end ncmcpcpp 
#This is database of artist/ablum/song and radios 

#VARIABLE
#CLIENT_ID="b6747d04&S"
CLIENT_ID="fac3f8fd"
#CLIENT_ID="b6747d04"
DIR=$2
#DIR=/run/media/mirko/DATA/

alias cat=\cat
#First get all posible artists and put them in file artists
#File artists id/name
#Get all artist in one file and save it in artists.tmp in $DIR
lynx -accept_all_cookies -dump "http://api.jamendo.com/v3.0/artists/?client_id=$CLIENT_ID&format=jsonpretty&id=$1" > $DIR/artists.tmp 

cd $DIR
#Extract artist id and name  in this form id ? / name ?
cat artists.tmp | grep "\"id\"" > id
cat artists.tmp | grep "\"name\"" > name
#Clean from dust
cat id | tr -d '"'','		> id.tmp
cat id.tmp | tr -t ':' ' '	> id.1 
cat name | tr -d '"'','		> name.tmp
cat name.tmp | tr -t ':' ' '    > name.1
#Put them in colums first id then name
paste id.1 name.1 > artists

cp name.tmp name
cp id.tmp id
#New artists list without anything just names
cat name | sed 's/name://g' > artists.name
#New artists ... id
cat id | sed 's/id://g' > artists.id

#Count how many artists we have 
NUM_ARTIST=$(wc -l artists.name | awk '{printf $1}')
let NUM_ARTIST=$NUM_ARTIST+1

GET=name 
#Get albums for all artists (by what you whant)
I=1
while [ "$I" != "$NUM_ARTIST" ]; do
    cd $DIR
    ARTIST=$(head -n $I $DIR/artists.$GET | tail -n 1 |  tr -d '\t')
    ARTIST_DIR=$(head -n $I $DIR/artists.$GET | tail -n 1 |  tr -d '\t' | tr -t ' ' '_' | tr -d '\*'| tr -d '/' | tr -d '-' | tr -d '.' | tr -d '-' | tr -d '\\' )
    mkdir $ARTIST_DIR && cd $DIR/$ARTIST_DIR
    #Getting albums names
    lynx -accept_all_cookies -dump "http://api.jamendo.com/v3.0/artists/albums?client_id=$CLIENT_ID&format=jsonpretty&name=$ARTIST&namesearch=" > $ARTIST_DIR"_albums.tmp"

    #Extract artist albums in from of id/name
    cat $ARTIST_DIR"_albums.tmp" | grep "\"id\""	> $ARTIST_DIR"_id.album"
    cat $ARTIST_DIR"_albums.tmp" | grep "\"name\""	> $ARTIST_DIR"_name.album"
    #Clean from dust
    cat $ARTIST_DIR"_id.album" | tr -d '"'','		> $ARTIST_DIR"_id.album.tmp"
    cat $ARTIST_DIR"_id.album.tmp" | tr -t ':' ' '      > $ARTIST_DIR"_id.album.1"
    cat $ARTIST_DIR"_name.album" | tr -d '"'','		> $ARTIST_DIR"_name.album.tmp"
    cat $ARTIST_DIR"_name.album.tmp" | tr -t ':' ' '    > $ARTIST_DIR"_name.album.1"
    #Put them in colums first id then name
    paste $ARTIST_DIR"_id.album.1" $ARTIST"_name.album.1" > albums

    #
    cat $ARTIST_DIR"_id.album.tmp"   | sed 's/id://g'   > "album_"$ARTIST_DIR".id"
    cat $ARTIST_DIR"_name.album.tmp" | sed 's/name://g'	> "album_"$ARTIST_DIR".name"
    
    #Copy artist albums in root dir so its globa and cut artist
    sed '1d' "album_"$ARTIST_DIR"."$GET  > $DIR/"album_"$ARTIST_DIR"."$GET 

    #Count how many albums we have 
    NUM_ALBUMS=$(wc -l "album_"$ARTIST_DIR".name" | awk '{printf $1}')
    let NUM_ALBUMS=$NUM_ALBUMS+1

    #echo "Number of albums "$NUM_ALBUMS

    #Get all tracks for all albums
    Y=1
    while [ "$Y" != "$NUM_ALBUMS" ]; do
	cd $DIR
	ALBUM=$(head -n $Y $DIR"/album_"$ARTIST_DIR"."$GET | tail -n 1 |  tr -d '\t')
	ALBUM_DIR=$(head -n $Y $DIR/"album_"$ARTIST_DIR"."$GET | tail -n 1 | tr -d '\t' | tr -t ' ' '_' | tr -d '/'| tr -d '-' | tr -d '.' | tr -d '-' | tr -d '\\' )
	#echo "NAME OF ALBUM "$ALBUM
        cd "$DIR/"$ARTIST_DIR
	mkdir $ALBUM_DIR
	cd "$DIR/"$ARTIST_DIR"/"$ALBUM_DIR
	lynx -accept_all_cookies -dump "http://api.jamendo.com/v3.0/albums/tracks?client_id=$CLIENT_ID&format=jsonpretty&artist_name=$ARTIST&name=$ALBUM" > tracks.tmp

	cat tracks.tmp | grep "\"id\"" > tracks.id
	cat tracks.tmp | grep "\"name\"" > tracks.name
	cat tracks.tmp | grep "\"audiodownload\"" > tracks.audio
	#
	cat tracks.id | tr -d '"'','		> tracks.id.tmp
	cat tracks.id.tmp | tr -t ':' ' '	> tracks.id.1
	cat tracks.name | tr -d '"'','		> tracks.name.tmp
	cat tracks.name.tmp | tr -t ':' ' '	> tracks.name.1
	cat tracks.audio | tr -d '"'','		> tracks.audio.tmp
	cat tracks.audio.tmp | tr -t ':' ' '	> tracks.audio.1
	#
	paste tracks.id.1 tracks.name.1 tracks.audio.1 > tracks
	
	#
	cat tracks.name.tmp | sed 's/name://g'  > tracks.name.name
	cat tracks.id.tmp   | sed 's/id://g'	> tracks.id.id
	cat tracks.audio.tmp| sed 's/audiodownload://g' | sed 's/http/http/g' | tr -d '\\' > tracks.audio.audio

	#Remove first line it cotains album
	sed '1d' tracks.name.name > tracks.name.name.tmp
	sed '1d' tracks.id.id > tracks.id.id.tmp
	cp tracks.name.name.tmp tracks.name.name
	cp tracks.id.id.tmp tracks.id.id


	#Count how many albums we have 
        NUM_TRACKS=$(wc -l "tracks.name.name"| awk '{printf $1}')
	#Just this way arithemtics 
	let NUM_TRACKS=$NUM_TRACKS+1
	
	#echo "Number of tracks " $NUM_TRACKS

	R=1
	#Put tracks in m3u file so i can lisent
        while [ "$R" != "$NUM_TRACKS" ]; do
	    TRACK=""
	    TRACK=$(head -n $R $DIR"/"$ARTIST_DIR"/"$ALBUM_DIR"/tracks."$GET"."$GET | tail -n 1 | tr -d '\t' | tr -d '\\' | tr -t ' ' '_' | tr -d '/' | tr -d '.' | tr -d '-' | tr -d '\\'  )
	    #echo $TRACK
	    TRACK_AUDIO=""
	    TRACK_AUDIO=$(head -n $R $DIR"/"$ARTIST_DIR"/"$ALBUM_DIR"/tracks.audio.audio" | tail -n 1 | tr -d '\t')
	    touch $TRACK".m3u"
	    #echo $TRACK_AUDIO > $TRACK".m3u"

	    #One down
	    let R=$R+1
	done

	#remove staled cruft
	cd $DIR"/"$ARTIST_DIR"/"$ALBUM_DIR
	rm tracks*
        #One down
	let Y=$Y+1
    done

    #remove staled cruft
    cd $DIR"/"$ARTIST_DIR
    rm *album*
    #One down
    let I=$I+1

done

#remove staled cruft
cd $DIR
rm *album*
