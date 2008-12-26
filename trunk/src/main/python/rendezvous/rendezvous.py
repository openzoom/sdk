################################################################################
#
#   OpenZoom Flickr Rendezvous
#
#   Copyright (c) 2007-2008, Daniel Gasienica <daniel@gasienica.ch>
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

import flickrapi
import config
import urllib
import os.path
import os

tag_template = u"openzoom:source=http://static.gasi.ch/images/%(photo_id)s/image.xml"

def main():
    flickr = flickrapi.FlickrAPI(config.API_KEY, config.API_SECRET)

    # Authentication
    (token, frob) = flickr.get_token_part_one(perms="write")
    if not token: raw_input("Press ENTER after you authorized this program")
    flickr.get_token_part_two((token, frob))

    # Get it rollin'
    user_id = config.USER_ID
    response = flickr.people_getPublicPhotos(user_id=user_id, per_page="10")
    
    for photo in response.getiterator("photo"):
        photo_id = photo.attrib["id"]
        tag = tag_template % {"photo_id": photo_id}
        flickr.photos_addTags(photo_id=photo_id,tags=tag)
    
    print "Done."

if __name__ == "__main__":
    main()