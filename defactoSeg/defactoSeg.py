import vtk
import os
import zipfile
import shutil

def trim_mha(fn = "dataset.mha", fnout = "t.mha"):
    if not os.path.exists(fn):
        print "%s does not exists, skip" % (fn,)
        return
    
    # read mha image
    rd = vtk.vtkMetaImageReader()
    rd.SetFileName(fn)
    rd.Update()

    # the image data
    img = vtk.vtkImageData()
    img = rd.GetOutput()

    # set spacing to (1.0, 1.0, 1.0)
    spacing = img.GetSpacing()
    new_spacing = (1.0, 1.0, 1.0)
    img.SetSpacing(new_spacing)

    # set the origin to (0.0, 0.0, 0.0)
    new_orig = (0.0, 0.0, 0.0)
    img.SetOrigin(new_orig)
    
    # write mha
    wt = vtk.vtkMetaImageWriter()
    wt.SetInputData(img)
    wt.SetFileName(fnout)
    wt.Write()

    return spacing


def scale_vtkPolyData(pd, s = (1.0,1.0,1.0)):
    pnts = pd.GetPoints()
    for i in range(0, pnts.GetNumberOfPoints()):
        p = pnts.GetPoint(i)
        q = [ss*pp for ss, pp in zip(s,p)]
        pnts.SetPoint(i, q)
    pd.SetPoints(pnts)
    return pd


def trim_vtp(fn = "c.vtp", fnout = "t.vtk", s = (1.0,1.0,1.0)):
    if not os.path.exists(fn):
        print "%s does not exists, skip" % (fn,)
        return
    
    # Read vtp
    rd = vtk.vtkXMLPolyDataReader()
    rd.SetFileName(fn)
    rd.Update()

    # the poly data
    pd = vtk.vtkPolyData()
    pd = rd.GetOutput()

    # times by 10.0 (CM -> MM)
    MM = [10.0 for each in range(0,len(s))]
    pd = scale_vtkPolyData(pd, MM)
    # then divides the spacing
    ss = [1/each for each in s]
    pd = scale_vtkPolyData(pd, ss)

    # Write vtk
    wt = vtk.vtkPolyDataWriter()
    wt.SetInputData(pd)
    wt.SetFileName(fnout)
    wt.Write()    


def trim_dir(d = os.getcwd()):
    for f in os.listdir(d):
        ff = os.path.join(d, f)
        # skip non target 
        if os.path.isfile(ff):
            continue
        
        # trim mha
        fn_mha = os.path.join(ff, "dataset.mha")
        fn_mha_out = os.path.join(ff, "t.mha")
        print "Processing ", fn_mha, "...",
        spacing = trim_mha(fn_mha, fn_mha_out)
        print "done"

        # trim vtp
        fn_vtp = os.path.join(ff, "c.vtp")
        fn_vtk = os.path.join(ff, "t.vtk")
        print "Processing ", fn_vtp, "...",
        trim_vtp(fn_vtp, fn_vtk, spacing)
        print "done"

        # done a particluar case
        print


def extract_mha(fn = "dataset.mha", fn_out = "hh.mha"):
    if not os.path.exists(fn):
        print "%s does not exists, skip" % (fn,)
        return
    shutil.copy(fn, fn_out)


def extract_vtp(fn = "zz.zip", fn_out = "c.vtp"):
    if not os.path.exists(fn):
        print "%s does not exists, skip" % (fn,)
        return
    with zipfile.ZipFile(fn) as zip_file:
        for member in zip_file.namelist():
            filename = os.path.basename(member)
            
            # skip non interesting file
            if filename[:8] != "resample":
                continue

            # copy file
            source = zip_file.open(member)
            #target = file(os.path.join(dir_out, fn_out), "wb")
            target = file(fn_out, "wb")
            with source, target:
                shutil.copyfileobj(source, target)    


if __name__ == "__main__":
    pass
