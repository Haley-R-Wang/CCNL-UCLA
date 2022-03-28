#diffusion data preprocess script based on HCP pipeline by Catherine Hegarty, Ph.D.
#developed by Haley R. Wang, M.S., August 2021 (haleywang@ucla.edu)

#!/bin/sh

#LOAD MODULES
. /u/local/Modules/default/init/modules.sh
module load openblas
module use /u/project/CCN/apps/modulefiles
module load fsl/6.0.4
#module load cuda/9.2

export PATH=/u/project/CCN/apps/anaconda/anaconda2/bin:$PATH
export PYTHONPATH=/u/project/CCN/apps/anaconda/anaconda2/lib/python2.7/site-packages
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/u/local/cuda/7.5/lib:/u/local/cuda/7.5/lib64
export FSLDIR=/u/project/CCN/apps/fsl/6.0.4
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

echo "Correcting for Eddy Currents" $shell

#running dir107 data only

eddy --imain=${SUBJ_DIR}/eddy_multishell/${SUBJID}_dMRI_dir107_AP.nii.gz --mask=${SUBJ_DIR}/eddy_multishell/nodif_brain_mask --index=${SUBJ_DIR}/eddy_multishell/index_107.txt --acqp=${SUBJ_DIR}/eddy_multishell/acqparams.txt --bvecs=${SUBJ_DIR}/eddy_multishell/${SUBJID}_dMRI_dir107_AP.bvec --bvals=${SUBJ_DIR}/eddy_multishell/${SUBJID}_dMRI_dir107_AP.bval --fwhm=0 --topup=${SUBJ_DIR}/topup/topup --out=${SUBJ_DIR}/eddy_multishell/eddy_unwarped_images_dir107 --flm=quadratic --data_is_shelled --verbose
