################################################################################
#
#   OpenZoom
#
#   Copyright (c) 2007-2008, Daniel Gasienica <daniel@gasienica.ch>
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
################################################################################

import random
import base64

alphabet = """abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ123456789!@#$%^&*()_{}|'/<>?.,"""
min = 0
max = len(alphabet)
total = 1000
string = ""
file = open("org/openzoom/flash/utils/Base16Samples.as","w")
file.write("    private static const SAMPLES : Array = [\n")

for count in xrange(1,total):
  for x in random.sample(alphabet,random.randint(min,max)):
      string += x
  file.write( "        [\"" + string + "\", \"" + base64.b16encode( string ) +"\"],\n" )
  string = ""

file.write("    ]")
file.close()