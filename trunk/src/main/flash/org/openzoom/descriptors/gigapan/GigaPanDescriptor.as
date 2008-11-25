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
package org.openzoom.descriptors.gigapan
{

import flash.utils.Dictionary;

import org.openzoom.descriptors.IMultiScaleImageDescriptor;
import org.openzoom.descriptors.IMultiScaleImageLevel;
import org.openzoom.descriptors.MultiScaleImageDescriptorBase;
import org.openzoom.descriptors.MultiScaleImageLevel;
import org.openzoom.utils.math.clamp;

/**
 * Descriptor for the GigaPan.org project panoramas.
 * Copyright GigaPan, <http://gigapan.org/>
 */
public class GigaPanDescriptor extends MultiScaleImageDescriptorBase
                               implements IMultiScaleImageDescriptor
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------
    
    private static const DEFAULT_BASE_LEVEL : uint = 8
    private static const DEFAULT_TILE_SIZE : uint = 256
    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function GigaPanDescriptor( url : String,
                                       extension : String,
                                       width : uint,
                                       height : uint,
                                       numLevels : uint )
    {
        this.source = url
        this.extension = extension

        _numLevels = numLevels
        _width = width
        _height = height
        
        _tileWidth = DEFAULT_TILE_SIZE
        _tileHeight = DEFAULT_TILE_SIZE
        
        if( extension == ".png" )
            _type = "image/png"
        else
            _type = "image/jpeg"

        levels = computeLevels( width, height, DEFAULT_TILE_SIZE, numLevels )
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var extension : String
    private var levels : Dictionary 

    //--------------------------------------------------------------------------
    //
    //  Methods: IMultiScaleImageDescriptor
    //
    //--------------------------------------------------------------------------
    
    public function getTileURL( level : int, column : uint, row : uint ) : String
    {
    	var url : String = source
    	var name : String = "r"
    	var z : int = level
    	var bit : int = (1 << z) >> 1
    	var x : int = column
    	var y : int = row
    	
    	while( bit > 0 )
    	{
    		name += String(( x & bit ? 1 : 0 ) + ( y & bit ? 2 : 0 ))
    		bit = bit >> 1
    	}
    	
    	var i : int = 0
    	while( i < name.length - 3 )
    	{
    		url = url + ("/" + name.substr( i, 3 ))
    		i = i + 3
    	} 
    	
    	var tileURL : String = url + "/" + name + extension
        return tileURL
    }
    
    public function getLevelAt( index : int ) : IMultiScaleImageLevel
    {
        return IMultiScaleImageLevel( levels[ index ] )
    }
    
    
    public function getMinimumLevelForSize( width : Number,
                                            height : Number ) : IMultiScaleImageLevel
    {
        var index : int =
                clamp( Math.ceil( Math.log( Math.max( width, height )) / Math.LN2
                               - DEFAULT_BASE_LEVEL ), 0, numLevels - 1 )
        return IMultiScaleImageLevel( getLevelAt( index ) ).clone()
    }
    
    public function clone() : IMultiScaleImageDescriptor
    {
        return new GigaPanDescriptor( source, extension, width, height, numLevels )
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Debug
    //
    //--------------------------------------------------------------------------
    
    override public function toString() : String
    {
        return "[GigaPanDescriptor]" + "\n" + super.toString()
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods: Internal
    //
    //--------------------------------------------------------------------------
    
    private function computeLevels( originalWidth : uint, originalHeight : uint,
                                    tileSize : uint, numLevels : int ) : Dictionary
    {
        var levels : Dictionary = new Dictionary()

        var width : uint = originalWidth
        var height : uint = originalHeight

        for( var index : int = numLevels - 1; index >= 0; index-- )
        {
            levels[ index ] = new MultiScaleImageLevel( this, index, width, height,
                                                        Math.ceil( width / tileWidth ),
                                                        Math.ceil( height / tileHeight ) )
            width = ( width + 1 ) >> 1
            height = ( height + 1 ) >> 1
        }
        
        return levels
    }
}

}