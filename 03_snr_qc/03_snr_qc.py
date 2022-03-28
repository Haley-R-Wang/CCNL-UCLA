from __future__ import division, print_function
import nibabel as nib
import numpy as np
from dipy.data import fetch_stanford_hardi, read_stanford_hardi
from dipy.segment.mask import median_otsu
from dipy.reconst.dti import TensorModel

from os.path import expanduser, join
home = expanduser('/u/project/CCN/kkarlsgo/data/HCP/HCP_EOP/imagingcollection01')
dname = join(home, 'AP', '1022_01_MR','Diffusion_preproc','eddy_multishell')

fetch_stanford_hardi()
img, gtab = read_stanford_hardi()
data = img.get_data()

print(data)

affine = img.affine

print('Computing brain mask...')
b0_mask, mask = median_otsu(data, vol_idx=[0])

print('Computing tensors...')
tenmodel = TensorModel(gtab)
tensorfit = tenmodel.fit(data, mask=mask)
