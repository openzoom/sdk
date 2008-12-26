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

import flickr
import credentials

def main():
    flickr.API_KEY = credentials.API_KEY
    flickr.API_SECRET = credentials.API_SECRET
    photos = flickr.people_getPublicPhotos(user_id="33636394@N08", per_page="10")
    
    for photo in photos:
        print photo.getURL(urlType="source")

if __name__ == "__main__":
    main()