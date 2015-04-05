""" Generate rotated slices from mha file(s) """
import vtk
import os
import sys


def tf_rotateXYZ(tf, a):
    tf.RotateX(a[0])
    tf.RotateY(a[1])
    tf.RotateZ(a[2])
    return tf


def get_tf_xynormal(cen=(0.0, 0.0, 0.0)):
    tf = vtk.vtkTransform()
    tf.Translate(cen)
    return tf


def get_tf_yznormal(cen=(0.0, 0.0, 0.0)):
    tf = vtk.vtkTransform()
    tf.Translate(cen)
    tf.RotateY(90)
    return tf


def get_tf_xznormal(cen=(0.0, 0.0, 0.0)):
    tf = vtk.vtkTransform()
    tf.Translate(cen)
    tf.RotateX(90)
    return tf


def sz2ext(sz):
    return -sz, sz - 1, -sz, sz - 1, 0, 0


def gen_slice(img, s_tf, s_ext=sz2ext(16)):
    """ generate a slice on a plane """
    # debug output
    # print "in gen_slice:"

    # the slice
    rs = vtk.vtkImageReslice()
    rs.SetInputData(img)
    rs.SetInterpolationModeToLinear()

    # debug output
    # print "before:"
    # xxx = rs.GetOutputOrigin()
    # print "OutputOrigin", xxx
    # ooo = rs.GetOutputExtent()
    # print "OutputExtent", ooo
    # zzz = rs.GetResliceAxesDirectionCosines()
    # print "ResliceAxesDirectionCosine", zzz
    # yyy = rs.GetResliceAxesOrigin()
    # print "ResliceAxesOrigin", yyy

    # what the slice: define the output plane
    rs.SetOutputDimensionality(2)  # enforcing a plane
    rs.SetOutputSpacing(img.GetDataSpacing())
    rs.SetOutputExtent(s_ext)
    rs.SetOutputOrigin((0.0, 0.0, 0.0))

    # where the slice: the transformation
    s_axes = s_tf.GetMatrix()
    rs.SetResliceAxes(s_axes)

    rs.Update()

    # debug output
    # print "After:"
    # xxx = rs.GetOutputOrigin()
    # print "OutputOrigin", xxx
    # ooo = rs.GetOutputExtent()
    # print "OutputExtent", ooo
    # zzz = rs.GetResliceAxesDirectionCosines()
    # print "ResliceAxesDirectionCosine", zzz
    # yyy = rs.GetResliceAxesOrigin()
    # print "ResliceAxesOrigin", yyy

    return rs


def gen_3ps(img, cen, sz=16):
    """ generate the 3 perpendicular slices with half of the size
        sz at point pnt """
    tf_1 = get_tf_xynormal(cen)
    xy = gen_slice(img, tf_1, sz2ext(sz))

    tf_2 = get_tf_yznormal(cen)
    yz = gen_slice(img, tf_2, sz2ext(sz))

    tf_3 = get_tf_xznormal(cen)
    xz = gen_slice(img, tf_3, sz2ext(sz))

    return xy, yz, xz


def gen_3s(img, a, cen, sz=16):
    """ generate the 3 perpendicular slices with three angles a and
        half of the size sz at center cen"""
    tf_xy = get_tf_xynormal(cen)
    tf_xy = tf_rotateXYZ(tf_xy, a)
    xy = gen_slice(img, tf_xy, sz2ext(sz))

    tf_yz = get_tf_yznormal(cen)
    tf_yz = tf_rotateXYZ(tf_yz, a)
    yz = gen_slice(img, tf_yz, sz2ext(sz))

    tf_xz = get_tf_xznormal(cen)
    tf_xz = tf_rotateXYZ(tf_xz, a)
    xz = gen_slice(img, tf_xz, sz2ext(sz))

    return xy, yz, xz


def write_slice(s, fn):
    wt = vtk.vtkMetaImageWriter()
    wt.SetInputConnection(s.GetOutputPort())
    wt.SetFileName(fn)
    wt.SetCompression(False)
    wt.Write()


def write_3slices(fn_mha="t.mha",
                  a=(-30, 25, 45), cen=(82, 93, 104), sz=10,
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


def write_3slices_files(fn_mha="t.mha", fn_info="i.txt", dir_out=os.getcwd()):
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
        for cnt, line in enumerate(f):
            # get the angle, center, size and base name
            elems = line.split()
            a = [int(x) for x in elems[0:3]]
            cen = [int(x) for x in elems[3:6]]
            sz = int(elems[6])
            fnbase_out = elems[7]
            # do the job
            s1, s2, s3 = gen_3s(img, a, cen, sz)

            # write the 3 slices
            fn1 = fnbase_out + "_" + str(cnt+1) + "_1.mha"
            write_slice(s1, os.path.join(dir_out, fn1))

            fn2 = fnbase_out + "_" + str(cnt+1) + "_2.mha"
            write_slice(s2, os.path.join(dir_out, fn2))

            fn3 = fnbase_out + "_" + str(cnt+1) + "_3.mha"
            write_slice(s3, os.path.join(dir_out, fn3))


if __name__ == "__main__":
    dir_mha = "D:\data\defactoSeg"
    dir_info = "D:\data\defactoSeg_matlab\sample_info"
    dir_out = "D:\data\defactoSeg_matlab\slices"

    if len(sys.argv) != (1+3):
        print "incorrect arguments, using default:"
    else:
        dir_mha = sys.argv[1]
        dir_info = sys.argv[2]
        dir_out = sys.argv[3]

    print "dir_mha", dir_mha
    print "dir_info", dir_info
    print "dir_out", dir_out

    for f in os.listdir(dir_mha):
        if os.path.isfile(f):
            continue
        if f == "." or f == "..":
            continue

        # mha file
        fn_mha = os.path.join(dir_mha, f, "t.mha")
        # info file
        fn_info = os.path.join(dir_info, f + ".txt")
        write_3slices_files(fn_mha, fn_info, dir_out)

        print "done", fn_mha, "and", fn_info

#    write_3slices_files("t.mha", "11-044-RVW.txt", os.path.join(os.getcwd(), "tmp"))

#    write_3slices()