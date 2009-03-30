#!/usr/bin/env python

from distutils.core import setup

setup(name="openzoom-caral",
      version="0.1",
      description="Python tools for generating OpenZoom images.",
      author="Daniel Gasienica",
      author_email="daniel@gasienica.ch",
      download_url="http://open-zoom.googlecode.com/files/openzoom-caral-0.1.zip",
      keywords="openzoom",
      url="http://code.google.com/p/open-zoom/",
      py_modules=["openzoom"],
      classifiers=["Development Status :: 3 - Alpha",
                   "Intended Audience :: Developers",
                   "License :: OSI Approved :: GNU General Public License (GPL)",
                   "Operating System :: OS Independent",
                   "Programming Language :: Python",
                   "Topic :: Utilities",
                   "Topic :: Multimedia :: Graphics",
                   "Topic :: Multimedia :: Graphics :: Graphics Conversion"])