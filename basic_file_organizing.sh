###Set variables here###
# this script only uses loop to remove folders

#Set Directory Paths
GROUP=$1 #e.g., AP, NAP, control
HOME_DIR=/u/project/kkarlsgo/data/HCP/HCP_EOP/imagingcollection01/${GROUP}

echo ${HOME_DIR}
cd ${HOME_DIR}


## for all subj
#if [ $2 = 'all' ]; then 
#subjlist=`ls -1d *`
#else 
#subjlist=$2 #e.g., 1001_01_MR
#fi

##echo Script will run the following subjects in group ${group}:
#echo $subjlist

## for all subj
#for SUBJID in $subjlist; do
#	echo "Organizing files for" ${SUBJID}
#     	SUBJ_DIR=${HOME_DIR}/${SUBJID}
#    	cd ${SUBJ_DIR} 
      
#      #rm previously created Diffusion_preproc folder for data analysis
#	rm -r Diffusion_preproc/
#done




# for a subset list
if [ $2 = 'list' ]; then 
	readarray -t subjlist < /u/project/CCN/kkarlsgo/data/HCP/HCP_EOP/imagingcollection01/subj_list/NAP_subj_list_unix.txt
	echo ${subjlist[@]}
else
	subjlist=$2 #e.g., 1001_01_MR
fi

for SUBJID in "${subjlist[@]}"; do
	echo "Organizing files for" ${SUBJID}
      	SUBJ_DIR=${HOME_DIR}/${SUBJID}
      	cd ${SUBJ_DIR} 
      
      #rm previously created Diffusion_preproc folder for data analysis
	rm -r Diffusion_preproc/dtifit/
	mkdir Diffusion_preproc/dtifit
	#rm -r Diffusion_preproc/QUAD/
done

echo "All done!"
