
#!/bin/sh

# Goes through all jpeg files in current directory, grabs date from each
# and sorts them into subdirectories according to the date
# Creates subdirectories corresponding to the dates as necessary.


#JPG
dir=$(pwd)
fil=$dir/$1
    #datepath="$(exiftool -CreateDate IMG_2299.JPG|awk '{print $4}'|sed s%:%/%g)"
    #datepath="$(identify -verbose $fil | grep DateTimeOri | awk '{print $2 }' | sed s%:%/%g)"
    datepath="$(exiftool -CreateDate $fil | awk '{print $4}' | sed s%:%/%g)"
    if ! test -e "$datepath"; then
        mkdir -pv "$datepath"
    fi
    
    if ! test -e "$datepath$fil"; then
        echo "Copy file $fil"
        ln -s $fil $datepath
    else  
        echo "Nothing to do with $fil"
    fi

