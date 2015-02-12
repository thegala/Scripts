
#!/bin/sh

# Goes through all jpeg files in current directory, grabs date from each
# and sorts them into subdirectories according to the date
# Creates subdirectories corresponding to the dates as necessary.

# ORF 
#for f in $(find . -name '*.ORF'); do sh ./photo_jpg.sh  $f ; done
for f in $(find . -name '*.ORF'); do sh ./photo_orf.sh  $f ; done   #FASTER METHOD

#JPG
#for f in $(find . -name '*.JPG' -or -name '*.jpg'); do sh ./photo_jpg.sh $f ; done

