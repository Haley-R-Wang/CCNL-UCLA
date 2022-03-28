#diffusion data dtifit script based on HCP pipeline by Catherine Hegarty, Ph.D.
#developed by Haley R. Wang, M.S., September 2021 (haleywang@ucla.edu)


#!/bin/sh
#Use this script to preprocess diffusion data - DTIFIT to derive FA maps
#Assumes that raw dicom images are organized in
#${HCP_DIR}/${STUDY}/${GROUP}${SUBJID}/T1w/raw/${AP_DIR}, ${PA_b0_DIR}

#LOAD MODULES
. /u/local/Modules/default/init/modules.sh
#module load openblas
module use /u/project/CCN/apps/modulefiles
module load fsl/6.0.4
module load cuda/9.1


export PATH=/u/project/CCN/apps/anaconda/anaconda2/bin:$PATH
export PYTHONPATH=/u/project/CCN/apps/anaconda/anaconda2/lib/python2.7/site-packages
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/u/local/cuda/9.1/lib64
export FSLDIR=/u/project/CCN/apps/fsl/rh7/6.0.4
. ${FSLDIR}/etc/fslconf/fsl.sh

#Set Directory Paths
#Haley: change before sealing the code
HOME_DIR=/u/project/kkarlsgo/data/HCP/HCP_EOP/imagingcollection01

#Argument Inputs
GROUP=${1}   #e.g., AP, NAP, control
SUBJID=${2}  #e.g., 1001_01_MR
SUBJ_DIR=${HOME_DIR}/${GROUP}/${SUBJID}/Diffusion_preproc

#Change directory to subject
cd ${SUBJ_DIR}

#Prep files for DTIFIT
echo "Organizing files for DTIFit"
cp ${SUBJ_DIR}/eddy_multishell/*dir107_AP*.bvec ${SUBJ_DIR}/dtifit/${SUBJID}_dMRI_dir107_AP.bvec #cp both bvec and bval
cp ${SUBJ_DIR}/eddy_multishell/*dir107_AP*.bval ${SUBJ_DIR}/dtifit/${SUBJID}_dMRI_dir107_AP.bval
cp ${SUBJ_DIR}/eddy_multishell/nodif_brain_mask.nii.gz ${SUBJ_DIR}/dtifit/.
cp ${SUBJ_DIR}/eddy_multishell/eddy_unwarped_images_dir107*.nii.gz ${SUBJ_DIR}/dtifit/eddy_unwarped_images_dir107.nii.gz

#Run DTIFIT (for dir107 only)
echo "Running DTIFit"

dtifit --data=${SUBJ_DIR}/dtifit/eddy_unwarped_images_dir107.nii.gz --out=${SUBJ_DIR}/dtifit/DFIT_${SUBJID} --save_tensor --mask=${SUBJ_DIR}/dtifit/nodif_brain_mask.nii.gz --bvecs=${SUBJ_DIR}/dtifit/${SUBJID}_dMRI_dir107_AP.bvec --bvals=${SUBJ_DIR}/dtifit/${SUBJID}_dMRI_dir107_AP.bval

echo "Finished DTIFit for Subject ${SUBJID}"

