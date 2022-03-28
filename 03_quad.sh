#diffusion data preprocess script based on HCP pipeline by Catherine Hegarty, Ph.D.
#developed by Haley R. Wang, M.S., Sept 2021 (haleywang@ucla.edu)

#!/bin/sh

#LOAD MODULES
. /u/local/Modules/default/init/modules.sh
module load openblas
module use /u/project/CCN/apps/modulefiles
module load fsl/6.0.4

export FSLDIR=/u/project/CCN/apps/fsl/rh7/6.0.4
. ${FSLDIR}/etc/fslconf/fsl.sh

#Set Directory Paths
#Haley: change before sealing the code
HOME_DIR=/u/project/kkarlsgo/data/HCP/HCP_EOP/imagingcollection01

#Argument Inputs
GROUP=${1}   #e.g., AP, NAP, control
SUBJID=${2}  #e.g., 1001_01_MR
SUBJ_DIR=${HOME_DIR}/${GROUP}/${SUBJID}/Diffusion_preproc  #dir created below (l.29)

cd ${SUBJ_DIR}

#Create subdirectories for the subject
for dir in QUAD; do
if [ ! -d "${SUBJ_DIR}/${dir}" ]; then
	mkdir ${SUBJ_DIR}/${dir}
fi
done

echo "Running QUAD for Eddy Current Correction Quality Assessment"

#QCing dir107 data only
eddy_quad ${SUBJ_DIR}/eddy_multishell/eddy_unwarped_images_dir107 -idx ${SUBJ_DIR}/eddy_multishell/index_107.txt -par ${SUBJ_DIR}/eddy_multishell/acqparams.txt -m ${SUBJ_DIR}/eddy_multishell/nodif_brain_mask -b ${SUBJ_DIR}/eddy_multishell/${SUBJID}_dMRI_dir107_AP.bval -f ${SUBJ_DIR}/topup/fieldmap_Hz.nii.gz --verbose

mv ${SUBJ_DIR}/eddy_multishell/eddy_unwarped_images_dir107.qc ${SUBJ_DIR}/QUAD/.

echo "Done~~~~!"

exit 0
