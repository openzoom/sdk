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

import org.openzoom.flash.utils.ICacheItem;

/**
 * Cache entry for bitmaps that could or could not be shared by several tiles.
 */ 	
internal final class SharedTile implements ICacheItem
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function SharedTile(url:String,
                               bitmapData:BitmapData,
                               level:int,
                               shared:Boolean=false)
    {
        this.url = url
        this.bitmapData = bitmapData
        this.level = level
        this.shared = shared
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    public var url:String
    public var bitmapData:BitmapData
    public var level:int
    public var shared:Boolean = false

    public var lastAccessTime:int = 0
    
    //--------------------------------------------------------------------------
    //
    //  Properties: Ownership
    //
    //--------------------------------------------------------------------------
    
    public var owners:Array = []

    //--------------------------------------------------------------------------
    //
    //  Methods: ICacheItem
    //
    //--------------------------------------------------------------------------

    /**
     * @inheritDoc
     */
    public function dispose():void
    {
        for each (var tile:ImagePyramidTile in owners)
            tile.dispose()
            
        url = null
        bitmapData = null
        level = 0
        shared = false
        lastAccessTime = 0
        
    }

    /**
     * @inheritDoc
     */
    public function compareTo(other:*):int
    {
        var entry:SharedTile = other as SharedTile

        if (!entry)
           throw new ArgumentError("[SharedTile] Object to compare has wrong type.")

        // Shared tiles have higher order
        if (shared && !entry.shared)
            return 1

        if (level == 0 && entry.level > 0)
            return 1

        // Otherwise newer tiles have higher order
        if (lastAccessTime < entry.lastAccessTime)
            return -1
        else if (entry.lastAccessTime == lastAccessTime)
            return 0
        else
            return 1
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods: ICacheItem
    //
    //--------------------------------------------------------------------------
    
    public function toString():String
    {
    	return "[SharedTile]" + "\n" +
    	       "url: " + url  + "\n" +
    	       "level: " + level  + "\n" +
    	       "lastAccessTime: " + lastAccessTime
    }
    
}

}
