////////////////////////////////////////////////////////////////////////////////
//
//  OpenZoom
//
//  Copyright (c) 2007-2009, Daniel Gasienica <daniel@gasienica.ch>
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
package org.openzoom.flash.renderers.images
{

import flash.display.BitmapData;
import flash.errors.IllegalOperationError;
import flash.geom.Rectangle;

import org.openzoom.flash.utils.IComparable;
import org.openzoom.flash.utils.IDisposable;

/**
 * Tile of an image pyramid.
 */
public class ImagePyramidTile implements IDisposable,
                                         IComparable
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     * Constructor.
     */
    public function ImagePyramidTile(level:int,
                                     column:int,
                                     row:int,
                                     url:String,
                                     bounds:Rectangle)
    {
    	this.level = level
    	this.column = column
    	this.row = row
    	this.url = url
    	this.bounds = bounds
    	
    	_hashCode = ImagePyramidTile.getHashCode(level, column, row)
    } 
    
    //--------------------------------------------------------------------------
    //
    //  Properties: Image pyramid
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  level
    //----------------------------------
    
    public var level:int

    //----------------------------------
    //  column
    //----------------------------------
    
    public var column:int

    //----------------------------------
    //  row
    //----------------------------------
    
    public var row:int

    //----------------------------------
    //  bounds
    //----------------------------------
    
    public var bounds:Rectangle

    //----------------------------------
    //  bitmapData
    //----------------------------------
    
    public function get bitmapData():BitmapData
    {
    	if (source)
    	   return source.bitmapData
    	   
        return null
    }

    //----------------------------------
    //  url
    //----------------------------------
    
    public var url:String
    
    //--------------------------------------------------------------------------
    //
    //  Properties: Loading
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  loading
    //----------------------------------
    
    public var loading:Boolean = false

    //----------------------------------
    //  loaded
    //----------------------------------
    
    public function get loaded():Boolean
    {
    	if (bitmapData)
    	   return true
    	   
        return false
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties: Rendering
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  fadeStart
    //----------------------------------
    
    public var fadeStart:int = 0

    //----------------------------------
    //  alpha
    //----------------------------------
    
    public var alpha:Number = 0
    
    //--------------------------------------------------------------------------
    //
    //  Properties: Caching
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  source
    //----------------------------------
    
    private var _source:SharedTile
    
    public function get source():SharedTile
    {
    	return _source
    }
    
    public function set source(value:SharedTile):void
    {
    	if (!value)
    	   throw new ArgumentError("[ImagePyramidTile] Source cannot be null.")
    	
    	_source = value
        _source.addOwner(this)
    }
    
    //----------------------------------
    //  lastAccessTime
    //----------------------------------
    
    public function get lastAccessTime():int
    {
        if (!source)
            throw new IllegalOperationError("[ImagePyramidTile] Source missing.")
    	
        return source.lastAccessTime
    }
    
    public function set lastAccessTime(value:int):void
    {
        if (!source)
            throw new IllegalOperationError("[ImagePyramidTile] Source missing.")
            
    	source.lastAccessTime = value 
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties: Hash
    //
    //--------------------------------------------------------------------------
    
    private var _hashCode:int
    
    public function get hashCode():int
    {
    	return _hashCode
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods: Hash
    //
    //--------------------------------------------------------------------------
    
    public static function getHashCode(level:int, column:int, row:int):int
    {
    	return parseInt([level, column, row].join(""))
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods: IDisposable
    //
    //--------------------------------------------------------------------------
    
    public function dispose():void
    {
        _source = null
        
    	loading = false
    	
    	alpha = 0
    	fadeStart = 0
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods: IComparable
    //
    //--------------------------------------------------------------------------
    
    public function compareTo(other:*):int
    {
    	var tile:ImagePyramidTile = other as ImagePyramidTile
    	
    	if (!tile)
    	   throw new ArgumentError("[ImagePyramidTile] Object to compare has wrong type.")

        if (level < tile.level)
            return 1
            
        if (level > tile.level)
            return -1
        
        return 0
    }
}

}
