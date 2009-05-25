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

    // True for collection tiles, e.g. Deep Zoom collections
    public var shared:Boolean = false

    public var lastAccessTime:int = 0

    //--------------------------------------------------------------------------
    //
    //  Properties: Ownership
    //
    //--------------------------------------------------------------------------

    private var owners:Array = []

    public function addOwner(owner:ImagePyramidTile):void
    {
        if (owners.indexOf(owner) > 0)
        {
        	return
        	// FIXME
//            throw new ArgumentError("[SharedTile] Owner already added.")
        }

        owners.push(owner)
    }

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
        var otherTile:SharedTile = other as SharedTile

        if (!otherTile)
           throw new ArgumentError("[SharedTile] Object to compare has wrong type.")


        // Shared tiles have higher order
        if (shared && !otherTile.shared)
            return 1

        if (!shared && otherTile.shared)
            return -1


        // Level 0 tiles always win
        if (level > 0 && otherTile.level == 0)
            return -1

        if (level == 0 && otherTile.level > 0)
            return 1


        // Fresher tiles have higher order
        if (lastAccessTime > otherTile.lastAccessTime)
            return 1

        if (lastAccessTime < otherTile.lastAccessTime)
            return -1

        return 0
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
