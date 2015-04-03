""" Generate slices aligned to natural coordinate from mha file(s) """
import sys
import vtk


def get_xy_extent(sz=16):
    return -sz, sz-1, -sz, sz-1, 0, 1


def get_yz_extent(sz=16):
    return 0, 1, -sz, sz-1, -sz, sz-1


def get_xz_extent(sz=16):
    return -sz, sz-1, 0, 1, -sz, sz-1


def gen_slice(img, pnt=(30, 42, 57), wxyz=(30.0, 0.0, 0.0, 1.0), ext=get_xy_extent()):
    """ generate the slice on xy plane"""

    tf = vtk.vtkTransform()
    tf.RotateWXYZ(wxyz[0], wxyz[1:4])

    rs = vtk.vtkImageReslice()
    rs.SetInputData(img)

    rs.SetResliceTransform(tf)
    rs.SetOutputExtent(ext)
    rs.SetOutputOrigin(pnt)

    rs.SetInterpolationModeToLinear()
    rs.Update()

    return rs


def gen_3slices(img, pnt=(30, 40, 42), wxyz=(30.0, 0.0, 0.0, 1.0), sz=16):
    """ generate the 3 perpendicular slices with half of the size sz at point pnt"""
    xy = gen_slice(img, pnt, wxyz, get_xy_extent(sz))
    yz = gen_slice(img, pnt, wxyz, get_yz_extent(sz))
    xz = gen_slice(img, pnt, wxyz, get_xz_extent(sz))
    return xy, yz, xz


def write_slice(s, fn):
    wt = vtk.vtkMetaImageWriter()
    wt.SetInputConnection(s.GetOutputPort())
    wt.SetFileName(fn)
    wt.SetCompression(False)
    wt.Write()


def write_3slices(fn_mha="t.mha", pnt=(159, 233, 90), wxyz=(0.0, 0.0, 0.0, 1.0), sz=16, fnbase_out="out"):
    """ write the 3 perpendicular slices with half of the size sz at point pnt"""
    rd = vtk.vtkMetaImageReader()
    rd.SetFileName(fn_mha)
    rd.Update()
    img = rd.GetOutput()

    xy, yz, xz = gen_3slices(img, pnt, wxyz, sz)

    write_slice(xy, fnbase_out+"_xy.mha")
    write_slice(yz, fnbase_out+"_yz.mha")
    write_slice(xz, fnbase_out+"_xz.mha")


if __name__ == "__main__":
    write_3slices()
#    if len(sys.argv) != (1+10):
#        print "error"
#        print "write_3slices(t.mha, (0, 0, 0), (30, 1, 0, 0), 128, haha)"
#        print "mha file name, origin, WXYZ (angle plus the axis), size for extent, output base name"
#    else:
#        write_3slices(sys.argv[1],
#                      [int(x) for x in sys.argv[2:5]],
#                      [float(x) for x in sys.argv[5:9]],
#                      int(sys.argv[9]),
#                      sys.argv[10])
