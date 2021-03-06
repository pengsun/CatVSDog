The vtkImageReslice is powerful but sometimes confusing due to its too many options and a mixing up of pysical coordinate and pixel coordinate when specifying the output slice. Here we give a recommended (safe) usage when getting an arbitrary 2D slice (controlled by the center and the orientation) from a 3D volume.
Detailed explanation goes with below code snippet.

``` Python
# Read the volume
reader = vtk.vtkMetaImageReader()
reader.SetFileName("t.mha")
reader.Update()
# the resolution
(xSpacing, ySpacing, zSpacing) = reader.GetOutput().GetSpacing()
# understood as offset: the physical coordinate for the first pixel at (0, 0, 0)
(x0, y0, z0) = reader.GetOutput().GetOrigin()

# The reslice
reslice = vtk.vtkImageReslice()
reslice.SetInputConnection(reader.GetOutputPort())
reslice.SetInterpolationModeToLinear()

# Setp 1: Think in the coordinate of the plane (the Output): the size of the slice
# This defines WHAT the slice is

# Enforce a 2D plane
reslice.SetOutputDimensionality(2)
# In pysical coordinate: what's the resolution, i.e., Millie Meter per pixel ?
reslice.SetOutputSpacing(xSpacing, ySpacing, zSpacing)
# In pixel coordinate: what are the integer coordinates of the 6 corners? 
# The following code defines an image with 512 x 256 pixels 
xExt, yExt = (256, 256)
ext = (-xExt, xExt-1, 0, yExt-1, 0, 0)
reslice.SetOutputExtent(ext)
# The offset: pixel coordinate origin w.r.t. pysical coordinate origin
# We let them conincide for convenience
reslice.SetOutputOrigin(0.0, 0.0, 0.0)

# Setp 2: Think in the coordinate of the volume: where the slice should be? This is done 
# by specifiying the center and the normal direction of the plane w.r.t. to the volume coordinate
# This defines WHERE the slice is

# Reslice axes
tf = vtk.vtkTransform()
# The order of the translation and the rotation is important!
# Target volume point for the plane's center is (180, 190, 200) in pixels 
tar_cen = (x0+180*xSpacing, y0+190*ySpacing, z0+100*zSpacing)
tf.Translate(tar_cen)
# Rotate the normal vector by degrees. The plane coincide with XY plane initially
tf.RotateX(0)
tf.RotateY(6.4) # in degree
tf.RotateZ(10)
# tf.GetMatrix() returns the 4X4 transformation matrix. This line of code is equivalent to 
# reslice.SetResliceTransform(tf), which, however, occasionally causes run time problem on
# certain computer. Cannot figure out why...
reslice.SetResliceAxes(tf.GetMatrix())


# Step 3: done
reslice.Update()
```

Remarks:
* the "official" example for `vtkImageReslice` at [VTK hosted on github](https://github.com/Kitware/VTK/tree/master/Examples/ImageProcessing/Python). Try to insert above code and see if it produes the desired plane.
* orientation as normal vector for a plane: http://www.vtk.org/Wiki/VTK/Examples/Cxx/GeometricObjects/OrientedArrow

Tested for Python 2.7.6 with VTK 6.2


