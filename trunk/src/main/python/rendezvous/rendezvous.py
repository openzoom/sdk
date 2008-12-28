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


# FLICKR ITERATORS

def photo_iter(flickr, user_id):
    response = flickr.people_getInfo(user_id=user_id)
    photo_count = int(response.find("person").find("photos").find("count").text)
    page_size = 500
    num_pages = int(math.ceil(float(photo_count)/page_size))
    for page in range(1,num_pages+1):
        response = flickr.people_getPublicPhotos(user_id=user_id, per_page=page_size, page=page)
        photos = response.getiterator("photo")
        for photo in photos:
            yield photo

def photo_size_iter(flickr, photo_id):
    response = flickr.photos_getSizes(photo_id=photo_id)
    sizes = response.getiterator("size")
    for size in sizes:
        yield size

def tag_iter(flickr, photo_id):
    response = flickr.photos_getInfo(photo_id=photo_id)
    tags = response.getiterator("tag")
    for tag in tags:
        yield tag

def machine_tag_iter(flickr, photo_id):
    for tag in tag_iter(flickr, photo_id):
        if int(tag.attrib["machine_tag"]) == 1:
            yield tag

def machine_tag_namespace_iter(flickr, user_id, namespace):
    for photo in photo_iter(flickr, user_id):
        photo_id = photo.attrib["id"]
        for tag in machine_tag_iter(flickr, photo_id):
            tag_namespace = tag.text.partition(":")[0]
            if tag_namespace == namespace:
                yield tag

def largest_photo_url(flickr, photo_id):
    max_size = 0
    photo_url = None
    for size in photo_size_iter(flickr, photo_id):
        w, h = int(size.attrib["width"]), int(size.attrib["height"])
        if w*h > max_size:
            max_size = w*h
            photo_url = size.attrib["source"]
    return photo_url

def reset_flickr(flickr, user_id, namespace):    
    for tag in machine_tag_namespace_iter(flickr, user_id, namespace):
        tag_id = tag.attrib["id"]
        flickr.photos_removeTag(tag_id=tag_id)

def reset_working_dir(path):
    if os.path.exists(path):
        shutil.rmtree(path)
    os.mkdir(path)

def connect_flickr(key, secret):
    flickr = flickrapi.FlickrAPI(key, secret)
    (token, frob) = flickr.get_token_part_one(perms = "write")
    if not token: raw_input("Press ENTER after you authorized this program")
    flickr.get_token_part_two((token, frob))
    return flickr

# FTP

def connect_ftp(host, user, password):
    ftp = FTP(host)    
    ftp.login(user, password)
    return ftp

def upload(ftp, file):
    ext = os.path.splitext(file)[1]
    name = os.path.basename(file)
    if ext in (".txt", ".htm", ".html", ".xml", ".dzi"):
        ftp.storlines("STOR " + name, open(file))
    else:
        ftp.storbinary("STOR " + name, open(file, "rb"), 1024)


def main():
    path = config.WORKING_DIR
#    reset_working_dir(path)
    
    # Prepare Deep Zoom Tools
    image_creator = deepzoom.ImageCreator()

    ftp = connect_ftp(config.FTP_HOST, config.FTP_USER, config.FTP_PASSWORD)
    flickr = connect_flickr(config.API_KEY, config.API_SECRET)

    # Rendez-vous
    user_id = config.USER_ID
    
    for photo in photo_iter(flickr, user_id):
        photo_id = photo.attrib["id"]
        photo_title = photo.attrib["title"]
        
        print "#################################################################"
#        print "Hello,", photo_title, "(%s)"%photo_id
        print "Hello,", "(%s)"%photo_id
        print "#################################################################"
            
        photo_url = largest_photo_url(flickr, photo_id)
        if photo_url is None:
            continue
        print photo_url
            
        # Download image
        image_path = path + "/" + photo_id
        local_file = image_path + os.path.splitext( photo_url )[1]
        if not os.path.exists(local_file):
            urllib.urlretrieve(photo_url, local_file)
            print "Download from Flickr. OK."
            
        # Create pyramid
        base_name = image_path + "/image"
        dzi_file = base_name + ".dzi"
        if not os.path.exists(dzi_file):
            image_creator.create(local_file, dzi_file)
            print "Image pyramid generated. OK."

        # TODO: Create OpenZoom descriptor
#        openzoom_file = base_name + ".xml"
        
        ftp.cwd("/")
        try:
            ftp.mkd(photo_id)
        except:
            continue
        
        os.chdir(path)
        for dirpath, dirs, files in os.walk(photo_id):
            ftp.cwd("/" + dirpath)
            for dir in dirs:
                try:
                    ftp.mkd(dir)
                except:
                    pass
            for file in files:
                try:
                    upload(ftp, os.path.join(dirpath,file))
                except:
                    print "AAAH", os.path.join(dirpath,file)
                    continue
        os.chdir("..")
        print "Image pyramid uploaded. OK."
        
        
        # Delete original
#        if os.path.exists(local_file):
#            os.remove(local_file)
#            print "Original deleted. OK."

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
#        shutil.rmtree(path + "/" + photo_id)
#        print "Image pyramid deleted. OK."

        # Upload
#        upload(ftp, zip_name)
#        print "ZIP uploaded. OK."

        # Delete ZIP
#        if os.path.exists(zip_name):
#            os.remove(zip_name)
#            print "ZIP deleted. OK."
            
            # Set machine tag
#        tag = tag_template % {"photo_id": photo_id}
#        flickr.photos_addTags(photo_id=photo_id,tags=tag)
#        print "Flickr machine tag added. OK."
            
    # Clean up
    ftp.close()
    print "Done."


if __name__ == "__main__":
    main()