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

public final class Cache implements IDisposable
{
	/**
	 * Constructor.
	 */
    public function Cache(size:int, weakKeys:Boolean=false)
    {
        _size = size
        cache = new Dictionary(weakKeys)
        items = []
    }

    private var cache:Dictionary
    private var items:Array

    private var _size:int

    public function get size():int
    {
        return size
    }

    public function contains(key:*):Boolean
    {
        if (cache[key])
          return true

        return false
    }

    public function get(key:*):ICacheItem
    {
        return cache[key]
    }

    public function put(key:*, item:ICacheItem):void
    {
        cache[key] = item
    }

    public function remove(key:*):void
    {
        cache[key] = null
    }

    public function dispose():void
    {
    	items = []
        cache = null
    }
}

}