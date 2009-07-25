#
#  GigaPan Mobile
#  Powered by OpenZoom.org
#
#  Copyright (c) 2009, Daniel Gasienica <daniel@gasienica.ch>
#
#  OpenZoom is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  OpenZoom is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenZoom. If not, see <http://www.gnu.org/licenses/>.

from google.appengine.ext import db
from google.appengine.ext import webapp
from google.appengine.ext.webapp.util import run_wsgi_app
from google.appengine.api.urlfetch import fetch
from google.appengine.api.images import crop
from google.appengine.api.images import Image

import google.appengine.api.images
import math
import simplejson as json


xml = """\
<?xml version="1.0" encoding="UTF-8"?>
<Image TileSize="256" Overlap="0" Format="jpg" xmlns="http://schemas.microsoft.com/deepzoom/2008">
    <Size Width="%(width)s" Height="%(height)s"/>
</Image>"""

def get_gigapan(id):
    gigapan = db.Query(GigaPan).filter("id =", id).get()
    if not gigapan:
        descriptor_json = fetch("http://api.gigapan.org/beta/gigapans/" + str(id) + ".json")
        descriptor = json.loads(descriptor_json.content)
        width = descriptor["width"]
        height = descriptor["height"]
        gigapan = GigaPan(id=id, width=width, height=height)
        gigapan.put()
    return gigapan


class GigaPan(db.Model):
    id = db.IntegerProperty(required=True)
    width = db.IntegerProperty(required=True)
    height = db.IntegerProperty(required=True)

class MainRequestHandler(webapp.RequestHandler):
    def get(self):
        self.response.headers["Content-Type"] = "text/plain"
        self.response.out.write("Welcome to GigaPan Mobile. Powered by OpenZoom.org. Developed by Daniel Gasienica (daniel@gasienica.ch)")

class EchoRequestHandler(webapp.RequestHandler):
    def get(self):
        self.response.headers["Content-Type"] = "text/plain"
        self.response.out.write(self.request.headers["User-Agent"])
    
class DescriptorRequestHandler(webapp.RequestHandler):
    def get(self, *groups):
        id = int(groups[0])
        try:
            gigapan = get_gigapan(id)
        except:
            self.error(404)
            return
        self.response.headers["Content-Type"] = "application/xml"
        self.response.out.write(xml%{"width": gigapan.width, "height": gigapan.height})
   
class TileRequestHandler(webapp.RequestHandler):
    def get(self, *groups):
        id = int(groups[0])
        level = int(groups[1])
        column = int(groups[2])
        row = int(groups[3])
        
        try:
            gigapan = get_gigapan(id)
        except:
            self.error(404)
            return
        
        self.width = gigapan.width
        self.height = gigapan.height
        self.tile_overlap = 0
        self.tile_size = 256
        self._num_levels = None
        
        url ="http://share.gigapan.org/gigapans0/" + str(id) + "/tiles"
        name = "r"
        z = max(0, level - 8)
        bit = (1 << z) >> 1
        x = column
        y = row
        
        while bit > 0:
            name += str((1 if (x & bit) else 0) + (2 if (y & bit) else 0))
            bit = bit >> 1
            
        i = 0
        while i < (len(name) - 3):
            url = url + "/" + name[i:i+3]
            i = i + 3
            
        tile_url = url + "/" + name + ".jpg"
        tile_request = fetch(tile_url)
        image_data = tile_request.content
        image = Image(image_data)
        w, h = self.get_dimensions(level)

        modified = False
        if level < 8:
            d = 2**level
            image.resize(d, d)
            image.crop(0.0, 0.0, min(w / float(d), 1.0), h / float(d))
            modified = True
        else:
            tile_x = column * self.tile_size
            tile_y = row * self.tile_size
            tile_right = tile_x + self.tile_size
            tile_bottom = tile_y + self.tile_size
            if tile_right > w or tile_bottom > h:
                factor = float(self.tile_size)
                tile_width = min(w - tile_x, self.tile_size)
                tile_height = min(h - tile_y, self.tile_size) 
                image.crop(0.0, 0.0, tile_width / factor, tile_height / factor)
                modified = True

        if modified:
            image_data = image.execute_transforms(output_encoding=google.appengine.api.images.JPEG)
            
        self.response.headers["Content-Type"] = "image/jpeg"
        self.response.out.write(image_data)

    def get_scale(self, level):
        """Scale of a pyramid level."""
        assert 0 <= level and level < self.num_levels, "Invalid pyramid level"
        max_level = self.num_levels - 1
        return math.pow(0.5, max_level - level)

    def get_dimensions(self, level):
        """Dimensions of level (width, height)"""
        assert 0 <= level and level < self.num_levels, "Invalid pyramid level"
        scale = self.get_scale(level)
        width = int(math.ceil(self.width * scale))
        height = int(math.ceil(self.height * scale))
        return (width, height)

    @property
    def num_levels(self):
        """Number of levels in the pyramid."""
        if self._num_levels is None:
            max_dimension = max(self.width, self.height)
            self._num_levels = int(math.ceil(math.log(max_dimension, 2))) + 1
        return self._num_levels


application = webapp.WSGIApplication([("/", MainRequestHandler),
                                      ("/echo", EchoRequestHandler),
                                      (r"^/gigapan/([0-9]+).dzi$", DescriptorRequestHandler),
                                      (r"^/gigapan/([0-9]+)_files/([0-9]+)/([0-9]+)_([0-9]+).jpg$", TileRequestHandler)],
                                      debug=True)


def main():
    run_wsgi_app(application)

if __name__ == "__main__":
    main()  