################################################################################
#
#   OpenZoom Tools
#
#   Copyright (c) 2008, Daniel Gasienica <daniel@gasienica.ch>
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

import elementtree.ElementTree as ET
import math

OPENZOOM_NAMESPACE = "http://ns.openzoom.org/openzoom/2008"

DESCRIPTOR_TEMPLATE_HEADER = """\
<?xml version="1.0" encoding="UTF-8"?>
<image xmlns="http://ns.openzoom.org/openzoom/2008">
    <pyramid width="%(width)s" height="%(height)s" tileWidth="%(tile_width)s" tileHeight="%(tile_height)s" tileOverlap="%(tile_overlap)s" type="%(type)s" origin="%(origin)s">\
"""

LEVEL_TEMPLATE_HEADER = """\
        <level width="%(width)s" height="%(height)s" columns="%(columns)s" rows="%(rows)s">\
"""

URI_TEMPLATE = """\
            <uri template="http://t0.gasi.ch/images/2442317595/image_files/11/{column}_{row}.jpg"/>\
"""
            
LEVEL_TEMPLATE_FOOTER = """\
        </level>\
"""
    
DESCRIPTOR_TEMPLATE_FOOTER = """\
    </pyramid>
</image>\
"""

DEEPZOOM_NAMESPACE = "http://schemas.microsoft.com/deepzoom/2008"

_mime_type_map = { "jpg": "image/jpeg",
                   "png": "image/png" }


class MultiScaleImageDescriptor(object):
    pass

class DZIDescriptor(MultiScaleImageDescriptor):
    
    def load(self, source):
        tree = ET.parse(source)
        image = tree.getroot()
        size = tree.find("{%s}Size"%DEEPZOOM_NAMESPACE)

        self.width = int(size.attrib["Width"])
        self.height = int(size.attrib["Height"])
        self.tile_width = self.tile_height = int(image.attrib["TileSize"])
        self.tile_overlap = int(image.attrib["Overlap"])
        self.type = _mime_type_map[image.attrib["Format"]]
        self.origin = "topLeft"
        
        self.levels = int(math.ceil(math.log(max((self.width, self.height)), 2)))
    
    def get_level_dimensions(self, level):
        assert 0 <= level and level <= self.levels, "Invalid pyramid level"
        scale = self.get_level_scale(level)
        return int(math.ceil(self.width * scale)), int(math.ceil(self.height * scale))

    def get_level_scale(self, level):
        #print math.pow( 0.5, self.levels - level )
        return 1.0 / ( 1 << ( self.levels - level ))

    def get_level_tiles(self, level):
        w, h = self.get_level_dimensions( level )
        return (int(math.ceil(float(w) / self.tile_width)), int(math.ceil(float(h) / self.tile_height)))
    

class OpenZoomDescriptor(MultiScaleImageDescriptor):
    def __init__(self, uris=None):
        if uris is None:
            self.uris = []
        self.uris = uris
    
    def save(self, destination):
        dzi = self.provider
        print DESCRIPTOR_TEMPLATE_HEADER%(dzi.__dict__)
        for level in xrange(dzi.levels + 1):
            w, h = dzi.get_level_dimensions(level)
            c, r = dzi.get_level_tiles(level)
            print LEVEL_TEMPLATE_HEADER%{"width": w, "height": h, "columns": c, "rows": r}
            print URI_TEMPLATE
            print LEVEL_TEMPLATE_FOOTER
        print DESCRIPTOR_TEMPLATE_FOOTER
    
    def load(self, source):
        self.provider = DZIDescriptor()
        self.provider.load(source)