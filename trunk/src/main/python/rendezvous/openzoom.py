"""
   Copyright (c) 2008 Daniel Gasienica <daniel@gasienica.ch>
   Copyright (c) 2008 Boris Bluntschli <boris@bluntschli.ch>

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.

   Usage:

       openzoom.py <file_name> [--<key> <value>]*

       openzoom.py --help
"""

help_text = """
openzoom.py

--tile_size : Define a tile's size in pixels [default: 256]
--tile_overlap : Define the tile overlap in pixels [default: 1]
--tile_format : Define the tile format, either <jpg> or <png> [default: <jpg>]
--resize_algorithm : Defines the resize algorithm to be used (NEAREST, BILINEAR, BICUBIC or ANTIALIAS) [default: ANTIALIAS]
"""

import sys
import Image
import os
import math
import shutil
import optparse

# ------------------------------------------------------------------------------
# Slicing stuff
# ------------------------------------------------------------------------------
def run(args):
   file_name = os.path.splitext(args.file_name)[0]
   base = file_name + '.ozi'
   if os.path.isdir(base):
      os.rmdir(base)
   os.mkdir(base)
   
   image_file = base + '/' + args.file_name
   shutil.copy(args.file_name, image_file)
   image = Image.open(image_file)
   width, height = image.getbbox()[2:]
   original_width, original_height = width, height
   level = int(math.ceil(math.log(max(width, height),2)))
   while level >= 0:
       print 'Creating images for level %s...' % level,

       # Create all slices for the current zoom level
       for column in xrange(0, ((width-1) / args.tile_size) + 1):
           for row in xrange(0, ((height-1) / args.tile_size) + 1):
               offset_x = max(0, (column * args.tile_size) - args.tile_overlap)
               offset_y = max(0, (row * args.tile_size) - args.tile_overlap)
               padding_x = args.tile_overlap if offset_x == 0 else 2 * args.tile_overlap
               padding_y = args.tile_overlap if offset_y == 0 else 2 * args.tile_overlap 
               crop_width = min(offset_x + args.tile_size + padding_x, width)
               crop_height = min(offset_y + args.tile_size + padding_y, height)
               cropped = image.crop((offset_x, offset_y, crop_width, crop_height))
               path = base + '/' + str(level)
               if not os.path.isdir(path):
                   os.makedirs(path)
               cropped.save(path + '/' + str(column) + '-' + str(row) + '.' + args.tile_format)

       # Create smaller image
       # print width, height
       width, height = int(math.ceil((width+1)/2)), int(math.ceil((height+1)/2))
       image = image.resize((width, height), args.resize_algorithm)
       level -= 1

       print 'DONE'

   descriptor_file_name = 'meta.xml'
   descriptor_file = open(base + '/' + descriptor_file_name, 'w')
   meta = '<?xml version="1.0" encoding="UTF-8"?>'
   meta += '\n' + '<image xmlns="http://openzoom.org/2008/ozi" version="0.1">'
   meta += '\n\t' + '<pyramid width="' + str(original_width) + '" height="' + str(original_height) + '"'
   meta += ' tileSize="' + str(args.tile_size) + '" overlap="' + str(args.tile_overlap) + '" format="' + args.tile_format + '"/>'
   meta += '\n\t' + '<source url="' + args.file_name + '" width="' + str(original_width) + '" height="' + str(original_height) + '"/>'
   meta += '\n' + '</image>'
   descriptor_file.write(meta)
   print 'I LIKE!!'

# ------------------------------------------------------------------------------
# Argument parsing
# ------------------------------------------------------------------------------
class ProgramArguments(object):
   def parse_args(self, args):
       # Drop script name
       script_name = args.pop(0)

       if len(args) == 0:
           self.help()
           sys.exit(0)

       self.file_name = args.pop(0)

       while len(args) > 0:
           key = args.pop(0)
           try:
               value = args.pop(0)
           except:
               pass

           if key in ("-h", "--help"):
               self.help()
               sys.exit(0)

           if not key.startswith('--'):
               print '*** WARNING *** Did not understand: "' + key + "'"
               continue
           key = key[2:]
           if not self.__dict__.has_key(key):
               print '*** WARNING *** Unknown key: \'' + key + '\''
               continue

           # If a map_* function is defined, we map the input to an internal value
           mapping_func = getattr(self, 'map_' + key, None)
           if mapping_func is not None:
               value = mapping_func(value)
           self.__dict__[key] = value

   def help(self):
       print 'No help defined'

class SliceArguments(ProgramArguments):
   def __init__(self, args=[]):
       self._default_values()
       self.parse_args(args)

   def verify(self):
       errors = []
       if self.file_name is None:
           errors += ['No filename was defined']
       if not self.tile_size > 1:
           errors += ['Tile size must be at least 2 pixels']
       if self.resize_algorithm is None:
           errors += ['Invalid resize algorithm']
       if self.tile_format is None:
           errors += ['Tile format not available. Please choose between <jpg> or <png>']

       return errors

   def map_resize_algorithm(self, value):
       value = value.upper()
       mapping = {'NEAREST':   Image.NEAREST,
                  'BILINEAR':  Image.BILINEAR,
                  'BICUBIC':   Image.BICUBIC,
                  'ANTIALIAS': Image.ANTIALIAS}
       if not mapping.has_key(value):
           return None
       return mapping[value]

   def map_tile_format(self, value):
       value = value.lower()
       mapping = {'jpg': 'jpg',
                  'png': 'png'}
       if not mapping.has_key(value):
           return None
       return mapping[value]

   map_tile_size = lambda self, x: int(x)
   map_tile_overlap = lambda self, x: int(x)

   def _default_values(self):
       self.file_name = None
       self.tile_size = 256
       self.tile_overlap = 1
       self.tile_format = 'jpg'
       self.resize_algorithm = Image.ANTIALIAS

   def help(self):
       print help_text

# ------------------------------------------------------------------------------
# Run program
# ------------------------------------------------------------------------------
args = SliceArguments(sys.argv)
errors = args.verify()
if errors:
   for error in errors:
       print '*** ERROR ***', error
   sys.exit(1)
run(args)
