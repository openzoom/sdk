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
package org.openzoom.flash.descriptors.deepzoom
{

import flash.geom.Rectangle;

/**
 * Descriptor for the
 * <a href="http://msdn.microsoft.com/en-us/library/cc645077(VS.95).aspx">
 * Microsoft Deep Zoom Collection (DZC) format</a>.
 */
public class DeepZoomCollectionDescriptor
{
    //--------------------------------------------------------------------------
    //
    //  Namespaces
    //
    //--------------------------------------------------------------------------

    namespace deepzoom = "http://schemas.microsoft.com/deepzoom/2008"

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function DeepZoomCollectionDescriptor(path:String, xml:XML)
    {
    	use namespace deepzoom
    	
    	// TODO
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    private var source:String
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  maxLevel
    //----------------------------------
    
    private var _maxLevel:int = 0
    
    /**
     * Maximum level of the collection image pyramid
     */
    public function get maxLevel():int
    {
    	return _maxLevel
    }

    //----------------------------------
    //  type
    //----------------------------------
    
    private var _type:String
    
    /**
     * MIME type of the collection
     */ 
    public function get type():String
    {
        return type
    }

    //----------------------------------
    //  tileSize
    //----------------------------------
    
    private var _tileSize:uint
    
    /**
     * Tile size of the collection image pyramid.
     */ 
    public function get tileSize():uint
    {
        return _tileSize
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * Returns the URL of the tile of a collection item specified
     * by its Morton number and level.
     */
    public function getTileURL(mortonNumber:uint, level:int):String
    {
    	return ""
    }
    
    /**
     * Returns the bounds (position and dimensions) of the tile of
     * a collection item specified by its Morton number and level.
     */
    public function getTileBounds(mortonNumber:uint, level:int):Rectangle
    {
    	return new Rectangle()
    }
}

}