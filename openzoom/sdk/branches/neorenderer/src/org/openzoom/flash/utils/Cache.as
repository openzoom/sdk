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

/**
 * Basic implementation of a cache that evicts lowest item in order
 * in case its capacity has been reached.
 */
public final class Cache implements IDisposable
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
     * Returns the size of the cache.
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
     * Returns <code>true</code> if cache has item at key
     * and otherwise <code>false</code>
     */ 
    public function contains(key:*):Boolean
    {
        if (cache[key])
          return true

        return false
    }

    /**
     * Returns cache item at key.
     */ 
    public function get(key:*):ICacheItem
    {
        return cache[key]
    }

    /**
     * Put item into cache at key.
     */ 
    public function put(key:*, item:ICacheItem):void
    {
    	if (items.length < _size)
    	{
	    	items.push(item)
	        cache[key] = item
    	}
    	else
    	{
    		// Assume first item is the worst
    		var worstItemIndex:int = 0
    		var worstItem:ICacheItem = items[worstItemIndex]
    		
    		// Find worst item in items
			var candidate:ICacheItem
    		for (var i:int = 1; i < items.length; i++)
    		{
    			candidate = items[1]
    			if (candidate.compareTo(worstItem) < 0)
    			{
                    worstItemIndex = i
                    worstItem = candidate    				
    			}
    		}
    		
    		// Dispose worst item
    		worstItem.dispose()
    		
    		// Add new item at the spot of the previously worst item
    		items[worstItemIndex] = item
	        cache[key] = item
    	}
    }

    /**
     * Remove item from cache at key.
     */ 
    public function remove(key:*):Boolean
    {
    	if (contains(key))
        {
        	var item:ICacheItem = cache[key]
        	item.dispose()
            cache[key] = null
            
            return true
        }
        
        return false
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
