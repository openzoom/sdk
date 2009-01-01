################################################################################
#
#   OpenZoom Tools
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
################################################################################

import elementtree.ElementTree as ET
import deepzoom
import math

OPENZOOM_NAMESPACE = "http://ns.openzoom.org/openzoom/2008"

# Python 3 compatible format string

#DESCRIPTOR_TEMPLATE_HEADER = """\
#<?xml version="1.0" encoding="UTF-8"?>
#<image xmlns="http://ns.openzoom.org/openzoom/2008">
#    <pyramid width="{width}" height="{height}" tileWidth="{tile_width}" tileHeight="{tile_height}" tileOverlap="{tile_overlap}" type="{type}" origin="{origin}">\
#"""

DESCRIPTOR_TEMPLATE_HEADER = """\
<?xml version="1.0" encoding="UTF-8"?>
<image xmlns="http://ns.openzoom.org/openzoom/2008">
    <pyramid width="%(width)s" height="%(height)s" tileWidth="%(tile_width)s" tileHeight="%(tile_height)s" tileOverlap="%(tile_overlap)s" type="%(type)s" origin="%(origin)s">\
"""

LEVEL_TEMPLATE_HEADER = """\
        <level width="%(width)s" height="%(height)s" columns="%(columns)s" rows="%(rows)s">\
"""

URI_TEMPLATE = """\
            <uri template="http://t0.gasi.ch/rendezvous/%(photo_id)s/image_files/%(level)s/{column}_{row}.jpg"/>
            <uri template="http://t1.gasi.ch/rendezvous/%(photo_id)s/image_files/%(level)s/{column}_{row}.jpg"/>
            <uri template="http://t2.gasi.ch/rendezvous/%(photo_id)s/image_files/%(level)s/{column}_{row}.jpg"/>
            <uri template="http://t3.gasi.ch/rendezvous/%(photo_id)s/image_files/%(level)s/{column}_{row}.jpg"/>\
"""
            
LEVEL_TEMPLATE_FOOTER = """\
        </level>\
"""
    
DESCRIPTOR_TEMPLATE_FOOTER = """\
    </pyramid>
</image>\
"""

mime_type_map = { "jpg": "image/jpeg",
                  "png": "image/png" }


class OpenZoomDescriptor(object):
    def __init__(self, photo_id, uris=None):
        self.photo_id = photo_id
        if uris is None:
            self.uris = []
        self.uris = uris
    
    def __str__(self):
        dzi = self.provider
        out = ""
        out += DESCRIPTOR_TEMPLATE_HEADER%{"width": self.width,
                                           "height": self.height,
                                           "tile_width": self.tile_width,
                                           "tile_height": self.tile_height,
                                           "tile_overlap": self.tile_overlap,
                                           "type": self.type,
                                           "origin": self.origin} + "\n"
        for level in xrange(dzi.num_levels):
            width, height = dzi.get_dimensions(level)
            columns, rows = dzi.get_num_tiles(level)
            out += LEVEL_TEMPLATE_HEADER%{"width": width, "height": height,
                                          "columns": columns, "rows": rows} + "\n"
            out += URI_TEMPLATE%{"level": level, "photo_id": self.photo_id} + "\n"
            out += LEVEL_TEMPLATE_FOOTER + "\n"
        out += DESCRIPTOR_TEMPLATE_FOOTER
        return out
    
    def open(self, source, type="openzoom"):
        if type == "dzi":
            self.provider = deepzoom.DZIDescriptor()
            self.provider.open(source)
       
    @property
    def width(self):
        return self.provider.width
    
    @property
    def height(self):
        return self.provider.height
    
    @property
    def tile_width(self):
        return self.provider.tile_size
    
    @property
    def tile_height(self):
        return self.provider.tile_size
    
    @property
    def tile_overlap(self):
        return self.provider.tile_overlap
    
    @property
    def type(self):
        return mime_type_map[self.provider.tile_format]
    
    @property
    def origin(self):
        return "topLeft"