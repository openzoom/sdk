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

import base64
import config
import deepzoom
import flickrapi
import logging
import logging.handlers
import math
import os
import os.path
import urllib
from ftplib import FTP
import shutil
import zipfile


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

# SETUP

def reset_flickr(flickr, user_id, namespace):    
    for tag in machine_tag_namespace_iter(flickr, user_id, namespace):
        tag_id = tag.attrib["id"]
        flickr.photos_removeTag(tag_id=tag_id)

def reset_dir(path):
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


LOG_FILENAME = "log/rendezvous.log"
PRODUCTION = False

SOURCE_TAG = u"rendezvous:source="
SOURE_BASE16_TAG = u"rendezvous:base16source="
URI_TEMPLATE = u"http://static.gasi.ch/rendezvous/%(photo_id)s/image.dzi" 


def main():
    path = config.WORKING_DIR
    
    if not PRODUCTION:
        reset_dir(path)
        reset_dir(config.LOG_DIR)
    
    # Prepare Deep Zoom Tools
    image_creator = deepzoom.ImageCreator()

    # Connect
    ftp = connect_ftp(config.FTP_HOST, config.FTP_USER, config.FTP_PASSWORD)
    flickr = connect_flickr(config.API_KEY, config.API_SECRET)

    # Logging
    logger = logging.getLogger("rendezvous")
    logger.setLevel(logging.DEBUG)

    handler = logging.handlers.RotatingFileHandler(LOG_FILENAME, maxBytes=1024*250, backupCount=1000)
    formatter = logging.Formatter("%(asctime)s - %(name)s - %(levelname)s - %(message)s")
    handler.setFormatter(formatter)
    logger.addHandler(handler)

    # Rendez-vous
    user_id = config.USER_ID
    
    for photo in photo_iter(flickr, user_id):
        photo_id = photo.attrib["id"]
        photo_title = photo.attrib["title"]
        
        print "--------------------------------------------"
        logger.info("BEGIN >>> %s"%photo_id)
            
        photo_url = largest_photo_url(flickr, photo_id)
        msg = "FLICKR URL >>> %s"%photo_id
        if photo_url is None:
            logger.warning(msg)
            continue
        logger.info(msg)
            
        # Download image
        image_path = path + "/" + photo_id
        local_file = image_path + os.path.splitext( photo_url )[1]
        if not os.path.exists(local_file):
            msg = "DOWNLOAD >>> %s"%photo_id
            for attempt in xrange(1, config.DOWNLOAD_RETRIES+1):
                try:
                    urllib.urlretrieve(photo_url, local_file)
                    logger.info(msg)
                except:
                    logger.warning("DOWNLOAD ATTEMPT %s >>> %s"%(attempt, photo_id))
                    if os.path.exists(local_file):
                        try:
                            os.remove(local_file)
                        except:
                            pass
                    continue
            if attempt == config.DOWNLOAD_RETRIES:
                logger.error("DOWNLOAD >>> %s"%photo_id)
                continue
            
        # Create pyramid
        base_name = image_path + "/image"
        dzi_file = base_name + ".dzi"
        if not os.path.exists(dzi_file):
            msg = "PYRAMID >>> %s >>> %s"%(photo_id,local_file)
            for attempt in xrange(1, config.PYRAMID_RETRIES+1):
                try:
                    image_creator.create(local_file, dzi_file)
                    logger.info(msg)
                except:
                    logger.warning("PYRAMID ATTEMPT %s >>> %s >>> %s"%(attempt, photo_id, local_file))
                    if os.path.exists(image_path):
                        try:
                            shutil.rmtree(image_path)
                        except:
                            pass
                    continue
            if attempt == config.PYRAMID_RETRIES:
                logger.error("PYRAMID >>> %s >>> %s"%(photo_id, local_file))
                continue

        # TODO: Create OpenZoom descriptor
#        openzoom_file = base_name + ".xml"
        
        ftp.cwd("/")
        try:
            ftp.mkd(photo_id)
        except:
            logger.info("UPLOAD SKIP >>> %s"%photo_id)
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
                for attempt in xrange(1,config.FTP_RETRIES+1):
                    try:
                        upload(ftp, os.path.join(dirpath,file))
                        break
                    except:
                        f = os.path.join(dirpath,file)
                        logger.info("UPLOAD ATTEMPT %s >>> %s >>> %s"%(attempt, photo_id, f))
                        if attempt == config.FTP_RETRIES:
                            logger.error("UPLOAD ERROR >>> %s >>> %s"%(photo_id,f))
                        continue
                    
        os.chdir("..")
        logger.info("UPLOAD >>> %s"%photo_id)
        
        # Delete pyramid
#        shutil.rmtree(path + "/" + photo_id)
#        print "Image pyramid deleted. OK."

        # Set machine tags
        tag = SOURCE_TAG + URI_TEMPLATE%{"photo_id": photo_id}
        flickr.photos_addTags(photo_id=photo_id,tags=tag)
        
        tag = SOURE_BASE16_TAG + base64.b16encode(URI_TEMPLATE%{"photo_id": photo_id})
        flickr.photos_addTags(photo_id=photo_id,tags=tag)
        logger.info("MACHINE TAG >>> %s"%photo_id)
            
    # Clean up
    ftp.close()
    print logger.info("DONE")


if __name__ == "__main__":
    main()