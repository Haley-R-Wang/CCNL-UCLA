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

cd ${HOME_DIR}/subj_list

#Build QUAD folder list txt for a subset list
if [ $1 = 'control' ]; then 
	awk '{ print "/u/project/CCN/kkarlsgo/data/HCP/HCP_EOP/imagingcollection01/control/",$0, "_01_MR/Diffusion_preproc/QUAD/eddy_unwarped_images_dir107.qc"}' HC_subj.txt > temp.txt
	sed 's/ //g' temp.txt > qc_folders_HC.txt
	chmod 777 *
	echo "QUAD folder list created for" $1
else
	if [ $1 = 'AP' ]; then 
		awk '{ print "/u/project/CCN/kkarlsgo/data/HCP/HCP_EOP/imagingcollection01/AP/",$0, "_01_MR/Diffusion_preproc/QUAD/eddy_unwarped_images_dir107.qc"}' AP_subj.txt > temp.txt
		sed 's/ //g' temp.txt > qc_folders_AP.txt
		chmod 777 *
		echo "QUAD folder list created for" $1
	else
		if [ $1 = 'NAP' ]; then 
			awk '{ print "/u/project/CCN/kkarlsgo/data/HCP/HCP_EOP/imagingcollection01/NAP/",$0, "_01_MR/Diffusion_preproc/QUAD/eddy_unwarped_images_dir107.qc"}' NAP_subj.txt > temp.txt
			sed 's/ //g' temp.txt > qc_folders_NAP.txt
			chmod 777 *
			echo "QUAD folder list created for" $1
		else
			echo "wrong subject list" ##maybe try all?
		fi
	fi
fi

#cd ${HOME_DIR}/scripts
#rm -r ./squad

##Create subdirectories for the subject
#for dir in SQUAD; do
#if [ ! -d "${SUBJ_DIR}/${dir}" ]; then
#	mkdir ${SUBJ_DIR}/${dir}
#fi
#done

echo "Running Eddy SQUAD for Eddy QUAD"

#QCing dir107 data only
eddy_squad ${HOME_DIR}/subj_list/qc_folders_HC.txt #remember to change this
#-o ${HOME_DIR}/scripts/SQUAD_control

echo "Done~~~~!"
