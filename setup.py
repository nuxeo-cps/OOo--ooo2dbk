# $Id$
"""setup install 

"""
from distutils.core import setup
import os
import platform

if platform.system() == 'Windows':
    #File for compiling ooo2dbk into executable on win32 with py2exe
    import py2exe
    setup(console=['ooo2dbk'])

elif platform.system() == 'Linux':
    os.system('patch -p1 <distrib.patch')
    setup(name='ooo2dbk',
        version='2.0',
        package_dir={'ooo2dbk': '.'},
        scripts=['ooo2dbk', 'ole2img.py'],
        data_files=[('/etc', ['ooo2dbk.xml',]),
                    ('/usr/share/xml/ooo2dbk', ['ooo2dbk-fo.xsl',
                                                'docbook-psmi.xsl',
                                                'ooo2dbk.xsl',
                                                'ooo2dbk.odf.xsl']),
                    ('/usr/share/doc/ooo2dbk', ['README.txt',
                                            'HISTORY',
                                            'COPYING',
                                            'CHANGES',
                                            'doc/ABOUT.txt',
                                            'doc/howto-use_psmi.txt',
                                            'doc/ooo2dbk.1',
                                            'doc/TODO.txt',
                                            'ooo/templateOOo2dbk-fr.stw',
                                            'ooo/templateOOo2dbk-en.stw',]),
                    ]
        )