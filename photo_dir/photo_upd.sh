#!/bin/bash
time 
sh ./photo_difflist.sh
sh ./photo_list_upd.sh /media/RAIDVOL2/A_foto/diff_list 
#rsync -av /media/RAIDVOL2/A_foto/2*
#rsync -av /media/RAIDVOL2/A_foto/1* /media/RAIDVOL2/A_foto_date/
#rsync -av /media/RAIDVOL2/A_foto/0* /media/RAIDVOL2/A_foto_date/
echo "Update of photo_date base is over "
echo "Now copy them or synchronize with "
