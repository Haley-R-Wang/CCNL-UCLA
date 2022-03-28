#!/bin/sh
#This script organizes participants FA into a single directory for TBSS analyses
#For HCP, this will have to be run 3 time, once for each group
#diffusion data TBSS prep script based on HCP pipeline
#developed by Haley R. Wang, M.S., September 2021 (haleywang@ucla.edu)

#Set Directory Paths
#Haley: change before sealing the code
HOME_DIR=/u/project/kkarlsgo/data/HCP/HCP_EOP/imagingcollection01

readarray -t subjlist < /u/project/CCN/kkarlsgo/data/HCP/HCP_EOP/imagingcollection01/subj_list/HC_subj.txt ###change this to run for different groups
#readarray -t SUBJID < all_subjects.txt
#SUBJ_LIST=`awk '{ print $1 }' all_subjects.txt`

#echo $SUBJ_ID

#change directory
cd $HOME_DIR

#For each subject in every group, copy FA and place it in FA folder
echo "Looping through subjects.."
for SUBJid in ${subjlist[@]}; do
        #ls
        SUBJID=${SUBJid}_01_MR
	for GROUP in control AP NAP; do

		if [[ -d "$HOME_DIR/control/$SUBJID" ]]; then
		
			cp $HOME_DIR/$GROUP/$SUBJID/Diffusion_preproc/dtifit/DFIT_${SUBJID}_FA.nii.gz $HOME_DIR/analysis/tbss/${GROUP}_${SUBJID}_FA.nii.gz
		fi

		if [[ -d "$HOME_DIR/AP/$SUBJID" ]]; then 
			cp $HOME_DIR/$GROUP/$SUBJID/Diffusion_preproc/dtifit/DFIT_${SUBJID}_FA.nii.gz $HOME_DIR/analysis/tbss/${GROUP}_${SUBJID}_FA.nii.gz
		fi

		if [[ -d "$HOME_DIR/NAP/$SUBJID" ]]; then 
			cp $HOME_DIR/$GROUP/$SUBJID/Diffusion_preproc/dtifit/DFIT_${SUBJID}_FA.nii.gz $HOME_DIR/analysis/tbss/${GROUP}_${SUBJID}_FA.nii.gz
		fi

	done
done 
echo "Done~~~~!"

