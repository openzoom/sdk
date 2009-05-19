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
import flash.geom.Rectangle;

/**
 * Tile of an image pyramid.
 */
public class Tile2
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     * Constructor.
     */
    public function Tile2(level:int,
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
    
    public var bitmapData:BitmapData

    //----------------------------------
    //  url
    //----------------------------------
    
    public var url:String
    
    //--------------------------------------------------------------------------
    //
    //  Properties: Loading
    //
    //--------------------------------------------------------------------------
    
    public var loading:Boolean = false
    public var loaded:Boolean = false
    
    //--------------------------------------------------------------------------
    //
    //  Properties: Rendering
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  alpha
    //----------------------------------
    
    public var alpha:Number = 0
    
    //--------------------------------------------------------------------------
    //
    //  Properties: Hash
    //
    //--------------------------------------------------------------------------
    
    public function get hashCode():int
    {
    	return Tile2.getHashCode(level, column, row)
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
}

}