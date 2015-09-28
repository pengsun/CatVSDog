import os
import shutil

src = '/home/ps/.vnc/xstartup'

for each in os.listdir('/home'):
    # decide target file
    tardir = os.path.join('/home', each, '/.vnc/')
    tar = os.path.join(tardir, 'xstartup')
    # skip if not such a file
    if not os.path.isfile(tar):
        continue
    # copy
    print src, '->', tar
    shutil.copy(src, tar)

