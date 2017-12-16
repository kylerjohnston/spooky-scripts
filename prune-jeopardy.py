#!/usr/bin/env python3
#
# prune-jeopardy.py
#
# Run daily --- removes Jeopardy files that were last modified
# more than one week ago.

import datetime
import os
import sys

workdir = '/home/share/shows/Jeopardy'
today = datetime.date.today()

try:
    files = os.listdir(workdir)
except:
    sys.exit(1)

for f in files:
    mtime = datetime.date.fromtimestamp(
        os.path.getmtime(os.path.join(workdir, f)))
    if today - mtime > datetime.timedelta(weeks=1):
        os.remove(os.path.join(workdir, f))
    
