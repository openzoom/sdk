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

import deepzoom
import math
import os.path
import xml.dom.minidom

NS_OPENZOOM = "http://ns.openzoom.org/openzoom/2008"

DESCRIPTOR_TEMPLATE_HEADER = """\
<?xml version="1.0" encoding="UTF-8"?>
<image xmlns="http://ns.openzoom.org/openzoom/2008">
    <pyramid width="%(width)s" height="%(height)s" tileWidth="%(tile_width)s" tileHeight="%(tile_height)s" tileOverlap="%(tile_overlap)s" type="%(type)s" origin="%(origin)s">\
"""

LEVEL_TEMPLATE_HEADER = """\
        <level width="%(width)s" height="%(height)s" columns="%(columns)s" rows="%(rows)s">\
"""

URI_TEMPLATE = """\
            <uri template="%(uri_template)s"/>\
"""
            
LEVEL_TEMPLATE_FOOTER = """\
        </level>\
"""
    
DESCRIPTOR_TEMPLATE_FOOTER = """\
    </pyramid>
</image>\
"""

mime_type_map = {"jpg": "image/jpeg",
                 "png": "image/png"}


class OpenZoomDescriptor(object):
    def __init__(self):
        self.uris = []
        self.sources = []
    
    def create(self, source, destination):
        pass
    
    def open(self, source, type="openzoom"):
        if type == "dzi":
            self.source = source
            self.provider = deepzoom.DZIDescriptor()
            self.provider.open(source)
        
    def save(self, destination):
        """Save descriptor file."""
        file = open(destination, "w+")
        file.write(self.get_xml())
        file.close()
    
    def add_source(self, dimension, format="jpg"):
        self.sources.append({dimension: dimension, format: format})
        
    def add_uri(self, uri):
        self.uris.append(uri)
    
    def get_xml(self):
        dzi = self.provider
        doc = xml.dom.minidom.Document()
        
        image = doc.createElementNS(NS_OPENZOOM, "image")
        image.setAttribute("xmlns", NS_OPENZOOM)
        
        pyramid = doc.createElementNS(NS_OPENZOOM, "pyramid")
        pyramid.setAttribute("width", str(self.width))
        pyramid.setAttribute("height", str(self.height))
        pyramid.setAttribute("tileWidth", str(self.tile_width))
        pyramid.setAttribute("tileHeight", str(self.tile_height))
        pyramid.setAttribute("tileOverlap", str(self.tile_overlap))
        pyramid.setAttribute("type", str(self.type))
        pyramid.setAttribute("origin", str(self.origin))
        
#        out = ""
#        out += DESCRIPTOR_TEMPLATE_HEADER%{"width": self.width,
#                                           "height": self.height,
#                                           "tile_width": self.tile_width,
#                                           "tile_height": self.tile_height,
#                                           "tile_overlap": self.tile_overlap,
#                                           "type": self.type,
#                                           "origin": self.origin} + "\n"
        for level in xrange(dzi.num_levels):
            width, height = dzi.get_dimensions(level)
            columns, rows = dzi.get_num_tiles(level)
            level_node = doc.createElementNS(NS_OPENZOOM, "level")
            level_node.setAttribute("width", str(width))
            level_node.setAttribute("height", str(height))
            level_node.setAttribute("columns", str(columns))
            level_node.setAttribute("rows", str(rows))
#            out += LEVEL_TEMPLATE_HEADER%{"width": width, "height": height,
#                                          "columns": columns, "rows": rows} + "\n"
                                          
            file_name = os.path.splitext(os.path.basename(self.source))[0]
            if not self.uris:
                uri = file_name + "_files/%(level)s/{column}_{row}.jpg"%{"level": level}
                uri_node = doc.createElementNS(NS_OPENZOOM, "uri")
                uri_node.setAttribute("template", uri)
#                out += URI_TEMPLATE%{"uri_template": uri} + "\n"
                level_node.appendChild(uri_node)
            else:
                for uri in self.uris:
                    uri += "/" + file_name + "_files/%(level)s/{column}_{row}.jpg"%{"level": level}
                    uri_node = doc.createElementNS(NS_OPENZOOM, "uri")
                    uri_node.setAttribute("template", uri)
#                    out += URI_TEMPLATE%{"uri_template": uri} + "\n"
                    level_node.appendChild(uri_node)
#            out += LEVEL_TEMPLATE_FOOTER + "\n"
            pyramid.appendChild(level_node)
#        out += DESCRIPTOR_TEMPLATE_FOOTER
        image.appendChild(pyramid)
        doc.appendChild(image)
#        return out
        descriptor = doc.toprettyxml(indent="  ", encoding="UTF-8")
#        descriptor = doc.toxml(encoding="UTF-8")
        return descriptor
       
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


class ImageCreator(object):
    """Creates OpenZoom images."""
    def __init__(self, tile_size=256, tile_overlap=1, tile_format="jpg",
                 image_quality=0.95, resize_filter=None):
        self.creator = deepzoom.ImageCreator(tile_size, tile_overlap, tile_format, image_quality, resize_filter)

    def create(self, source, destination, sources=[]):
        """Creates OpenZoom image from a source file and saves it to destination."""
        self.basename = os.path.basename(source)
        dzi = destination + "/image.dzi"
        self.creator.create(source, dzi)
        self.descriptor = OpenZoomDescriptor()
        self.descriptor.open(dzi , "dzi")
        for source in sources:
            self.descriptor.add_source(source)
        self.descriptor.save(destination + "/image.xml")