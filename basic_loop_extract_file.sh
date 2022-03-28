GROUP=$2 #e.g., AP, NAP, control
HOME_DIR=/u/project/kkarlsgo/data/HCP/HCP_EOP/imagingcollection01/${GROUP}

echo ${HOME_DIR}
cd ${HOME_DIR}

if [ $1 = 'all' ]; then 
subjlist=`ls -1d *`
else 
subjlist=$1 #e.g., 1001_01_MR
fi



# this script only uses loop to copy files

#echo Script will run the following subjects in group ${group}:
echo $subjlist
#echo

  for SUBJID in $subjlist; do
      echo starting ${SUBJID}
      SUBJ_DIR=${HOME_DIR}/${SUBJID}/Diffusion_preproc
      echo ${SUBJ_DIR} 
      cd ${SUBJ_DIR}


      #Copy eddy unwarp image to src folder
	if [ -f "${SUBJ_DIR}/eddy_multishell/eddy_unwarped_images_dir107.nii.gz" ]; then
		cp ${SUBJ_DIR}/eddy_multishell/eddy_unwarped_images_dir107.nii.gz /u/project/CCN/kkarlsgo/data/HCP/HCP_EOP/imagingcollection01/analysis/qc_src/${GROUP}
		mv /u/project/CCN/kkarlsgo/data/HCP/HCP_EOP/imagingcollection01/analysis/qc_src/${GROUP}/eddy_unwarped_images_dir107.nii.gz /u/project/CCN/kkarlsgo/data/HCP/HCP_EOP/imagingcollection01/analysis/qc_src/${GROUP}/${SUBJID}_dMRI_dir107_AP.nii.gz

		cp ${SUBJ_DIR}/eddy_multishell/${SUBJID}_dMRI_dir107_AP.bval /u/project/CCN/kkarlsgo/data/HCP/HCP_EOP/imagingcollection01/analysis/qc_src/${GROUP}

		cp ${SUBJ_DIR}/eddy_multishell/${SUBJID}_dMRI_dir107_AP.bvec /u/project/CCN/kkarlsgo/data/HCP/HCP_EOP/imagingcollection01/analysis/qc_src/${GROUP}

		echo finished copy eddy image of ${SUBJID}
	fi	
   done
