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

from google.appengine.api.images import Image
from google.appengine.api.images import crop
from google.appengine.api.urlfetch import fetch
from google.appengine.ext import db
from google.appengine.ext import webapp
from google.appengine.ext.webapp import template
from google.appengine.ext.webapp.util import run_wsgi_app

from datetime import datetime

import google.appengine.api.images
import math
import os
import random
import simplejson as json
import xml.dom.minidom

DZI_URL = "http://gigapan-mobile.appspot.com/gigapan/%d.dzi"
DZI_TEMPLATE = """<?xml version="1.0" encoding="UTF-8"?>\
<Image TileSize="256" Overlap="0" Format="jpg" xmlns="http://schemas.microsoft.com/deepzoom/2008">\
<Size Width="%(width)s" Height="%(height)s"/>\
</Image>"""

API_MOST_POPULAR = "http://api.gigapan.org/beta/gigapans/most_popular.json"
API_MOST_RECENT = "http://api.gigapan.org/beta/gigapans/most_recent.json"
API_GIGAPAN = "http://api.gigapan.org/beta/gigapans/%d.json"
API_GIGAPAN_TILE_URL = "http://tile%(tileserver)s.gigapan.org/gigapans0/%(id)d/tiles"
API_GIGAPAN_USER = "http://gigapan.org/viewProfile.php?userid=%d"
FEED_ICON_URL = "http://gigapan-mobile.appspot.com/static/images/feed-icon.jpg"
#VIEW_GIGAPAN_URL = "http://gigapan.org/viewGigapan.php?id=%d"
VIEW_GIGAPAN_URL = "http://gigapan-mobile.appspot.com/gigapan/%d"

# Data Model
class GigaPanUser(db.Model):
    id = db.IntegerProperty(required=True)
    username = db.StringProperty(required=True)
    first_name = db.StringProperty()
    last_name = db.StringProperty()

class GigaPan(db.Model):
    id = db.IntegerProperty(required=True)
    width = db.IntegerProperty(required=True)
    height = db.IntegerProperty(required=True)

    name = db.StringProperty()
    description = db.TextProperty()
    gigapixels = db.FloatProperty()
    explore_score = db.IntegerProperty()
    views = db.IntegerProperty()

    taken = db.DateTimeProperty()
    uploaded = db.DateTimeProperty()
    updated = db.DateTimeProperty()

    location = db.GeoPtProperty()
    altitude = db.FloatProperty()
    owner = db.ReferenceProperty(GigaPanUser)

def get_gigapan(id):
    gigapan = db.Query(GigaPan).filter("id =", id).get()
    if not gigapan:
        descriptor_json = fetch(API_GIGAPAN%id, deadline=10)
        descriptor = json.loads(descriptor_json.content)

        if not descriptor["id"]:
            raise

        width = int(descriptor["width"])
        height = int(descriptor["height"])
        name = descriptor["name"]
        description = descriptor["description"]
        gigapixels = float(descriptor["gigapixels"])
        explore_score = int(descriptor["explore_score"])
        views = int(descriptor["views"])
        taken = datetime.strptime(str(descriptor["taken"]), "%Y-%m-%d %H:%M:%S")
        uploaded = datetime.strptime(str(descriptor["uploaded"]), "%Y-%m-%d %H:%M:%S")
        updated = datetime.strptime(str(descriptor["updated"]), "%Y-%m-%d %H:%M:%S")

        gigapan = GigaPan(id=id, width=width, height=height)
        gigapan.name = name
        gigapan.description = db.Text(description)
        gigapan.gigapixels = gigapixels
        gigapan.explore_score = explore_score
        gigapan.views = views
        gigapan.taken = taken
        gigapan.updated = updated
        gigapan.uploaded = uploaded

        try:
            if descriptor["location"]:
                lat = float(descriptor["location"]["latitude"])
                lon = float(descriptor["location"]["longitude"])
                alt = float(descriptor["location"]["altitude"])
                gigapan.location = db.GeoPt(lat, lon)
                gigapan.altitude = alt
        except:
            pass

        if descriptor["owner"]:
            user_id = int(descriptor["owner"]["id"])
            username = descriptor["owner"]["username"]
            user = db.Query(GigaPanUser).filter("id =", user_id).get()
            if not user:
                user = GigaPanUser(id=user_id, username=username)
                user.first_name = descriptor["owner"]["first_name"]
                user.last_name = descriptor["owner"]["last_name"]
                user.put()
            gigapan.owner = user.key()

        gigapan.put()

    return gigapan

