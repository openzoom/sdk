################################################################################
#
#   OpenZoom Flickr Rendezvous
#
#   Copyright (c) 2007-2009, Daniel Gasienica <daniel@gasienica.ch>
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
import openzoom
import os
import os.path
import urllib
from ftplib import FTP
import shutil
import time
import zipfile



# FLICKR ITERATORS

def photo_iter(flickr, user_id):
    response = flickr.people_getInfo(user_id=user_id)
    photo_count = int(response.find("person").find("photos").find("count").text)
    page_size = 500
    num_pages = int(math.ceil(float(photo_count) / page_size))
    for page in range(1, num_pages + 1):
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
        if w * h > max_size:
            max_size = w * h
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
    (token, frob) = flickr.get_token_part_one(perms="write")
    if not token:
        raw_input("Press ENTER after you authorized this program")
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


LOG_FILENAME = "rendezvous.log"
PRODUCTION = True

OPENZOOM_SOURCE_TAG = u"openzoom:source="
OPENZOOM_SOURE_BASE16_TAG = u"openzoom:base16source=" 
SEADRAGON_SOURE_TAG = u"seadragon:source=" 
SEADRAGON_SOURE_BASE16_TAG = u"seadragon:base16source=" 


def main():
    # Temporary folder for creating image pyramids
    tmp_dir = config.TMP_DIR
    
    # Source folder for downloaded Flickr images (Never touch)
    source_dir = config.SOURCE_DIR
    
    # Delete log and temporary folder when debugging
    if not PRODUCTION:
        reset_dir(tmp_dir)
        reset_dir(config.LOG_DIR)
    
    # Prepare Deep Zoom Tools with default parameters
    image_creator = deepzoom.ImageCreator()

    # Connect
    ftp = connect_ftp(config.FTP_HOST, config.FTP_USER, config.FTP_PASSWORD)
    flickr = connect_flickr(config.API_KEY, config.API_SECRET)

    # Logging
    logger = logging.getLogger("rendezvous")
    logger.setLevel(logging.DEBUG)

    handler = logging.handlers.RotatingFileHandler(config.LOG_DIR + "/" + config.LOG_FILE,
                                                   maxBytes=1024*1024, backupCount=100)
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
        
        # Skip photo if we found openzoom tags
        logger.info("CHECK MACHINE TAGS >>> %s"%photo_id)
        openzoom_source_found = False
        openzoom_source_base16_found = False
        seadragon_source_found = False
        seadragon_source_base16_found = False

        for tag in machine_tag_iter(flickr, photo_id):
            raw_tag = tag.attrib["raw"]
            prelude = raw_tag.partition("=")[0]
            namespace, _, predicate = prelude.partition(":")
            if namespace == "openzoom":
                if predicate == "source":
                    openzoom_source_found = True
                if predicate == "base16source":
                    openzoom_source_base16_found = True
            if namespace == "seadragon":
                if predicate == "source":
                    seadragon_source_found = True
                if predicate == "base16source":
                    seadragon_source_base16_found = True
        if (openzoom_source_found and openzoom_source_base16_found and
            seadragon_source_found and seadragon_source_base16_found):
#            time.sleep(1)
            logger.info("SKIP >>> %s"%photo_id)
            continue
            
            
        photo_url = largest_photo_url(flickr, photo_id)
        msg = "FLICKR URL >>> %s"%photo_id
        if photo_url is None:
            logger.warning(msg)
            continue
        logger.info(msg)
            
        # Download image
        image_path = source_dir + "/" + photo_id
        local_file = image_path + os.path.splitext(photo_url)[1]
        if not os.path.exists(local_file):
            msg = "DOWNLOAD >>> %s"%photo_id
            attempt = 1
            for attempt in xrange(1, config.DOWNLOAD_RETRIES + 1):
                try:
                    urllib.urlretrieve(photo_url, local_file)
#                    raise Exception
                    logger.info(msg)
                    break
                except:
                    logger.warning("DOWNLOAD ATTEMPT %s >>> %s"%(attempt, photo_id))
#                    if os.path.exists(local_file):
#                        try:
#                            os.remove(local_file)
#                        except:
#                            pass
                    continue
            if attempt == config.DOWNLOAD_RETRIES:
                logger.error("DOWNLOAD >>> %s"%photo_id)
                continue
            
        # Create pyramid
        pyramid_path = tmp_dir + "/" + photo_id
        descriptor_base_name = pyramid_path + "/image"
        dzi_file = descriptor_base_name + ".dzi"
        if not os.path.exists(dzi_file):
            msg = "PYRAMID >>> %s >>> %s"%(photo_id,local_file)
            attempt = 1
            for attempt in xrange(1, config.PYRAMID_RETRIES + 1):
                try:
                    image_creator.create(local_file, dzi_file)
