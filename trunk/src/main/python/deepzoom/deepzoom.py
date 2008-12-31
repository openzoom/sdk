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
import optparse
import os
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
    def __init__(self, tile_size=256, tile_overlap=1, tile_format="jpg", image_quality=0.95, resize_filter=None):
        self.tile_size = int(tile_size)
        self.tile_format = tile_format
        self.tile_overlap = _clamp(int(tile_overlap), 0, 10)
        self.image_quality = _clamp(image_quality, 0, 1.0)
        if not tile_format in image_format_map:
            self.tile_format = "jpg"            
        self.resize_filter = resize_filter

    def get_level_scale(self, level):
        """Scale of a pyramid level."""
        assert 0 <= level and level < self.num_levels, "Invalid pyramid level"
        max_level = self.num_levels - 1
        return math.pow(0.5, max_level - level)

    def get_level_dimensions(self, level):
        """Dimensions of level (width, height)"""
        assert 0 <= level and level < self.num_levels, "Invalid pyramid level"
        scale = self.get_level_scale(level)
        return int(math.ceil(self.width * scale)), int(math.ceil(self.height * scale))

    def get_num_tiles(self, level):
        """Number of tiles (columns, rows)"""
        assert 0 <= level and level < self.num_levels, "Invalid pyramid level"
        w, h = self.get_level_dimensions( level )
        return (int(math.ceil(float(w) / self.tile_size)),
                int(math.ceil(float(h) / self.tile_size)))
    
    def get_tile_bounds(self, level, column, row):
        """Bounding box of the tile (x1, y1, x2, y2)"""
        assert 0 <= level and level < self.num_levels, "Invalid pyramid level"
        # tile offset
        offset_x = 0 if column == 0 else self.tile_overlap
        offset_y = 0 if row    == 0 else self.tile_overlap
        
        # position
        x = (column * self.tile_size) - offset_x 
        y = (row    * self.tile_size) - offset_y

        # dimensions of given level
        level_width, level_height = self.get_level_dimensions(level)
        
        # find the dimensions of the tile
        w = self.tile_size + (1 if column == 0 else 2) * self.tile_overlap
        h = self.tile_size + (1 if row    == 0 else 2) * self.tile_overlap
        
        w = min(w, level_width  - x)
        h = min(h, level_height - y)
        
        return x, y, x + w, y + h
    
    def get_level_image(self, level):
        assert 0 <= level and level < self.num_levels, "Invalid pyramid level"
        w, h = self.get_level_dimensions(level)
        # don't transform to what we already have
        if self.width == w and self.height == h: 
            return self.image
        
        if self.resize_filter is None:
            return self.image.resize((w, h), Image.ANTIALIAS) 
        return self.image.resize((w, h), self.resize_filter)
    
    def iter_tiles(self, level):
        columns, rows = self.get_num_tiles(level)
        for column in xrange(columns):
            for row in xrange(rows):
                yield (column, row), (self.get_tile_bounds(level, column, row))

    def create(self, source, destination):
        self.image = Image.open(source)
        self.width, self.height = self.image.size
        self.num_levels = int(math.ceil(math.log(max((self.width, self.height)), 2))) + 1
        destination = _expand(destination)
        image_name = os.path.splitext(os.path.basename(destination))[0]
        image_files = _ensure(os.path.join(_ensure(os.path.dirname(destination)), "%s_files"%image_name))
        
        # store images
        for level in xrange(self.num_levels):
            level_dir = _ensure(os.path.join(image_files, str(level)))
            level_image = self.get_level_image(level)
            for (col, row), bounds in self.iter_tiles(level):
                tile = level_image.crop(bounds)
                tile_path = os.path.join(level_dir, "%s_%s.%s"%(col, row, self.tile_format))
                tile_file = open(tile_path, "wb+")
                if self.tile_format == "jpg":
                    tile.save(tile_file, "JPEG", quality=int(self.image_quality * 100))
                tile.save(tile_file)

        # store dzi file
        fh = open(destination, "w+")
        fh.write(DZI_TEMPLATE%(self.__dict__))
        fh.close()
        
def _expand(d):
    return os.path.abspath(os.path.expanduser(os.path.expandvars(d)))

def _ensure(d):
    if not os.path.exists(d):
        os.mkdir(d)
    return d

def _clamp(val, min, max):
    if val < min:
        return min
    elif val > max:
        return max
    return val

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
                      help="Type of filter for resizing (bicubic, nearest, bilinear, antialias (best)")

    (options, args) = parser.parse_args()

    if not args:
        parser.print_help()
        sys.exit(1)
    source = _expand(args[0])
    
    if not os.path.exists(source):
        print "Invalid File", source
        sys.exit(1)
        
    if not options.destination:
        options.destination = os.path.splitext(source)[0] + ".dzi"
    if options.resize_filter and options.resize_filter in resize_filter_map:
        options.resize_filter = resize_filter_map[ options.resize_filter ]

    creator = ImageCreator(tile_size=options.tile_size, tile_format=options.tile_format,
                           image_quality=options.image_quality, resize_filter=options.resize_filter)
    creator.create(source, options.destination)
    
if __name__ == "__main__":
    main()