# Requests
class MainRequestHandler(webapp.RequestHandler):
    def get(self):
        template_values = {}
        path = os.path.join(os.path.dirname(__file__), "index.html")
        self.response.out.write(template.render(path, template_values))

class RecentGigaPansRequestHandler(webapp.RequestHandler):
    def get(self):
        gigapans = db.GqlQuery("SELECT * FROM GigaPan ORDER BY id DESC").fetch(25)
        for gigapan in gigapans:
            gigapan.name = smart_truncate(gigapan.name, 26)
        template_values = {"gigapans": gigapans}
        path = os.path.join(os.path.dirname(__file__), "gigapans.html")
        self.response.out.write(template.render(path, template_values))

class PopularGigaPansRequestHandler(webapp.RequestHandler):
    def get(self):
        gigapans = db.GqlQuery("SELECT * FROM GigaPan ORDER BY explore_score DESC").fetch(25)
        for gigapan in gigapans:
            gigapan.name = smart_truncate(gigapan.name, 26)
        template_values = {"gigapans": gigapans}
        path = os.path.join(os.path.dirname(__file__), "gigapans.html")
        self.response.out.write(template.render(path, template_values))

class UsersRequestHandler(webapp.RequestHandler):
    def get(self):
        users = db.GqlQuery("SELECT * FROM GigaPanUser ORDER BY username ASC").fetch(250)
        template_values = {"users": users}
        path = os.path.join(os.path.dirname(__file__), "users.html")
        self.response.out.write(template.render(path, template_values))

class UserRequestHandler(webapp.RequestHandler):
    def get(self, *groups):
        id = int(groups[0])
        user = db.Query(GigaPanUser).filter("id =", id).get()
        if not user:
            self.error(404)
        gigapans = db.GqlQuery("SELECT * FROM GigaPan WHERE owner = :1 ORDER BY id DESC", user.key()).fetch(50)
        for gigapan in gigapans:
            gigapan.name = smart_truncate(gigapan.name, 26)
        template_values = {"gigapans": gigapans}
        path = os.path.join(os.path.dirname(__file__), "gigapans.html")
        self.response.out.write(template.render(path, template_values))

class UserFeedRequestHandler(webapp.RequestHandler):
    def get(self, *groups):
        id = int(groups[0])
        user = db.Query(GigaPanUser).filter("id =", id).get()
        if not user:
            self.error(404)
        gigapans = db.GqlQuery("SELECT * FROM GigaPan WHERE owner = :1 ORDER BY id DESC", user.key()).fetch(50)
        heading = "GigaPans (%s)"%user.username
        doc = create_feed_skeleton(heading)
        create_feed(doc, gigapans, heading)

        self.response.headers["Content-Type"] = "application/rss+xml"
        self.response.out.write(doc.toxml("utf-8"))

class GigaPanRequestHandler(webapp.RequestHandler):
    def get(self, *groups):
        id = int(groups[0])
        try:
            gigapan = get_gigapan(id)
        except:
            self.error(404)
            return
        dzi = DZI_TEMPLATE%{"width": gigapan.width, "height": gigapan.height}
        template_values = {"id": id, "dzi": dzi}
        path = os.path.join(os.path.dirname(__file__), "gigapan.html")
        self.response.out.write(template.render(path, template_values))

class HighlightsFeedRequestHandler(webapp.RequestHandler):
    def get(self):
        doc = create_feed_skeleton("GigaPan Highlights")
        gigapans = db.GqlQuery("SELECT * FROM GigaPan ORDER BY id DESC").fetch(20)
        create_feed(doc, gigapans, "Most Recent")
        gigapans = db.GqlQuery("SELECT * FROM GigaPan ORDER BY explore_score DESC").fetch(20)
        create_feed(doc, gigapans, "Most Popular")

        self.response.headers["Content-Type"] = "application/rss+xml"
        self.response.out.write(doc.toxml("utf-8"))

