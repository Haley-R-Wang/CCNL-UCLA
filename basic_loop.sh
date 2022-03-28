###Set variables here###

#Set Directory Paths
GROUP=$2 #e.g., AP, NAP, control
HOME_DIR=/u/project/kkarlsgo/data/HCP/HCP_EOP/imagingcollection01/${GROUP}

echo ${HOME_DIR}
cd ${HOME_DIR}

if [ $1 = 'all' ]; then 
subjlist=`ls -1d *`
else 
subjlist=$1 #e.g., 1001_01_MR
fi



# this script only uses loop to make folders

#echo Script will run the following subjects in group ${group}:
echo $subjlist
#echo

  for SUBJID in $subjlist; do
      echo starting ${SUBJID}
      SUBJ_DIR=${HOME_DIR}/${SUBJID}/Diffusion_preproc
      echo ${SUBJ_DIR} 
      
      #Change directory to subject
	if [ ! -d "${SUBJ_DIR}" ]; then
		mkdir ${SUBJ_DIR}
	fi

	cd ${SUBJ_DIR}
      
      #Create subdirectories for the subject
	for dir in raw topup dtifit eddy_multishell; do
	if [ ! -d "${SUBJ_DIR}/${dir}" ]; then
		mkdir ${SUBJ_DIR}/${dir}
	fi
	done  
   done
