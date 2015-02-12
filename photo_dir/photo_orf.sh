
#!/bin/sh

# Goes through all jpeg files in current directory, grabs date from each
# and sorts them into subdirectories according to the date
# Creates subdirectories corresponding to the dates as necessary.


# ORF 
dir=$(pwd)
fil=$dir/$1
#echo $fil
    #datepath="$(exiftool -CreateDate IMG_2299.JPG|awk '{print $4}'|sed s%:%/%g)"
    datemonth="$(dcraw  -i -v $fil  | grep  Timestamp | awk '{print $3}')"
    
    if [[ "$datemonth" == "Jan" ]]; then
        month=01
    elif [[ "$datemonth" == "Feb" ]]; then 
        month=02
    elif [[ "$datemonth" == "Mar" ]]; then 
        month=03
    elif [[ "$datemonth" == "Apr" ]]; then 
        month=04
    elif [[ "$datemonth" == "May" ]]; then 
        month=05
    elif [[ "$datemonth" == "Jun" ]]; then 
        month=06
    elif [[ "$datemonth" == "Jul" ]]; then 
        month=07
    elif [[ "$datemonth" == "Aug" ]]; then 
        month=08
    elif [[ "$datemonth" == "Sep" ]]; then 
        month=09
    elif [[ "$datemonth" == "Oct" ]]; then 
        month=10
    elif [[ "$datemonth" == "Nov" ]]; then 
        month=11
    elif [[ "$datemonth" == "Dec" ]]; then 
        month=12
    fi 

    date1="$(dcraw  -i -v $fil  | grep  Timestamp | awk '{print $6}')"
    date2="$(dcraw  -i -v $fil  | grep  Timestamp | awk '{print $4}')"

    datepath=$date1"/"$month"/"$date2

    if ! test -e "$datepath"; then
        mkdir -pv "$datepath"
    fi
    
    if ! test -e "$datepath$fil"; then
	echo "Coping file $fil"
        ln -s $fil $datepath
    else  
        echo "Nothing to do with $fil"
    fi