# String Helpers
def sanitize(s, default="unknown"):
    s = "".join([x for x in s if x.isalnum() or x.isspace()])
    s = s.strip()
    if not s:
        s = default
    return s

def smart_truncate(content, length=40, suffix="..."):
    if len(content) <= length:
        return content
    else:
        return " ".join(content[:length+1].split(" ")[0:-1]) + suffix

# RSS 2.0 Feed Helpers
def create_feed_skeleton(heading):
    doc = xml.dom.minidom.Document()

    rss = doc.createElement("rss")
    rss.setAttribute("version", "2.0")

    channel = doc.createElement("channel")

    title = doc.createElement("title")
    title_text = doc.createTextNode(heading)
    title.appendChild(title_text)
    channel.appendChild(title)

    link = doc.createElement("link")
    link_text = doc.createTextNode("http://gigapan.org")
    link.appendChild(link_text)
    channel.appendChild(link)

    image = doc.createElement("image")

    title = doc.createElement("title")
    title_text = doc.createTextNode(heading)
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

    rss.appendChild(channel)
    doc.appendChild(rss)

    return doc

def create_feed(doc, gigapans, heading):
    channel = doc.getElementsByTagName("channel")[0]
    for gigapan in gigapans:
        gigapan_id = gigapan.id
        gigapan_title = sanitize(gigapan.name, "Untitled")
        gigapan_author = gigapan.owner.first_name + " " + gigapan.owner.last_name
        gigapan_author = sanitize(gigapan_author, gigapan.owner.username)
        gigapan_author_id = gigapan.owner.id

        item = doc.createElement("item")

        category = doc.createElement("category")
        category_text = doc.createTextNode(heading)
        category.appendChild(category_text)
        item.appendChild(category)

        title = doc.createElement("title")
        title_text = doc.createTextNode(gigapan_title)
        title.appendChild(title_text)
        item.appendChild(title)
        
        link = doc.createElement("link")
        link_text = doc.createTextNode(VIEW_GIGAPAN_URL%gigapan_id)
        link.appendChild(link_text)
        item.appendChild(link)

        guid = doc.createElement("guid")
        guid_text = doc.createTextNode(VIEW_GIGAPAN_URL%gigapan_id)
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

        channel.appendChild(item)

# Cron
class SyncTaskRequestHandler(webapp.RequestHandler):
    def get(self):
        data_json = fetch(API_MOST_RECENT, deadline=10)
        data = json.loads(data_json.content)

        for item in data["items"]:
            id = item[1]["id"]
            try:
                gigapan = get_gigapan(id)
            except:
                continue
        self.response.out.write(str(random.random()))

# DZI Interface
class DeepZoomImageDescriptorRequestHandler(webapp.RequestHandler):
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

        tileserver = str(int(math.floor(id / 1000.0))).zfill(2)
        url = API_GIGAPAN_TILE_URL%{"tileserver": tileserver, "id": id}
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
                                      (r"^/feed/?", HighlightsFeedRequestHandler),
                                      (r"^/tasks/sync/?", SyncTaskRequestHandler),
                                      (r"^/gigapans/recent/?", RecentGigaPansRequestHandler),
                                      (r"^/gigapans/popular/?", PopularGigaPansRequestHandler),
                                      (r"^/gigapan/([0-9]+)/?", GigaPanRequestHandler),
                                      (r"^/users/?", UsersRequestHandler),
                                      (r"^/user/([0-9]+)/feed/?", UserFeedRequestHandler),
                                      (r"^/user/([0-9]+)/?", UserRequestHandler),
                                      (r"^/gigapan/([0-9]+).dzi$", DeepZoomImageDescriptorRequestHandler),
                                      (r"^/gigapan/([0-9]+)_files/([0-9]+)/([0-9]+)_([0-9]+).jpg$", TileRequestHandler)],
                                      debug=True)

def main():
    run_wsgi_app(application)

if __name__ == "__main__":
    main()
