##
#   OpenZoom Caral
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

import deepzoom
import math
import os.path
import PIL.Image
import xml.dom.minidom

NS_OPENZOOM = "http://ns.openzoom.org/openzoom/2008"

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
        file.write(self.get_xml(destination))
        file.close()
    
    def add_source(self, dimension=0):
        max_dimension = max(self.width, self.height)
        if dimension == 0:
            self.sources.append(max_dimension)
        if dimension > 0 and dimension <= max_dimension:
            self.sources.append(dimension)
        
    def add_uri(self, uri):
        self.uris.append(uri)
    
    def get_xml(self, destination):
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
        
        self.sources.sort()
        for dimension in self.sources:
            width, height = self.get_dimensions(dimension)
            source_node = doc.createElementNS(NS_OPENZOOM, "source")
            source_node.setAttribute("width", str(width))
            source_node.setAttribute("height", str(height))
            source_node.setAttribute("type", str(mime_type_map[dzi.tile_format]))
            source_node.setAttribute("uri", self.get_source_name(destination, width, height) + "." + dzi.tile_format)
            image.appendChild(source_node)
        
        for level in xrange(dzi.num_levels):
            width, height = dzi.get_dimensions(level)
            columns, rows = dzi.get_num_tiles(level)
            level_node = doc.createElementNS(NS_OPENZOOM, "level")
            level_node.setAttribute("width", str(width))
            level_node.setAttribute("height", str(height))
            level_node.setAttribute("columns", str(columns))
            level_node.setAttribute("rows", str(rows))
                                          
            file_name = os.path.splitext(os.path.basename(self.source))[0]
            if not self.uris:
                uri = file_name + "_files/%(level)s/{column}_{row}.jpg"%{"level": level}
                uri_node = doc.createElementNS(NS_OPENZOOM, "uri")
                uri_node.setAttribute("template", uri)
                level_node.appendChild(uri_node)
            else:
                for uri in self.uris:
                    uri += "/" + file_name + "_files/%(level)s/{column}_{row}.jpg"%{"level": level}
                    uri_node = doc.createElementNS(NS_OPENZOOM, "uri")
                    uri_node.setAttribute("template", uri)
                    level_node.appendChild(uri_node)
            pyramid.appendChild(level_node)
        image.appendChild(pyramid)
        doc.appendChild(image)
#        descriptor = doc.toxml(encoding="UTF-8")
        descriptor = doc.toprettyxml(indent="    ", encoding="UTF-8")
        return descriptor
    
    def get_dimensions(self, longest_side):
        if longest_side == 0:
            return self.width, self.height
        
        aspect_ratio = self.width / float(self.height)
        if aspect_ratio > 1:
            width = longest_side
            height = int(round(longest_side / aspect_ratio))
        else:
            width = int(round(longest_side * aspect_ratio))
            height = longest_side
        return width, height
    
    def get_source_name(self, destination, width, height):
        name = os.path.basename(os.path.dirname(destination))
        return "%s-%sx%s"%(name, width, height)
    
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
        self.creator = deepzoom.ImageCreator(tile_size, tile_overlap, tile_format,
                                             image_quality, resize_filter)

    def create(self, source, destination, sources=[]):
        """Creates OpenZoom image from a source file and saves it to destination."""
        self.basename = os.path.basename(source)
        dzi = destination + "/image.dzi"
        self.creator.create(source, dzi)
        self.descriptor = OpenZoomDescriptor()
        self.descriptor.open(dzi , "dzi")
        for dimension in sources:
            self.descriptor.add_source(dimension)
        for dimension in self.descriptor.sources:
            width, height = self.descriptor.get_dimensions(dimension)
            image = PIL.Image.open(source)
            image = image.resize((width, height), PIL.Image.ANTIALIAS)
            ext = os.path.splitext(self.basename)[1]
            file_name = self.descriptor.get_source_name(dzi, width, height) + ext  
            image.save(destination + "/" + file_name)
        self.descriptor.save(destination + "/image.xml")