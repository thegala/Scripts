#!/bin/bash
files=$#
count=1
message=`echo "Converting $files RAW files to Jpeg"`

while [ $# -gt 0 ]; do

        # Strip off the file extension, including the "."
        upperExt=`echo $1 | sed 's/.*\(\..*\)/\1/' | tr '[a-z]' '[A-Z]'`

        if [ -f "$1" ]
        then
                # Get the file name without the extension
                trimmed=`echo $1 | sed 's/\(.*\)\..*/\1/'`

                if [ $upperExt = ".PPM" -o $upperExt = ".CR2" -o $upperExt = ".NEF" -o $upperExt = ".ORF" ]
                then
                        if [ $upperExt = ".PPM" ]
                        then
                                # Convert the PPM image to a Jpeg
                                pnmtojpeg "$1" > "$trimmed.jpg"
                        else
                                # Convert the RAW image to a Jpeg
                                dcraw -c -w -h -b 1.0 "$1" | pnmtojpeg > "$trimmed.jpg"
                        fi
                        # Copy EXIF data to the new Jpeg image
                        exiftool -overwrite_original -TagsFromFile "$1" "$trimmed.jpg" >/dev/null

                        # Set the Jpeg's file timestamp to match the EXIF date
                        dcraw -z "$trimmed.jpg"
                fi
        fi
        # Output the zenity progress bar
        sav=`echo "(($count / $files) * 100)" | bc -l`
        echo $sav
        count=`expr $count + 1`
shift
done  
