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

import config
import deepzoom
import flickrapi
import math
import os.path
import os
import urllib
from ftplib import FTP

#tag_template = u"openzoom:source=http://static.gasi.ch/images/%(photo_id)s/image.xml"
tag_template = u"rendezvous:source=http://static.gasi.ch/rendezvous/%(photo_id)s/image.dzi"

def main():
    # Prepare Deep Zoom Tools
    image_creator = deepzoom.ImageCreator()

    # FTP
    ftp = FTP(config.FTP_HOST)    
    ftp.login(config.FTP_USER, config.FTP_PASSWORD)

    # Flickr
    flickr = flickrapi.FlickrAPI(config.API_KEY, config.API_SECRET)
    
    # Authentication
    (token, frob) = flickr.get_token_part_one(perms="write")
    if not token: raw_input("Press ENTER after you authorized this program")
    flickr.get_token_part_two((token, frob))

    # Rendez-vous
    user_id = config.USER_ID
    
    response = flickr.people_getInfo(user_id=user_id)
    photo_count = int(response.find("person").find("photos").find("count").text)
    
    page_size = 5
    num_pages = int(math.ceil(float(photo_count)/page_size))
    for page in range(1,num_pages+1):
        response = flickr.people_getPublicPhotos(user_id=user_id, per_page=page_size, page=page)
        for photo in response.getiterator("photo"):
            photo_id = photo.attrib["id"]
            
            # Get URL of largest image available
            response = flickr.photos_getSizes(photo_id=photo_id)
            photo_url = response.findall("sizes/size")[-1].attrib["source"]
            
            # Download image
            path = "rendezvous"
            local_file = path + "/" + photo_id + os.path.splitext( photo_url )[1]
            pyramid_file = path + "/" + photo_id + "/image.dzi"
            urllib.urlretrieve(photo_url, local_file)
            print photo_id + " ...downloaded."
            
            # Create pyramid
            image_creator.create(local_file, pyramid_file)
            print photo_id + " ...image pyramid created."
            
            # Delete original
            os.remove(local_file)
            print photo_id + " ...deleted original."
            
            # ZIP
            
            # Create OpenZoom descriptor
            
            # Upload
            
            # Set machine tag
#            tag = tag_template % {"photo_id": photo_id}
#            flickr.photos_addTags(photo_id=photo_id,tags=tag)
    print "Done."

if __name__ == "__main__":
    main()