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
package org.openzoom.flash.utils
{

import flash.utils.Dictionary;
import flash.utils.getTimer;

/**
 * Basic implementation of a cache that evicts lowest item in order
 * in case its capacity has been reached.
 */
public final class Cache implements ICache
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    /**
     * Constructor.
     */
    public function Cache(size:int, weakKeys:Boolean=false)
    {
        _size = size
        cache = new Dictionary(weakKeys)
        items = []
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var cache:Dictionary
    private var items:Array

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    private var _size:int

    /**
     * @inheritDoc
     */
    public function get size():int
    {
        return _size
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     * @inheritDoc
     */
    public function contains(key:*):Boolean
    {
        if (cache[key])
          return true

        return false
    }

    /**
     * @inheritDoc
     */
    public function get(key:*):ICacheItem
    {
        var item:ICacheItem = cache[key]

        if (!item)
           throw new ArgumentError("[Cache] Item does not exist.")

        return item
    }

    /**
     * @inheritDoc
     */
    public function put(key:*, item:ICacheItem):void
    {
        if (!item)
           throw new ArgumentError("[Cache] Item cannot be null.")

        if (items.length < _size)
        {
            items.push(item)
            cache[key] = item
        }
        else
        {
            // Assume first item is the minimal
            var evictedItemIndex:int = 0
            var evictedItem:ICacheItem = items[evictedItemIndex]

            // Find minimum of all items
            var candidate:ICacheItem
            for (var i:int = 1; i < items.length; ++i)
            {
                candidate = items[i]

                if (candidate.compareTo(evictedItem) < 0)
                {
                    evictedItemIndex = i
                    evictedItem = candidate
                }
            }

            // Dispose minimum item
            evictedItem.dispose()

            // Add new item at the spot of the previously minimal item
            items[evictedItemIndex] = item
            cache[key] = item
        }
    }

    /**
     * @inheritDoc
     */
    public function remove(key:*):ICacheItem
    {
        var item:ICacheItem = get(key)
        items.splice(items.indexOf(item), 1)
        cache[key] = null

        return item
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: IDisposable
    //
    //--------------------------------------------------------------------------

    /**
     * @inheritDoc
     */
    public function dispose():void
    {
        items = []
        cache = null
    }
}

}
