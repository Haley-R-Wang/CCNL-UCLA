#diffusion dtifit QC script based on MEND pipeline by Katie Karlsgodt, Ph.D.
#developed by Haley R. Wang, M.S., September 2021 (haleywang@ucla.edu)


#!/bin/sh
#This script creates files to be used for DTI quality control,in accordance with the Tournier, 2011 paper and the methods from the Thompson lab.

USAGE="
 
	 DTI QUALITY CONTROL
	
	
	 This script takes three arguments:
            	 1. subjectgroup
            	 2. subjectid/all                
	 
	 Example: 05_QC_dtifit_basic.sh control 1001_01_MR
	 	  05_QC_dtifit_basic.sh NAP all
         
        
"

if [ $# -eq 0 ]
then
  echo "$USAGE"
  exit
fi

#Set Directory Paths
#Haley: change before sealing the code
HOME_DIR=/u/project/kkarlsgo/data/HCP/HCP_EOP/imagingcollection01

#Argument Inputs
GROUP=${1}   #e.g., AP, NAP, control

cd ${HOME_DIR}/${GROUP}

if [ $2 = 'all' ]; then 
SUBJ_list=`ls -1d *`
else 
SUBJ_list=${2}  #e.g., 1001_01_MR
fi

for SUBJID in $SUBJ_list; do
	#Change directory to subject
	SUBJ_DIR=${HOME_DIR}/${GROUP}/${SUBJID}/Diffusion_preproc
	cd ${SUBJ_DIR}

	echo "Starting DTIfit QC for ${SUBJID}"
      
	cd ${SUBJ_DIR}/dtifit/

	if [ -f ${SUBJID}_dtifit_dir107_report.txt ]; then rm ${SUBJID}_dtifit_dir107_report.txt; fi

	echo "DTI Report for" ${SUBJID}  >> ${SUBJ_DIR}/dtifit/${SUBJID}_dtifit_dir107_report.txt
    
	#calculate mean in mask MD
	echo calculating mean MD
	mean_MD=`fslstats DFIT_${SUBJID}_MD.nii.gz -M`
	echo Mean MD in mask:   ${mean_MD} >> ${SUBJ_DIR}/dtifit/${SUBJID}_dtifit_dir107_report.txt
      
	#calculate mean in mask FA
	echo calculating mean FA
	mean_FA=`fslstats DFIT_${SUBJID}_FA.nii.gz -M`
	echo Mean FA in mask:   ${mean_FA} >> ${SUBJ_DIR}/dtifit/${SUBJID}_dtifit_dir107_report.txt
 

	echo 1 $SUBJID
	echo 2 $mean_MD
	echo 3 $mean_FA

	echo $SUBJID $mean_MD $mean_FA  > ${HOME_DIR}/analysis/HCP_EOP_${GROUP}_${SUBJID}.txt

done

cd ${HOME_DIR}/analysis

if [ -f ${GROUP}_dtifit_dir107_report_summary.txt ]; then rm ${GROUP}_dtifit_dir107_report_summary.txt; fi
cat HCP_EOP_${GROUP}_*.txt > ${GROUP}_dtifit_dir107_report_summary.txt

echo "All done!"
