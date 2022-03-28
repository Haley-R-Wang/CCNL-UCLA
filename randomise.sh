#!/bin/sh

#qrsh -l highp,h_rt=48:00:00,h_data=12G -pe shared 2

cd /u/project/CCN/kkarlsgo/data/HCP/HCP_EOP/imagingcollection01/analysis/contrast

/u/project/CCN/apps/fsl/6.0.4/bin/randomise -i /u/project/CCN/kkarlsgo/data/HCP/HCP_EOP/imagingcollection01/analysis/tbss/stats/all_FA_skeletonised.nii.gz -o FA_2cov_173 -m /u/project/CCN/kkarlsgo/data/HCP/HCP_EOP/imagingcollection01/analysis/tbss/stats/mean_FA_skeleton_mask.nii.gz -d /u/project/CCN/kkarlsgo/data/HCP/HCP_EOP/imagingcollection01/analysis/contrast/FA_2cov_173.mat -t /u/project/CCN/kkarlsgo/data/HCP/HCP_EOP/imagingcollection01/analysis/contrast/FA_2cov_173.con --T2 -v 6 -n 5000

