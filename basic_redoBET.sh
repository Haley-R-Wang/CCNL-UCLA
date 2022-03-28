#diffusion data preprocess script based on HCP pipeline by Catherine Hegarty, Ph.D.
#developed by Haley R. Wang, M.S., May 2021 (haleywang@ucla.edu)

#!/bin/sh
#Use this script to preprocess diffusion data
#Assumes that raw dicom images are organized in
#${HCP_DIR}/${GROUP}/${SUBJID}/T1w/raw/${AP_DIR}, ${PA_b0_DIR}

#SET UP ENVIRONMENTAL VARIABLES

. /u/local/Modules/default/init/modules.sh
module use /u/project/CCN/apps/modulefiles
module load mricron
module load fsl/6.0.4
module load cuda

#Set Directory Paths
#Haley: change before sealing the code
HOME_DIR=/u/project/kkarlsgo/data/HCP/HCP_EOP/imagingcollection01

#Argument Inputs
GROUP=${1}   #e.g., AP, NAP, control
SUBJID=${2}  #e.g., 1001_01_MR
SUBJ_DIR=${HOME_DIR}/${GROUP}/${SUBJID}/Diffusion_preproc  #dir created below (l.29)

echo ${SUBJ_DIR} 

cd ${SUBJ_DIR}

bet ${SUBJ_DIR}/topup/b0_unwarped_mean ${SUBJ_DIR}/topup/b0_unwarped_brain_02 -m -f 0.16 -R # may require param adjustment

echo "BET completed"
