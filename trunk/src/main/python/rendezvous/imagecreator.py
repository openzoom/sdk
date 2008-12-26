################################################################################ 
# 
#   Deep Zoom Image Creator
# 
#   Copyright (c) 2008, Daniel Gasienica <daniel@gasienica.ch>
#   Copyright (c) 2008, Kapil Thangavelu <kapil.foss@gmail.com>
#   All rights reserved.
# 
#   Redistribution and use in source and binary forms, with or without
#   modification, are permitted provided that the following conditions are met:
# 
#   Redistributions of source code must retain the above copyright notice, this
#   list of conditions and the following disclaimer. Redistributions in binary
#   form must reproduce the above copyright notice, this list of conditions and
#   the following disclaimer in the documentation and/or other materials
#   provided with the distribution. The names of the contributors may not be
#   used to endorse or promote products derived from this software without
#   specific prior written permission. 
# 
#   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
#   AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
#   IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
#   ARE DISCLAIMED. IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR
#   ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
#   DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
#   SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
#   CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
#   LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
#   OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
#   DAMAGE.
# 
################################################################################


import math
import os
import optparse
import sys

from PIL import Image


dzi_template = """\
<?xml version="1.0" encoding="UTF-8"?>
<Image TileSize="%(tile_size)s" Overlap="%(overlap)s" Format="%(format)s" xmlns="http://schemas.microsoft.com/deepzoom/2008">
    <Size Width="%(width)s" Height="%(height)s"/>
</Image>"""


filter_map = {
    "cubic"     : Image.CUBIC,
    "bilinear"  : Image.BILINEAR,
    "bicubic"   : Image.BICUBIC,
    "nearest"   : Image.NEAREST,
    "antialias" : Image.ANTIALIAS,
    }


class ImageCreator( object ):
    
    def __init__(self, image, tile_size=256.0, overlap=1, format="jpg", filter=None):
        self.image = image
        self.tile_size = tile_size
        self.overlap = overlap
        self.format = format
        self.width, self.height = self.image.size
        self._levels = None
        self.filter = filter

    @property
    def levels( self ):
        """Number of levels in the image pyramid"""
        if self._levels is not None:
            return self._levels
        self._levels = int( math.ceil( math.log( max(( self.width, self.height )), 2 )))
        return self._levels

    def get_level_dimensions( self, level ):
        assert 0 <= level and level <= self.levels, "Invalid pyramid level"
        scale = self.get_level_scale( level )
        return math.ceil( self.width * scale ), math.ceil( self.height * scale )

    def get_level_scale( self, level ):
        #print math.pow( 0.5, self.levels - level )
        return 1.0 / ( 1 << ( self.levels - level ))

    def get_level_rows_columns( self, level ):
        w, h = self.get_level_dimensions( level )
        return ( math.ceil( w / self.tile_size ),  math.ceil( h / self.tile_size ))
    
    def get_tile_bounds( self, level, column, row ):
        """Bounding box of the tile (x1, y1, x2, y2)"""
        # find start position for current tile
        
        # python's ternary operator doesn't like zero as true condition result
        # i.e. True and 0 or 1 -> returns 1        
        if not column:
            px = 0
        else:
            px = self.tile_size * column - self.overlap
        if not row:
            py = 0
        else:
            py = self.tile_size * row - self.overlap

        # scaled dimensions for this level
        dsw, dsh = self.get_level_dimensions( level )
        
        # find the dimension of the tile, adjust for no overlap data on top and left edges
        sx = self.tile_size + ( column == 0 and 1 or 2 ) * self.overlap
        sy = self.tile_size + ( row    == 0 and 1 or 2 ) * self.overlap
        
        # adjust size for single-tile levels where the image size is smaller
        # than the regular tile size, and for tiles on the bottom and right
        # edges that would exceed the image bounds        
        sx = min( sx, dsw - px )
        sy = min( sy, dsh - py )
        
        return px, py, px+sx, py+sy

    def get_level_image( self, level ):

        w, h = self.get_level_dimensions( level )
        w, h = int( w ), int( h )

        # don't transform to what we already have
        if self.width == w and self.height == h: 
            return self.image
        
        if not self.filter:
            return self.image.resize(( w, h )) 
        return self.image.resize(( w, h ), self.filter )
    
    
    def iter_tiles( self, level ):
        col, row = self.get_level_rows_columns( level )
        for w in range( 0, int( col ) ):
            for h in range( 0, int( row ) ):
                yield ( w, h ),( self.get_tile_bounds( level, w, h ))

    def __len__( self ):
        return self.levels
    
    def create( self, parent_directory, name ):
        dir_path = ensure( os.path.join( ensure( expand( parent_directory )), "%s_files"%name ))

        # store images
        for n in range( self.levels + 1 ):
            level_dir = ensure( os.path.join( dir_path, str( n ) ) )
            level_image = self.get_level_image( n )
            for ( col, row ), box in self.iter_tiles( n ):
                tile = level_image.crop( map( int, box ))
                tile_path = os.path.join( level_dir, "%s_%s.%s"%( col, row, self.format ))
                tile_file = open( tile_path, "wb+" )
                tile.save( tile_file )

        # store dzi file
        fh = open( os.path.join( parent_directory, "%s.dzi"%(name)), "w+" )
        fh.write( dzi_template%( self.__dict__ ) )
        fh.close()
        
def expand( d ):
    return os.path.abspath( os.path.expanduser( os.path.expandvars( d )))

def ensure( d ):
    if not os.path.exists( d ):
        os.mkdir( d )
    return d

def main():
    parser = optparse.OptionParser(usage="Usage: %prog [options] filename")
    
    parser.add_option("-n", "--name", dest="name",
                      help="Set the name of the output directory")
    parser.add_option("-p", "--path", dest="path",
                      help="Set the path to the output directory")
    
    parser.add_option("-s", "--tile_size", dest="size", type="int",
                      default=256, help="Size of the tiles")
    parser.add_option("-f", "--tile_format", dest="format",
                      default="jpg", help="Image format of the tiles (jpg or png)")
    parser.add_option("-r", "--resize_filter", dest="filter", default="antialias",
                      help="Type of filter for resizing (bicubic, nearest, antialias, bilinear")

    ( options, args ) = parser.parse_args()

    if not args:
        parser.print_help()
        sys.exit(1)
    image_path = expand( args[0] )
    
    if not os.path.exists( image_path ):
        print "Invalid File", image_path
        sys.exit(1)
        
    if not options.name:
        options.name = os.path.splitext( os.path.basename( image_path ))[ 0 ]
    if not options.path:
        options.path = os.path.dirname( image_path )
    if options.filter and options.filter in filter_map:
        options.filter = filter_map[ options.filter ]

    img = Image.open( image_path )
    creator = ImageCreator( img, tile_size=options.size, format=options.format, filter=options.filter )

    creator.create( options.path, options.name )
    
if __name__ == "__main__":
    main()