#developed by Haley R. Wang, M.S., Jan 2022 (haleywang@ucla.edu)

# example usage: 
#1) ./basic_check_eddy_output.sh 1001_01_MR jobid 
#2) ./basic_check_eddy_output.sh control jobid 
#The script takes arguments of "cntrol"/"AP"/"NAP"

#!/bin/sh
#Use this script to grab the tree structure.
#This command works to display both folders and files.

JOBID=$2 
#HOME_DIR=/u/project/kkarlsgo/data/HCP/HCP_EOP/imagingcollection01/${GROUP}

#echo ${HOME_DIR}
#cd ${HOME_DIR}


# for a subset list
if [ $1 = 'control' ]; then 
	readarray -t subjlist < /u/project/CCN/kkarlsgo/data/HCP/HCP_EOP/imagingcollection01/subj_list/HC_subj_list_unix.txt
else
	if [ $1 = 'AP' ]; then 
		readarray -t subjlist < /u/project/CCN/kkarlsgo/data/HCP/HCP_EOP/imagingcollection01/subj_list/AP_subj_list_unix.txt
	else
		if [ $1 = 'NAP' ]; then 
			readarray -t subjlist < /u/project/CCN/kkarlsgo/data/HCP/HCP_EOP/imagingcollection01/subj_list/NAP_subj_list_unix.txt
		else
			subjlist=$1 #e.g., 1001_01_MR
		fi
	fi
fi

for SUBJID in "${subjlist[@]}"; do
	echo "Checking eddy output for" ${SUBJID}
      	cd /u/project/CCN/kkarlsgo/data/HCP/HCP_EOP/imagingcollection01/scripts/

	Joblog=$(ls joblog.${JOBID}*)
	echo ${Joblog}\ | tr " " "\n" > temp_jobloglist.txt
	readarray -t joblog < /u/project/CCN/kkarlsgo/data/HCP/HCP_EOP/imagingcollection01/scripts/temp_jobloglist.txt

		
	if grep -q ${SUBJID} joblog.${JOBID}*; then
		for File in "${joblog[@]}"; do
			if grep -q ${SUBJID} ${File}; then
				echo "Locating within" ${File}
			
				if grep -q WriteMovementRMS ${File}; then
    					echo "Eddy run was successful for" ${SUBJID}
					break
				else
    					echo "Eddy run was abnormal for" ${SUBJID}
					break
				fi
			else
				:	
			fi 
		done
	else
		echo "Joblog not found for" ${SUBJID}	
	fi
done

echo "Finished checking all subject in the list"
