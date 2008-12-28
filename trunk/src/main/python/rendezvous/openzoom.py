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

OPENZOOM_NAMESPACE = "http://ns.openzoom.org/openzoom/2008"
DEEPZOOM_NAMESPACE = "http://schemas.microsoft.com/deepzoom/2008"

_mime_type_map = { "jpg": "image/jpeg",
                   "png": "image/png" }

DESCRIPTOR_TEMPLATE_HEADER = """\
<?xml version="1.0" encoding="UTF-8"?>
<image xmlns="http://ns.openzoom.org/openzoom/2008">
    <pyramid width="%(width)s" height="%(height)s" tileWidth="%(tile_width)s" tileHeight="%(tile_height)s" tileOverlap="%(tile_overlap)s" type="%(mime_type)s" origin="%(origin)s">
"""
    
DESCRIPTOR_TEMPLATE_FOOTER = """\
    </pyramid>
</image>"""


class Descriptor:
    def __init__(self, uris=None):
        if uris is None:
            self.uris = []
        self.uris = uris
    
    def create_from_dzi(self, source, destination=""):
        tree = ET.parse(source)
        image = tree.getroot()
        size = tree.find("{%s}Size"%DEEPZOOM_NAMESPACE)

        self.width = int(size.attrib["Width"])
        self.height = int(size.attrib["Height"])
        self.tile_width = self.tile_height = int(image.attrib["TileSize"])
        self.tile_overlap = int(image.attrib["Overlap"])
        self.mime_type = _mime_type_map[image.attrib["Format"]]
        self.origin = "topLeft"
        
        print DESCRIPTOR_TEMPLATE_HEADER%(self.__dict__)
        
        # <pyramid width="2448" height="2448" tileWidth="256" tileHeight="256" tileOverlap="1" type="image/jpeg" origin="topLeft">
        
#        image = ET.Element("image")
#        pyramid = ET.SubElement(image, "pyramid")
#        pyramid.attrib["width"] = str(self.width)
#        pyramid.attrib["height"] = str(self.height)
#        pyramid.attrib["tileWidth"] = str(self.tile_width)
#        pyramid.attrib["tileHeight"] = str(self.tile_height)
#        pyramid.attrib["tileOverlap"] = str(self.tile_overlap)
#        pyramid.attrib["type"] = str(self.mime_type)
#        pyramid.attrib["origin"] = str(self.origin)
        
#        tree = ET.ElementTree(image)
#        print ET.dump(tree)
        
#        print self.width, self.height, self.tile_width, self.tile_height, self.tile_overlap, self.mime_type