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

#Move data from top-level raw directory
cp -r ${HOME_DIR}/${GROUP}/${SUBJID}/unprocessed/Diffusion ${SUBJ_DIR}/raw/.
echo Diffusion data copied to preproc directory
##cp ${HOME_DIR}/${GROUP}/${SUBJID}/unprocessed/T1w_MPR/*T1w_MPR.nii.gz ${SUBJ_DIR}/raw/.
#echo MPRAGE copied to preproc directory

#Change directory to subject
cd ${SUBJ_DIR}

#Extract b0 Maps for Topup, AP_b0 = nodif (as in fsl wiki)
echo "Preparing b0 maps for topup"

#Set data files to choose
#Haley - change or add dir 98/99/107 later
## dir 98
#AP98="_dMRI_dir98_AP.nii.gz"
#PA98="_dMRI_dir98_PA.nii.gz"
#DATA_AP98="${SUBJID}${AP98}"
#DATA_PA98="${SUBJID}${PA98}"
#echo ${DATA}

## dir 107
AP107="_dMRI_dir107_AP.nii.gz"
PA107="_dMRI_dir107_PA.nii.gz"
DATA_AP107="${SUBJID}${AP107}"
DATA_PA107="${SUBJID}${PA107}"
echo ${DATA}

#Ask Katie later - why this is not 0 1 
# change dir
#fslroi ${SUBJ_DIR}/raw/Diffusion/${DATA_AP99} ${SUBJ_DIR}/AP_b0_99dir 0 -1 0 -1 0 -1 0 1  #<xmin> <xsize> <ymin> <ysize> <zmin> <zsize> <tmin> <tsize>
#fslroi ${SUBJ_DIR}/raw/Diffusion/${DATA_PA99} ${SUBJ_DIR}/PA_b0_99dir 0 -1 0 -1 0 -1 0 1

fslroi ${SUBJ_DIR}/raw/Diffusion/${DATA_AP107} ${SUBJ_DIR}/AP_b0_107dir 0 1  #<tmin> <tsize>
fslroi ${SUBJ_DIR}/raw/Diffusion/${DATA_PA107} ${SUBJ_DIR}/PA_b0_107dir 0 1

fslmerge -a ${SUBJ_DIR}/AP_b0_PA_b0_107dir ${SUBJ_DIR}/AP_b0_107dir ${SUBJ_DIR}/PA_b0_107dir
cp ${SUBJ_DIR}/AP_b0_PA_b0_107dir.nii.gz topup/.

#Create Acquisition Parameters File
echo "Creating acquisition parameters file"
echo 0 -1 0 0.0966 >${SUBJ_DIR}/topup/acqparams.txt
echo 0 1 0 0.0966 >>${SUBJ_DIR}/topup/acqparams.txt #C4 = 1 x 10^(-3) x echo spacing x EPI factor = 0.001 x 0.69 x 140 = 0.0966 based dir107 protocol page

echo "acqparams file created"

#Run Topup
topup --imain=${SUBJ_DIR}/topup/AP_b0_PA_b0_107dir --datain=${SUBJ_DIR}/topup/acqparams.txt --config=$FSLDIR/etc/flirtsch/b02b0.cnf --out=${SUBJ_DIR}/topup/topup --iout=${SUBJ_DIR}/topup/b0_unwarped --fout=${SUBJ_DIR}/topup/fieldmap_Hz -v

#Create a binary brain mask for Eddy Current Correction
fslmaths ${SUBJ_DIR}/topup/b0_unwarped -Tmean ${SUBJ_DIR}/topup/b0_unwarped_mean # b0_unwarped nii??
bet ${SUBJ_DIR}/topup/b0_unwarped_mean ${SUBJ_DIR}/topup/b0_unwarped_brain -m -f 0.3 -R  # may require param adjustment

echo "BET completed"

#Create Index Files for multishell data
#echo "Creating index file 98 for multishell data"
#for ((i=0; i<99; ++i)); do #99 is the volume number of nifti file dir98 (fslhd dim4)
#	indx2="$indx2 1";
#done
#echo $indx2 > ${SUBJ_DIR}/eddy_multishell/index_98.txt

#echo "Creating index file 99 for multishell data"
#for ((i=0; i<100; ++i)); do #100 is the volume number of nifti file dir99
#	indx3="$indx3 1";
#done
#echo $indx3 > ${SUBJ_DIR}/eddy_multishell/index_99.txt

echo "Creating index file 107 for multishell data"
for ((i=0; i<108; ++i)); do #108 is the volume number of nifti file dir107
	indx4="$indx4 1";
done
echo $indx4 > ${SUBJ_DIR}/eddy_multishell/index_107.txt


#Copy files to Eddy directory
cp ${SUBJ_DIR}/topup/b0_unwarped_brain_mask.nii.gz ${SUBJ_DIR}/eddy_multishell/nodif_brain_mask.nii.gz
cp ${SUBJ_DIR}/topup/acqparams.txt ${SUBJ_DIR}/eddy_multishell/.
cp ${SUBJ_DIR}/raw/Diffusion/*_AP.b* ${SUBJ_DIR}/eddy_multishell/. #cp bval and bvec
cp ${SUBJ_DIR}/raw/Diffusion/*_AP.nii* ${SUBJ_DIR}/eddy_multishell/. #cp nii.gz

cd ${SUBJ_DIR}/eddy_multishell
chmod 755 index* *dMRI* acqparams* nodif*

echo "Finished prepping for Eddy Current Correction"

# all good till here~!~!~!~

# call the second pipeline script - 02_eddy_cuda.sh

##Run Eddy Current Correction on Multishell Data
#echo "Summoning next pipeline script (02_eddy_cud)"
#cd ${HOME_DIR}/scripts
#qsub 02_eddy_cuda.sh.cmd ${GROUP} ${SUBJID}
#echo "Finished running Eddy Current Correction"




























