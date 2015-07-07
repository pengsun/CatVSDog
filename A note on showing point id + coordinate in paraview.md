It's based on the method given here https://xrunhprof.wordpress.com/2012/07/17/display-point-coordinates-in-paraview/

Add a Programable Filter, and add below Python code

``` Python
pdi = self.GetInput()
pdo = self.GetOutput()
coords = vtk.vtkDoubleArray()
coords.SetName("Coordinates")
coords.SetNumberOfComponents(4)
n = pdi.GetNumberOfPoints()
for i in xrange(n):
   p=pdi.GetPoint(i)
   coords.InsertNextTuple4(i, p[0], p[1], p[2])
pdo.GetPointData().AddArray(coords)
```
