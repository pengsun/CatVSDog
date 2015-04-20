# The data:
dataset.mha: original CT image, unit in MM
c.vtp: original Aorta + vessels mesh (vtkPolyData). Unit in CM

t.mha: the same with dataset.mha, but spacing = (1 1 1), origin = (0 0 0)
t.vtk: the same with c.vtp, but re-calculate the coordinate
mask.mha: mask of t.vtk
maskv3.mha: mask of t.vtk where the Aorta has been removed (3rd version)
maskb.mha: mask for background, counting pixels around the vessels


# The steps:
* defactoSeg.py: "trim" the data: dataset.mha->t.mha, c.vtp->t.vtk
* remove_aorta_dir.m: mask.mha -> maskv3.mha, more refined mask where the 
   Aorta has been removed
* gen_bg_dir.m: maskv3, mask.mha -> maskb.mha, generate the background mask
