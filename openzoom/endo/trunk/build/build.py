#!/usr/bin/env python

import os.path
import re
import subprocess

def clean(file):
    if os.path.exists(file):
        os.remove(file)

dist_name = "openzoom-min.js"

clean(dist_name)
dist_file = open(dist_name, "w+")
subprocess.call("java -jar ../lib/yuicompressor-2.4.2.jar --verbose -o jquery.openzoom.min.js  ../src/jquery.openzoom.js", shell=True)
subprocess.call("java -jar ../lib/yuicompressor-2.4.2.jar --verbose -o openzoom.min.js  ../src/openzoom.js", shell=True)
f = open("jquery.openzoom.min.js")
source_file = open("../src/jquery.openzoom.js", "r")
license = source_file.read()
header = re.match("(\/\*(.|\n)*?\*\/)", license)
source_file.close()
dist_file.write(header.group(1) + "\n" + f.read() + "\n")
f.close()
f = open("openzoom.min.js")
dist_file.write(f.read() + "\n")
f.close()
clean("openzoom.min.js")
clean("jquery.openzoom.min.js")
dist_file.close()

