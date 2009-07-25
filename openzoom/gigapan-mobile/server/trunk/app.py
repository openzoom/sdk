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
import uuid
import xml.dom.minidom

DZI_URL = "http://gigapan-mobile.appspot.com/gigapan/%d.dzi"
DZI_TEMPLATE = """\
<?xml version="1.0" encoding="UTF-8"?>
<Image TileSize="256" Overlap="0" Format="jpg" xmlns="http://schemas.microsoft.com/deepzoom/2008">
    <Size Width="%(width)s" Height="%(height)s"/>
</Image>"""

API_MOST_POPULAR = "http://api.gigapan.org/beta/gigapans/most_popular.json"
API_MOST_RECENT = "http://api.gigapan.org/beta/gigapans/most_recent.json"
API_GIGAPAN = "http://api.gigapan.org/beta/gigapans/%d.json"
API_GIGAPAN_USER = "http://gigapan.org/viewProfile.php?userid=%d"
FEED_ICON_URL = "http://gigapan-mobile.appspot.com/static/images/gigapan.jpg"

def get_gigapan(id):
    gigapan = db.Query(GigaPan).filter("id=", id).get()
    if not gigapan:
        descriptor_json = fetch(API_GIGAPAN%id)
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

class Feed(db.Model):
    content = db.TextProperty()

class MainRequestHandler(webapp.RequestHandler):
    def get(self):
        self.response.headers["Content-Type"] = "text/plain"
        self.response.out.write("Welcome to GigaPan Mobile. Powered by OpenZoom.org. Developed by Daniel Gasienica (daniel@gasienica.ch)")

class EchoRequestHandler(webapp.RequestHandler):
    def get(self):
        self.response.headers["Content-Type"] = "text/plain"
        self.response.out.write(self.request.headers["User-Agent"])
        
class FeedRequestHandler(webapp.RequestHandler):
    def get(self):
        self.response.headers["Content-Type"] = "application/xml"
        
        feed = db.Query(Feed).get()
        if feed:
            self.response.out.write(feed.content)
        else:
            self.error(404)
            return

def create_feed(doc, node, url, heading):
    data_json = fetch(url, deadline=10)
    data = json.loads(data_json.content)
    
    for item in data["items"]:
        gigapan_id = item[1]["id"]
        gigapan_title = item[1]["name"].strip()
        gigapan_author = item[1]["owner"]["first_name"] + " " + item[1]["owner"]["last_name"]
        gigapan_author = gigapan_author.strip()
        gigapan_author_id = item[1]["owner"]["id"]

        item = doc.createElement("item")
        
        category = doc.createElement("category")
        category_text = doc.createTextNode(heading)
        category.appendChild(category_text)
        item.appendChild(category)
        
        title = doc.createElement("title")
        title_text = doc.createTextNode(gigapan_title)
        title.appendChild(title_text)
        item.appendChild(title)
        
        guid = doc.createElement("guid")
#        guid_text = doc.createTextNode(DZI_URL%gigapan_id)
        guid_text = doc.createTextNode(str(uuid.uuid1()))
        guid.appendChild(guid_text)
        item.appendChild(guid)
        
        source = doc.createElement("source")
        source.setAttribute("url", API_GIGAPAN_USER%gigapan_author_id)
        source_text = doc.createTextNode(gigapan_author)
        source.appendChild(source_text)
        item.appendChild(source)
        
        enclosure = doc.createElement("enclosure")
        enclosure.setAttribute("type", "text/xml")
        enclosure.setAttribute("length", "0")
        enclosure.setAttribute("url", DZI_URL%gigapan_id)
        item.appendChild(enclosure)
        
        enclosure = doc.createElement("enclosure")
        enclosure.setAttribute("type", "image/jpeg")
        enclosure.setAttribute("length", "0")
        enclosure.setAttribute("url", FEED_ICON_URL)
        item.appendChild(enclosure)
        
        node.appendChild(item)
        
class FeedTaskRequestHandler(webapp.RequestHandler):
    doc = xml.dom.minidom.Document()
    
    # RSS
    rss = doc.createElement("rss")
    rss.setAttribute("version", "2.0")
    
    channel = doc.createElement("channel")
    
    title = doc.createElement("title")
    title_text = doc.createTextNode("GigaPan")
    title.appendChild(title_text)
    channel.appendChild(title)
    
    link = doc.createElement("link")
    link_text = doc.createTextNode("http://gigapan.org")
    link.appendChild(link_text)
    channel.appendChild(link)
    
    image = doc.createElement("image")

    title = doc.createElement("title")
    title_text = doc.createTextNode("GigaPan")
    title.appendChild(title_text)
    image.appendChild(title)
    
    url = doc.createElement("url")
    url_text = doc.createTextNode(FEED_ICON_URL)
    url.appendChild(url_text)
    image.appendChild(url)
    
    link = doc.createElement("link")
    link_text = doc.createTextNode("http://gigapan.org")
    link.appendChild(link_text)
    image.appendChild(link)
    
    channel.appendChild(image)

    description = doc.createElement("description")
    description_text = doc.createTextNode("Photos from GigaPan.org")
    description.appendChild(description_text)
    channel.appendChild(description)
    
    language = doc.createElement("language")
    language_text = doc.createTextNode("en-us")
    language.appendChild(language_text)
    channel.appendChild(language)
    
    create_feed(doc, channel, API_MOST_POPULAR, "Most Popular")
    create_feed(doc, channel, API_MOST_RECENT, "Most Recent")
    
    rss.appendChild(channel)
    doc.appendChild(rss)
    
    feed = db.Query(Feed).get()
    if not feed:
        feed = Feed()
    feed.content = db.Text(doc.toxml("utf-8"))
    feed.put()

class DescriptorRequestHandler(webapp.RequestHandler):
    def get(self, *groups):
        id = int(groups[0])
        try:
            gigapan = get_gigapan(id)
        except:
            self.error(404)
            return
        self.response.headers["Content-Type"] = "application/xml"
        self.response.out.write(DZI_TEMPLATE%{"width": gigapan.width, "height": gigapan.height})
   
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
                                      ("/echo/?", EchoRequestHandler),
                                      ("/feed/?", FeedRequestHandler),
                                      ("/tasks/feed/?", FeedTaskRequestHandler),
                                      (r"^/gigapan/([0-9]+).dzi$", DescriptorRequestHandler),
                                      (r"^/gigapan/([0-9]+)_files/([0-9]+)/([0-9]+)_([0-9]+).jpg$", TileRequestHandler)],
                                      debug=True)


def main():
    run_wsgi_app(application)

if __name__ == "__main__":
    main()  