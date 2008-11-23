////////////////////////////////////////////////////////////////////////////////
//
//  OpenZoom
//  Copyright (c) 2008, Daniel Gasienica <daniel@gasienica.ch>
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
package org.openzoom.descriptors.zoomify
{

import flash.utils.Dictionary;

import org.openzoom.descriptors.IMultiScaleImageDescriptor;
import org.openzoom.descriptors.IMultiScaleImageLevel;
import org.openzoom.descriptors.MultiScaleImageDescriptorBase;
import org.openzoom.descriptors.MultiScaleImageLevel;
import org.openzoom.utils.math.clamp;

/**
 * Descriptor for the Zoomify <http://zoomify.com/> multi-scale image format.
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
    private static const DEFAULT_TILE_FOLDER_NAME : String = "TileGroup0"
    private static const DEFAULT_TILE_FORMAT : String = "jpg"
    private static const DEFAULT_TILE_OVERLAP : uint = 0
    
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
    
    //--------------------------------------------------------------------------
    //
    //  Methods: IMultiScaleImageDescriptor
    //
    //--------------------------------------------------------------------------
    
    public function getTileURL( level : int, column : uint, row : uint ) : String
    {
    	var path : String = source.substr( 0, source.length - DEFAULT_DESCRIPTOR_FILE_NAME.length ) + DEFAULT_TILE_FOLDER_NAME
        return [ path, "/", level, "-", column, "-", row, ".", type ].join("")

    }

    public function getMinimumLevelForSize( width : Number, height : Number ) : IMultiScaleImageLevel
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

    public function getLevelAt( index : int ) : IMultiScaleImageLevel
    {
        return levels[ index ]
    }
    
    public function clone() : IMultiScaleImageDescriptor
    {
        return new ZoomifyDescriptor( source, new XML( data ) )
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods: Debug
    //
    //--------------------------------------------------------------------------
    
    override public function toString() : String
    {
        return "[ZoomifyDescriptor]" + "\n" + super.toString()
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods: Internal
    //
    //--------------------------------------------------------------------------
    
    private function parseXML( data : XML ) : void
    {
        // <IMAGE_PROPERTIES WIDTH="2203" HEIGHT="3290" NUMTILES="169" NUMIMAGES="1" VERSION="1.8" TILESIZE="256" />
        _width = data.@WIDTH
        _height = data.@HEIGHT
        _tileWidth = _tileHeight = data.@TILESIZE
        
        _type = DEFAULT_TILE_FORMAT
        _tileOverlap = DEFAULT_TILE_OVERLAP
    }
    
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
}

}