#
#   OpenZoom SDK
#
#   Copyright (c) 2008-2009, Daniel Gasienica <daniel@gasienica.ch>
#
#   OpenZoom is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   OpenZoom is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with OpenZoom. If not, see <http://www.gnu.org/licenses/>.
#
from __future__ import with_statement
import fileinput
import os
import re
import sys

def convert(file):
    for line in fileinput.FileInput(file, inplace=1):
        line = re.sub(r" +$", "", line)
        line = re.sub(r"\t", "    ", line)
        line = re.sub(r"^( )+import (.*)", r"import \2", line)
        line = re.sub(r"^import (.*);$", r"import \1", line)
        
        # prevent messing up ternary expressions
        if line.count("?") == 0:
            line =  re.sub(" : ", ":", line)
        line = re.sub("\( ", "(", line)
        line = re.sub(" \)", ")", line)
        line = re.sub("\[ ", "[", line)
        line = re.sub(" \]", "]", line)
        line = re.sub("if\(", "if (", line)
        line = re.sub("for\(", "for (", line)
        line = re.sub("while\(", "while (", line)
        line = re.sub("for each\(", "for each (", line)
        line = re.sub("switch\(", "switch (", line)
        sys.stdout.write(line)

for root, dirs, files in os.walk("src"):
    for file in files:
        _, ext = os.path.splitext(file)
        if ext == ".as" and str(file).count("ExternalMouseWheel") == 0:
            convert(os.path.join(root, file))

for root, dirs, files in os.walk("test"):
    for file in files:
        _, ext = os.path.splitext(file)
        if ext == ".as":
            convert(os.path.join(root, file))
        
print("Done.")
