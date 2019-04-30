#!C:\workspace\python27\python.EXE
# EASY-INSTALL-ENTRY-SCRIPT: 'future==0.9.0','console_scripts','futurize'
__requires__ = 'future==0.9.0'
import sys
from pkg_resources import load_entry_point

sys.exit(
   load_entry_point('future==0.9.0', 'console_scripts', 'futurize')()
)
