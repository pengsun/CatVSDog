""" Generate slices from mha file(s) """
import vtk


def tf_apply(tf, a, cen):
    tf.RotateX(a[0])
    tf.RotateY(a[1])
    tf.RotateZ(a[2])
    tf.Translate(cen)
    return tf


def get_tf_xynormal():
    tf = vtk.vtkTransform()
    return tf


def get_tf_yznormal():
    tf = vtk.vtkTransform()
    tf.RotateY(90)
    return tf


def get_tf_xznormal():
    tf = vtk.vtkTransform()
    tf.RotateX(90)
    return tf


def sz2ext(sz):
    return -sz, sz - 1, -sz, sz - 1, 0, 0


def gen_slice(img, s_tf, s_ext=sz2ext(16)):
    """ generate a slice on a plane """
    rs = vtk.vtkImageReslice()
    rs.SetInputData(img)

    s_axes = s_tf.GetMatrix()
    rs.SetResliceAxes(s_axes)
    rs.SetOutputExtent(s_ext)
    rs.SetOutputDimensionality(2)  # enforcing a plane

    rs.SetInterpolationModeToLinear()
    rs.Update()

    return rs


def gen_3ps(img, cen, sz=16):
    """ generate the 3 perpendicular slices with half of the size
        sz at point pnt """
    tf_1 = get_tf_xynormal()
    tf_1.Translate(cen)
    xy = gen_slice(img, tf_1, sz2ext(sz))

    tf_2 = get_tf_yznormal()
    tf_2.Translate(cen)
    yz = gen_slice(img, tf_2, sz2ext(sz))

    tf_3 = get_tf_xznormal()
    tf_3.Translate(cen)
    xz = gen_slice(img, tf_3, sz2ext(sz))

    return xy, yz, xz


def gen_3s(img, a, cen, sz=16):
    """ generate the 3 perpendicular slices with three angles a and
        half of the size sz at center cen"""
    tf_xy = get_tf_xynormal()
    tf_xy = tf_apply(tf_xy, a, cen)
    xy = gen_slice(img, tf_xy, sz2ext(sz))

    tf_yz = get_tf_yznormal()
    tf_yz = tf_apply(tf_yz, a, cen)
    yz = gen_slice(img, tf_yz, sz2ext(sz))

    tf_xz = get_tf_xznormal()
    tf_xz = tf_apply(tf_xz, a, cen)
    xz = gen_slice(img, tf_xz, sz2ext(sz))

    return xy, yz, xz


def write_slice(s, fn):
    wt = vtk.vtkMetaImageWriter()
    wt.SetInputConnection(s.GetOutputPort())
    wt.SetFileName(fn)
    wt.SetCompression(False)
    wt.Write()


def write_3slices(fn_mha="t.mha",
                  a=(-30, 40, 60), cen=(159, 233, 90), sz=16,
                  fnbase_out="out"):
    """ write the 3 slices using angle, center, half-size  """
    rd = vtk.vtkMetaImageReader()
    rd.SetFileName(fn_mha)
    rd.Update()
    img = rd.GetOutput()

    if a is None:
        xy, yz, xz = gen_3ps(img, cen, sz)
    else:
        xy, yz, xz = gen_3s(img, a, cen, sz)

    write_slice(xy, fnbase_out + "_1.mha")
    write_slice(yz, fnbase_out + "_2.mha")
    write_slice(xz, fnbase_out + "_3.mha")


def write_3slices_files(fn_mha="t.mha", fn_info="i.txt"):
    """ write the 3-slice group specified in fn_info
    each line: angle center size file_name_base
    specifically: a1 a2 a3 c1 c2 c3 sz fnbase
    the 3*N output files would be: fnbase_1_1.mha, ..., fnbase_1_3.mha, fnbase_2_1.mha,..., fnbase_N_3.mha,
    where N is the number of lines in fn_info"""

    # get the image
    rd = vtk.vtkMetaImageReader()
    rd.SetFileName(fn_mha)
    rd.Update()
    img = rd.GetOutput()

    # loop the lines in info file and generate the 3-slice accordingly
    with open(fn_info, 'r') as f:
        for line in f:
            # get the angle, center, size and base name
            elems = line.split()
            a = [int(x) for x in elems[0:3]]
            cen = [int(x) for x in elems[3:6]]
            sz = int(elems[6])
            fnbase_out = elems[7]
            # do the job
            s1, s2, s3 = gen_3s(img, a, cen, sz)
            # write the 3 slices
            write_slice(s1, fnbase_out + "_1.mha")
            write_slice(s2, fnbase_out + "_2.mha")
            write_slice(s3, fnbase_out + "_3.mha")


if __name__ == "__main__":
    write_3slices_files()

#    write_3slices()

# if len(sys.argv) != (1+10):
#        print "error"
#        print "write_3slices(t.mha, (0, 0, 0), (30, 1, 0, 0), 128, haha)"
#        print "mha file name, origin, WXYZ (angle plus the axis), size for extent, output base name"
#    else:
#        write_3slices(sys.argv[1],
#                      [int(x) for x in sys.argv[2:5]],
#                      [float(x) for x in sys.argv[5:9]],
#                      int(sys.argv[9]),
#                      sys.argv[10])
