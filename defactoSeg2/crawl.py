""" Get the data """
import os
import shutil
import sys
import zipfile


def get_mha(dir_from, dir_to, name):
    fn_from = os.path.join(dir_from, name, 'Processed', 'dataset.mha')

    dir_dest = os.path.join(dir_to, name)
    if not os.path.exists(dir_dest):
        os.mkdir(dir_dest)
    fn_to   = os.path.join(dir_dest, 'dataset.mha')

    shutil.copyfile(fn_from, fn_to)


def get_mask(dir_from, dir_to, name):
    # copy the zip file
    fn_from = os.path.join(dir_from, name, 'Processed', 'dataset.zhf') #

    dir_dest = os.path.join(dir_to, name)
    if not os.path.exists(dir_dest):
        os.mkdir(dir_dest)
    fn_to = os.path.join(dir_dest, 'dataset.zip') # rename silently
    shutil.copyfile(fn_from, fn_to)

    # uncompress the to dir
    dir_tmp = os.path.join(dir_to, name, 'tmp')
    with zipfile.ZipFile(fn_to) as zf:
        zf.extractall(dir_tmp)
    # move the mhd
    fn_mhd = 'masks.mhd'
    shutil.move(os.path.join(dir_tmp,fn_mhd),
                os.path.join(dir_to,name,fn_mhd) )
    # move the raw
    fn_raw = 'masks.raw'
    shutil.move(os.path.join(dir_tmp,fn_raw),
                os.path.join(dir_to,name,fn_raw) )
    # delete the tmp directory and the zip file
    shutil.rmtree(dir_tmp)
    os.remove(fn_to)


def main(dir_from, dir_to):
    for f in os.listdir(dir_from):
        # f should be a directory name
        if os.path.isfile(os.path.join(dir_from, f)):
            continue
        if f == "." or f == "..":
            continue

        print "processing %s..." % (f,)

        # copy mha
        get_mha(dir_from,dir_to,f)

        # get the mask
        get_mask(dir_from, dir_to, f)



if __name__ == "__main__":
    dir_from = "Z:\\Research\\GSpeed Backup\\DeFacto\\DeFACTO CT Data"
    dir_to   = "D:\\data\\defactoSeg2\\"

    if len(sys.argv) != (1+2):
        print "incorrect arguments, using default:"
    else:
        dir_from = sys.argv[1]
        dir_to   = sys.argv[2]

    print "from %s" % (dir_from,)
    print "to %s" % (dir_to,)

    main(dir_from, dir_to)