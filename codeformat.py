################################################################################
#
#  OpenZoom SDK
#
#  Version: MPL 1.1/GPL 3/LGPL 3
#
#  The contents of this file are subject to the Mozilla Public License Version
#  1.1 (the "License"); you may not use this file except in compliance with
#  the License. You may obtain a copy of the License at
#  http://www.mozilla.org/MPL/
#
#  Software distributed under the License is distributed on an "AS IS" basis,
#  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
#  for the specific language governing rights and limitations under the
#  License.
#
#  The Original Code is the OpenZoom SDK.
#
#  The Initial Developer of the Original Code is Daniel Gasienica.
#  Portions created by the Initial Developer are Copyright (c) 2007-2010
#  the Initial Developer. All Rights Reserved.
#
#  Contributor(s):
#    Daniel Gasienica <daniel@gasienica.ch>
#
#  Alternatively, the contents of this file may be used under the terms of
#  either the GNU General Public License Version 3 or later (the "GPL"), or
#  the GNU Lesser General Public License Version 3 or later (the "LGPL"),
#  in which case the provisions of the GPL or the LGPL are applicable instead
#  of those above. If you wish to allow use of your version of this file only
#  under the terms of either the GPL or the LGPL, and not to allow others to
#  use your version of this file under the terms of the MPL, indicate your
#  decision by deleting the provisions above and replace them with the notice
#  and other provisions required by the GPL or the LGPL. If you do not delete
#  the provisions above, a recipient may use your version of this file under
#  the terms of any one of the MPL, the GPL or the LGPL.
#
################################################################################
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
