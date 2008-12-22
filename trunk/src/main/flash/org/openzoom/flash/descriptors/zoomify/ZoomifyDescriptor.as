////////////////////////////////////////////////////////////////////////////////
//
//  OpenZoom
//
//  Copyright (c) 2007–2008, Daniel Gasienica <daniel@gasienica.ch>
//
//  OpenZoom is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  OpenZoom is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with OpenZoom. If not, see <http://www.gnu.org/licenses/>.
//
////////////////////////////////////////////////////////////////////////////////
package org.openzoom.flash.descriptors.zoomify
{

import flash.utils.Dictionary;

import org.openzoom.flash.descriptors.IMultiScaleImageDescriptor;
import org.openzoom.flash.descriptors.IMultiScaleImageLevel;
import org.openzoom.flash.descriptors.MultiScaleImageDescriptorBase;
import org.openzoom.flash.descriptors.MultiScaleImageLevel;
import org.openzoom.flash.utils.math.clamp;

/**
 * Descriptor for the Zoomify multi-scale image format.
 * <a href="http://www.zoomify.com/">http://www.zoomify.com/</a>
 */
public class ZoomifyDescriptor extends MultiScaleImageDescriptorBase
                               implements IMultiScaleImageDescriptor
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------
    
    private static const DEFAULT_DESCRIPTOR_FILE_NAME : String = "ImageProperties.xml"
    private static const DEFAULT_TILE_FOLDER_NAME : String = "TileGroup"
    private static const DEFAULT_TILE_FORMAT : String = "jpg"
    private static const DEFAULT_TILE_OVERLAP : uint = 0
    private static const DEFAULT_NUM_TILES_IN_FOLDER : uint = 256
    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     * Constructor.
     */
    public function ZoomifyDescriptor( source : String, data : XML )
    {
        this.data = data
        
        this.source = source
        parseXML( data )
        _numLevels = computeNumLevels( width, height, tileWidth, tileHeight )
        levels = computeLevels( width, height, tileWidth, tileHeight, numLevels )
    }
    
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    private var data : XML
    private var levels : Dictionary
    private var numTiles : uint
    
    //--------------------------------------------------------------------------
    //
    //  Methods: IMultiScaleImageDescriptor
    //
    //--------------------------------------------------------------------------
    
    /**
     * @inheritDoc
     */
    public function getTileURL( level : int, column : uint, row : uint ) : String
    {
    	var length : Number = source.length - DEFAULT_DESCRIPTOR_FILE_NAME.length
    	
    	var folder : uint = getFolder( level, column, row )
    	var path : String = source.substr( 0, length ) + DEFAULT_TILE_FOLDER_NAME + folder
    	var url : String =  [ path, "/", level, "-", column, "-", row, ".", type ].join("")
    	 
        return url 
    }

    /**
     * @inheritDoc
     */ 
    public function getMinLevelForSize( width : Number, height : Number ) : IMultiScaleImageLevel
    {
        // TODO: Implement a smart(er) algorithm
        var index : int = numLevels - 1

        while( index >= 0
               && IMultiScaleImageLevel( levels[ index ] ).width >= width
               && IMultiScaleImageLevel( levels[ index ] ).height >= height )
        {
            index--
        }

        // FIXME
        index = clamp( index + 1, 0, numLevels - 1 )

        return IMultiScaleImageLevel( levels[ index ] ).clone()
    }
    
    /**
     * @inheritDoc
     */ 
    public function getLevelAt( index : int ) : IMultiScaleImageLevel
    {
        return levels[ index ]
    }
    
    /**
     * @inheritDoc
     */ 
    public function clone() : IMultiScaleImageDescriptor
    {
        return new ZoomifyDescriptor( source, new XML( data ) )
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods: Debug
    //
    //--------------------------------------------------------------------------
    
    /**
     * @inheritDoc
     */ 
    override public function toString() : String
    {
        return "[ZoomifyDescriptor]" + "\n" + super.toString()
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods: Internal
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private
     */
    private function parseXML( data : XML ) : void
    {
        // <IMAGE_PROPERTIES WIDTH="2203" HEIGHT="3290" NUMTILES="169"
        //        NUMIMAGES="1" VERSION="1.8" TILESIZE="256" />
        _width = data.@WIDTH
        _height = data.@HEIGHT
        _tileWidth = _tileHeight = data.@TILESIZE
        
        _type = DEFAULT_TILE_FORMAT
        _tileOverlap = DEFAULT_TILE_OVERLAP
        
        numTiles = data.@NUMTILES
    }
    
    /**
     * @private
     */
    private function computeNumLevels( width : uint, height : uint, tileWidth : uint, tileHeight : uint ) : uint
    {
        var numLevels : uint = 1
    
        while( width > tileWidth || height > tileHeight )
        {
            width  = Math.floor( width  * 0.5 )
            height = Math.floor( height * 0.5 )
            numLevels++
        }

        return numLevels
    }
    
    /**
     * @private
     */
    private function computeLevels( originalWidth : uint, originalHeight : uint,
                                    tileWidth : uint, tileHeight : uint,
                                    numLevels : int ) : Dictionary
    {
        var levels : Dictionary = new Dictionary()

        var width : uint = originalWidth
        var height : uint = originalHeight

        for( var index : int = numLevels - 1; index >= 0; index-- )
        {
            levels[ index ] = new MultiScaleImageLevel( this, index, width, height,
                                                        Math.ceil( width / tileWidth ),
                                                        Math.ceil( height / tileHeight ))
            width >>= 1
            height >>= 1
//            width = Math.floor( width * 0.5 )
//            height = Math.floor( height * 0.5 )
        }

        return levels 
    }
    
    /**
     * @private
     * 
     * Calculates the folder this tile resides in.
     * There's probably a more efficient way to do this.
     * Correctness has a higher priority for now, so I didn't bother.
     */
    private function getFolder( level : int, column : uint, row : uint ) : uint
    {
    	// Return early if we know there's only one TileGroup folder
    	if( numTiles <= DEFAULT_NUM_TILES_IN_FOLDER )
            return 0
    	
    	// Compute the rank of the requested tile
    	// and determine in which TileGroup folder it resides.
    	var tileNumber : int = 0
    	
        for( var l : int = 0; l < numLevels; l++ )
        {
            var currentLevel : IMultiScaleImageLevel = getLevelAt( l )
                
            for( var r : int = 0; r < currentLevel.numRows; r++ )
            {
                for( var c : int = 0; c < currentLevel.numColumns; c++ )
                {
                    tileNumber++
                    
                    if( l == level && column == c && row == r )
                        return Math.floor( tileNumber / DEFAULT_NUM_TILES_IN_FOLDER )
                }
            }
        }
        
        return 0
    } 
}

}