################################################################################ 
# 
#   Deep Zoom Tools
# 
#   Copyright (c) 2008, Daniel Gasienica <daniel@gasienica.ch>
#   Copyright (c) 2008, Kapil Thangavelu <kapil.foss@gmail.com>
#   All rights reserved.
# 
#   Redistribution and use in source and binary forms, with or without
#   modification, are permitted provided that the following conditions are met:
# 
#   Redistributions of source code must retain the above copyright notice, this
#   list of conditions and the following disclaimer. Redistributions in binary
#   form must reproduce the above copyright notice, this list of conditions and
#   the following disclaimer in the documentation and/or other materials
#   provided with the distribution. The names of the contributors may not be
#   used to endorse or promote products derived from this software without
#   specific prior written permission. 
# 
#   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
#   AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
#   IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
#   ARE DISCLAIMED. IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR
#   ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
#   DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
#   SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
#   CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
#   LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
#   OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
#   DAMAGE.
# 
################################################################################

# TODO
# Support for image quality setting
# http://www.pythonware.com/library/pil/handbook/format-jpeg.htm
# http://www.pythonware.com/library/pil/handbook/format-png.htm

import math
import os
import optparse
import sys

from PIL import Image

DZI_TEMPLATE = """\
<?xml version="1.0" encoding="UTF-8"?>
<Image TileSize="%(tile_size)s" Overlap="%(tile_overlap)s" Format="%(tile_format)s" xmlns="http://schemas.microsoft.com/deepzoom/2008">
    <Size Width="%(width)s" Height="%(height)s"/>
</Image>"""

resize_filter_map = {
    "cubic": Image.CUBIC,
    "bilinear": Image.BILINEAR,
    "bicubic": Image.BICUBIC,
    "nearest": Image.NEAREST,
    "antialias": Image.ANTIALIAS,
    }

image_format_map = {
    "jpg": "jpg",
    "png": "png",
    }

class ImageCreator(object):
    """Creates Deep Zoom images."""
    def __init__(self, tile_size=256, tile_overlap=1, tile_format="jpg", resize_filter=None):
        self.tile_size = int(tile_size)
        self.tile_overlap = int(tile_overlap)
        self.tile_format = tile_format
        self.resize_filter = resize_filter
        self._levels = None

    @property
    def levels(self):
        """Number of levels in the image pyramid"""
        if self._levels is not None:
            return self._levels
        self._levels = int(math.ceil(math.log(max((self.width, self.height)), 2)))
        return self._levels

    def get_level_dimensions(self, level):
        """Dimensions of level (width, height)"""
        assert 0 <= level and level <= self.levels, "Invalid pyramid level"
        scale = self.get_level_scale(level)
        return int(math.ceil(self.width * scale)), int(math.ceil(self.height * scale))

    def get_level_scale(self, level):
        #print math.pow(0.5, self.levels - level)
        return 1.0 / (1 << (self.levels - level))

    def get_tiles(self, level):
        """Number of tiles (columns, rows)"""
        w, h = self.get_level_dimensions( level )
        return (int(math.ceil(float(w) / self.tile_size)), int(math.ceil(float(h) / self.tile_size)))
    
    def get_tile_bounds(self, level, column, row):
        """Bounding box of the tile (x1, y1, x2, y2)"""
        # find start position for current tile
        
        # python's ternary operator doesn't like zero as true condition result
        # i.e. True and 0 or 1 -> returns 1        
        if not column:
            px = 0
        else:
            px = self.tile_size * column - self.tile_overlap
        if not row:
            py = 0
        else:
            py = self.tile_size * row - self.tile_overlap

        # scaled dimensions for this level
        dsw, dsh = self.get_level_dimensions(level)
        
        # find the dimension of the tile, adjust for no overlap data on top and left edges
        sx = self.tile_size + (column == 0 and 1 or 2) * self.tile_overlap
        sy = self.tile_size + (row    == 0 and 1 or 2) * self.tile_overlap
        
        # adjust size for single-tile levels where the image size is smaller
        # than the regular tile size, and for tiles on the bottom and right
        # edges that would exceed the image bounds        
        sx = min(sx, dsw - px)
        sy = min(sy, dsh - py)
        
        return px, py, px+sx, py+sy

    def get_level_image(self, level):
        w, h = self.get_level_dimensions(level)

        # don't transform to what we already have
        if self.width == w and self.height == h: 
            return self.image
        
        if not self.resize_filter:
            return self.image.resize((w, h), Image.ANTIALIAS) 
        return self.image.resize((w, h), self.resize_filter)
    
    def iter_tiles(self, level):
        col, row = self.get_tiles(level)
        for w in xrange(int(col)):
            for h in xrange(int(row)):
                yield (w, h), (self.get_tile_bounds(level, w, h))

    def __len__(self):
        return self.levels
    
    def create(self, source, destination):
        self.image = Image.open(source)
        self.width, self.height = self.image.size
        destination = expand(destination)
        image_name = os.path.splitext(os.path.basename(destination))[0]
        image_files = ensure(os.path.join(ensure(os.path.dirname(destination)), "%s_files"%image_name))
        
        # store images
        for n in range(self.levels + 1):
            level_dir = ensure(os.path.join(image_files, str(n)))
            level_image = self.get_level_image(n)
            for (col, row), box in self.iter_tiles(n):
                tile = level_image.crop(map(int, box))
                tile_path = os.path.join(level_dir, "%s_%s.%s"%(col, row, self.tile_format))
                tile_file = open(tile_path, "wb+")
                tile.save(tile_file)

        # store dzi file
        fh = open(destination, "w+")
        fh.write(DZI_TEMPLATE%(self.__dict__))
        fh.close()
        
def expand(d):
    return os.path.abspath(os.path.expanduser(os.path.expandvars(d)))

def ensure(d):
    if not os.path.exists(d):
        os.mkdir(d)
    return d

def main():
    parser = optparse.OptionParser(usage="Usage: %prog [options] filename")
    
    parser.add_option("-d", "--destination", dest="destination",
                      help="Set the destination of the output")
    
    parser.add_option("-s", "--tile_size", dest="tile_size", type="int",
                      default=256, help="Size of the tiles")
    parser.add_option("-f", "--tile_format", dest="tile_format",
                      default="jpg", help="Image format of the tiles (jpg or png)")
    parser.add_option("-o", "--tile_overlap", dest="tile_overlap", type="int",
                      default="1", help="Overlap of the tiles in pixels (0-10)")
    parser.add_option("-q", "--image_quality", dest="image_quality", type="float",
                      default="0.95", help="Quality of the image output (0-1)")
    
    parser.add_option("-r", "--resize_filter", dest="resize_filter", default="antialias",
                      help="Type of filter for resizing (bicubic, nearest, antialias, bilinear")

    (options, args) = parser.parse_args()

    if not args:
        parser.print_help()
        sys.exit(1)
    source = expand(args[0])
    
    if not os.path.exists(source):
        print "Invalid File", source
        sys.exit(1)
        
    if not options.destination:
        options.destination = os.path.splitext(source)[0] + ".dzi"
    if options.resize_filter and options.resize_filter in resize_filter_map:
        options.resize_filter = resize_filter_map[ options.resize_filter ]

    creator = ImageCreator(tile_size=options.tile_size, tile_format=options.tile_format, resize_filter=options.resize_filter)
    creator.create(source, options.destination)
    
if __name__ == "__main__":
    main()