#                    raise Exception
                    logger.info(msg)
                    break
                except:
                    logger.warning("PYRAMID ATTEMPT %s >>> %s >>> %s"%(attempt, photo_id, local_file))
                    if os.path.exists(pyramid_path):
                        try:
                            shutil.rmtree(pyramid_path)
                        except:
                            pass
                    continue
            if attempt == config.PYRAMID_RETRIES:
                logger.error(msg)
                continue

        # Create OpenZoom descriptor
        ozi_file = descriptor_base_name + ".xml"
        if not os.path.exists(ozi_file):
            msg = "DESCRIPTOR >>> %s"%(photo_id)
            attempt = 1
            for attempt in xrange(1, config.DESCRIPTOR_RETRIES + 1):
                try:
                    descriptor = openzoom.OpenZoomDescriptor()
                    descriptor.open(dzi_file, "dzi")
                    for uri in config.EXTRA_URI:
                        uri_template = uri + "/%(photo_id)s"%{"photo_id": photo_id}
                        descriptor.add_uri(uri_template)
                    descriptor.save(ozi_file)
                    logger.info(msg)
                    break
                except:
                    logger.warning("DESCRIPTOR ATTEMPT %s >>> %s"%(attempt, photo_id))
                    continue
            if attempt == config.DESCRIPTOR_RETRIES:
                logger.error(msg)
                continue

        # Upload to FTP
        root_path = config.FTP_PATH
        try:
            ftp.cwd(root_path)
        except:
            ftp = connect_ftp(config.FTP_HOST, config.FTP_USER, config.FTP_PASSWORD)
            ftp.cwd(root_path)
            
        try:
            ftp.mkd(photo_id)
        except:
            pass
#            logger.info("UPLOAD SKIP >>> %s"%photo_id)
#            continue
        
        old_path = os.path.abspath(os.curdir)
        os.chdir(tmp_dir)
        for dirpath, dirs, files in os.walk(photo_id):
            ftp.cwd(root_path + "/" + dirpath)
            for dir in dirs:
                try:
                    ftp.mkd(dir)
                except:
                    pass
            for file in files:
                attempt = 1
                for attempt in xrange(1, config.FTP_RETRIES + 1):
                    try:
                        upload(ftp, os.path.join(dirpath, file))
#                        raise Exception
                        break
                    except:
                        f = os.path.join(dirpath, file)
                        logger.warning("UPLOAD ATTEMPT %s >>> %s >>> %s"%(attempt, photo_id, f))
                        continue
                if attempt == config.FTP_RETRIES:
                    logger.error("UPLOAD >>> %s >>> %s"%(photo_id,f))
                    
        os.chdir(old_path)
        logger.info("UPLOAD >>> %s"%photo_id)
        
        # Delete pyramid
        msg = "PYRAMID CLEANUP >>> %s"%photo_id
        try:
            shutil.rmtree(pyramid_path)
            logger.info(msg)
        except:
            logger.error(msg)

        # Set machine tags
        descriptor_base_name_uri = config.MAIN_URI + "/" + photo_id + "/image"
        openzoom_uri = descriptor_base_name_uri + ".xml"
        dzi_uri = descriptor_base_name_uri + ".dzi"
        
        attempt = 1
        for attempt in xrange(1, config.MACHINE_TAG_RETRIES + 1):
            try:
                tag = OPENZOOM_SOURCE_TAG + openzoom_uri
                flickr.photos_addTags(photo_id=photo_id, tags=tag)
                
                tag = OPENZOOM_SOURE_BASE16_TAG + base64.b16encode(openzoom_uri)
                flickr.photos_addTags(photo_id=photo_id, tags=tag)
        
                tag = SEADRAGON_SOURE_TAG + dzi_uri
                flickr.photos_addTags(photo_id=photo_id, tags=tag)
                
                tag = SEADRAGON_SOURE_BASE16_TAG + base64.b16encode(dzi_uri)
                flickr.photos_addTags(photo_id=photo_id, tags=tag)
    
                logger.info("MACHINE TAG >>> %s"%photo_id)
                break
            except:
                logger.warning("MACHINE TAG ATTEMPT %s >>> %s"%(attempt, photo_id))
                time.sleep(attempt * 12) # Wait for 12, 24, 36, 48 and 60 seconds...
                continue
            
        if attempt == config.MACHINE_TAG_RETRIES:
            logger.error("MACHINE TAG >>> %s"%photo_id)
            
    # Clean up
    ftp.close()
    print logger.info("DONE")


if __name__ == "__main__":
    main()