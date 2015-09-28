#!/usr/bin/python
import sys, os

cmd_start = 'vnc4server -depth 24 -geometry %s :51'
cmd_stop = 'vncserver -kill :51'
cmd = ''

n = len(sys.argv)
if n == 2:
    if sys.argv[2] == 'startbig':
        cmd = cmd_start % ('1920x1080',)
    elif sys.argv[2] == 'startsmall':
        cmd = cmd_start % ('1080x608',)
    elif sys.argv[2] == 'stop':
        cmd = cmd_stop

os.system('echo %s', (cmd,))
os.system(cmd)
