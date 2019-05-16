#!C:\workspace\Python27\python.exe
# EASY-INSTALL-ENTRY-SCRIPT: 'django==1.10b1','console_scripts','django-admin'
__requires__ = 'django==1.10b1'
import sys
from pkg_resources import load_entry_point

sys.exit(
   load_entry_point('django==1.10b1', 'console_scripts', 'django-admin')()
)
