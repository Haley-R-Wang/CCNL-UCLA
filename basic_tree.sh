#developed by Haley R. Wang, M.S., May 2021 (haleywang@ucla.edu)

#!/bin/sh
#Use this script to grab the tree structure.
#This command works to display both folders and files.

GROUP=$2 #e.g., AP, NAP, control
HOME_DIR=/u/project/kkarlsgo/data/HCP/HCP_EOP/imagingcollection01/${GROUP}

echo ${HOME_DIR}
cd ${HOME_DIR}

if [ $1 = 'all' ]; then 
subjlist=`ls -1d *`
else 
subjlist=$1 #e.g., 1001_01_MR
fi


for SUBJID in $subjlist; do
	echo Logging ${SUBJID}
	find ./${SUBJID}/unprocessed/Diffusion/ | sed -e "s/[^-][^\/]*\// |/g" -e "s/|\([^ ]\)/|-\1/" >> tree.txt #change file name
done
