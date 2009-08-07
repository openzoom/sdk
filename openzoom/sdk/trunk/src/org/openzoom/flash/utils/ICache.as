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

/**
 * Interface for cache implementations.
 */
public interface ICache extends IDisposable
{
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    /**
     * Returns the size of the cache.
     */
    function get size():int
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * Returns <code>true</code> if cache has item at key
     * and otherwise <code>false</code>
     */
    function contains(key:*):Boolean

    /**
     * Returns cache item at key.
     */
    function get(key:*):ICacheItem

    /**
     * Put item into cache at key.
     */
    function put(key:*, item:ICacheItem):void

    /**
     * Remove item from cache at key.
     */
    function remove(key:*):ICacheItem
}

}
