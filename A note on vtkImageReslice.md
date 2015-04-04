The vtkImageReslice is powerful but sometimes confusing due to its too many options. Here we give a recommended (safe) usage when getting an arbitrary 2D slice (controlled by the center and the orientation) from a 3D volume. The explanation goes with the code below.

``` Python
# Read the volume
reader = vtk.vtkMetaImageReader()
reader.SetFileName("t.mha")
reader.Update()
(xSpacing, ySpacing, zSpacing) = reader.GetOutput().GetSpacing()
(x0, y0, z0) = reader.GetOutput().GetOrigin()

# The reslice
reslice = vtk.vtkImageReslice()
reslice.SetInputConnection(reader.GetOutputPort())
reslice.SetInterpolationModeToLinear()

# Setp 1: Think in the coordinate of the plane (the Output): the size of the slice
# Enforce a 2D plane
reslice.SetOutputDimensionality(2)
# In pysical coordinate: what's the resolution, i.e., Millie Meter per pixel ?
reslice.SetOutputSpacing(xSpacing, ySpacing, zSpacing)
# In pixel coordinate: what are the integer coordinates of the 6 corners? The following code defines an image with the size 512 x 256 pixels 
xExt = 256
yExt = 256
ext = (-xExt, xExt-1, 0, yExt-1, 0, 0)
reslice.SetOutputExtent(ext)
# The offset: pixel coordinate origin w.r.t. pysical coordinate origin
reslice.SetOutputOrigin(0.0, 0.0, 0.0)

# Setp 2: Think in the coordinate of the volume: where the slice should be? This is done by specifiying the center and the normal direction of the plane w.r.t. to the volume coordinate
# Reslice axes
tf = vtk.vtkTransform()
# The order of the translation and the rotation is important!
tar_cen = (x0+180*xSpacing, y0+190*ySpacing, z0+100*zSpacing)
tf.Translate(tar_cen) # move to the target center
tf.RotateX(0)
tf.RotateY(6.4) # in degree
tf.RotateZ(10)
reslice.SetResliceAxes(tf.GetMatrix())
# tf.GetMatrix() returns the 4X4 transformation matrix
# This line of code is equivalent to reslice.SetTransform(tf), but this occasionally causes problem on some computer, I don't know why

# Step 3: done
reslice.Update()
```

Also, you can find the "official" example for `vtkImageReslice` at (VTK hosted on github)[https://github.com/Kitware/VTK/tree/master/Examples/ImageProcessing/Python]. Try to insert above code and see if it produes the desired plane.


4/4/2015

Python 2.7.6 with VTK 6.2