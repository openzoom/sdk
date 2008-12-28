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
import os
import os.path
import urllib
from ftplib import FTP
import shutil
import zipfile

#tag_template = u"openzoom:source=http://static.gasi.ch/images/%(photo_id)s/image.xml"
tag_template = u"rendezvous:source=http://static.gasi.ch/rendezvous/%(photo_id)s/image.dzi"

def upload(ftp, file):
    ext = os.path.splitext(file)[1]
    if ext in (".txt", ".htm", ".html", ".dzi", ".xml"):
        ftp.storlines("STOR " + file, open(file))
    else:
        ftp.storbinary("STOR " + file, open(file, "rb"), 1024)

def photo_iter(flickr, user_id):
    response = flickr.people_getInfo(user_id=user_id)
    photo_count = int(response.find("person").find("photos").find("count").text)
    page_size = 500
    num_pages = int(math.ceil(float(photo_count)/page_size))
    for page in range(1,num_pages+1):
        response = flickr.people_getPublicPhotos(user_id=user_id, per_page=page_size, page=page)
        for photo in response.getiterator("photo"):
            yield photo
    

def main():
    path = config.WORKING_DIR
    
    # Prepare working directory
    if os.path.exists(path):
        shutil.rmtree(path)
    
    os.mkdir(path)
    
    # Prepare Deep Zoom Tools
    image_creator = deepzoom.ImageCreator()

    # FTP
    ftp = FTP(config.FTP_HOST)    
    ftp.login(config.FTP_USER, config.FTP_PASSWORD)
    ftp.cwd(config.FTP_PATH)

    # Flickr
    flickr = flickrapi.FlickrAPI(config.API_KEY, config.API_SECRET)
    
    # Authentication
    (token, frob) = flickr.get_token_part_one(perms="write")
    if not token: raw_input("Press ENTER after you authorized this program")
    flickr.get_token_part_two((token, frob))

    # Rendez-vous
    user_id = config.USER_ID
    
    for photo in photo_iter(flickr, user_id):
        photo_id = photo.attrib["id"]
        print photo_id
        flickr.photos_setMeta(photo_id=photo_id, title="Generator Love", description="Love will tear us apart.")
        
    print "Done"
    
#    response = flickr.people_getInfo(user_id=user_id)
#    photo_count = int(response.find("person").find("photos").find("count").text)
#    
#    page_size = 500
#    num_pages = int(math.ceil(float(photo_count)/page_size))
#    for page in range(1,num_pages+1):
#        response = flickr.people_getPublicPhotos(user_id=user_id, per_page=page_size, page=page)
#        for photo in response.getiterator("photo"):
#            photo_id = photo.attrib["id"]
#            photo_title = photo.attrib["title"]
#            
#            # Begin operation
#            print "############################################################"
#            print "Hello,", photo_title, "(%s)"%photo_id
#            print "############################################################"
            
            # Get URL of largest image available
#            response = flickr.photos_getSizes(photo_id=photo_id)
#            photo_url = response.findall("sizes/size")[-1].attrib["source"]
            
            # Download image
#            local_file = path + "/" + photo_id + os.path.splitext( photo_url )[1]
#            urllib.urlretrieve(photo_url, local_file)
#            print "Download from Flickr. OK."
            
            # Create pyramid
#            base_name = path + "/" + photo_id + "/image"
#            dzi_file = base_name + ".dzi"
#            image_creator.create(local_file, dzi_file)
#            print "Image pyramid generated. OK."
            
            # TODO: Create OpenZoom descriptor
#            openzoom_file = base_name + ".xml"
            
            # Delete original
#            if os.path.exists(local_file):
#                os.remove(local_file)
#                print "Original deleted. OK."
            
            # ZIP
#            zip_name = path + "/" + photo_id + ".zip"
#            zip_file = zipfile.ZipFile(zip_name, "w")
#            os.chdir(path)
#            for root, dirs, files in os.walk(photo_id):
#                for file_name in files:
#                    part_name = os.path.join(root,file_name)
#                    zip_file.write(part_name)
#            zip_file.close()
#            os.chdir("..")
#            print "ZIP archive created. OK."
            
            # Delete pyramid
#            shutil.rmtree(path + "/" + photo_id)
#            print "Pyramid deleted. OK."

            # Upload
#            upload(ftp, zip_name)
#            print "ZIP uploaded. OK."

            # Delete ZIP
#            if os.path.exists(zip_name):
#                os.remove(zip_name)
#                print "ZIP deleted. OK."
            
            # Set machine tag
#            tag = tag_template % {"photo_id": photo_id}
#            flickr.photos_addTags(photo_id=photo_id,tags=tag)
#            print "Flickr machine tag added. OK."

#            flickr.photos_setMeta(photo_id=photo_id, title="", description="")
#            print "Photo metadata reset."
            
    # Clean up
#    ftp.close()
#    print "Done."

if __name__ == "__main__":
    main()