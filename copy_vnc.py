import os
import shutil

src = '/home/ps/.vnc/xstartup'

for each in os.listdir('/home'):
    # decide target file
    tardir = os.path.join('/home', each, '/.vnc/')
    if not os.path.isdir(tardir):
        os.mkdir(tardir)
    tar = os.path.join(tardir, 'xstartup')
    # copy
    print src, '->', tar
    shutil.copy(src, tar)

