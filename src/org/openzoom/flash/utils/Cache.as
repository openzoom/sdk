////////////////////////////////////////////////////////////////////////////////
//
//  OpenZoom SDK
//
//  Version: MPL 1.1/GPL 3/LGPL 3
//
//  The contents of this file are subject to the Mozilla Public License Version
//  1.1 (the "License"); you may not use this file except in compliance with
//  the License. You may obtain a copy of the License at
//  http://www.mozilla.org/MPL/
//
//  Software distributed under the License is distributed on an "AS IS" basis,
//  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
//  for the specific language governing rights and limitations under the
//  License.
//
//  The Original Code is the OpenZoom SDK.
//
//  The Initial Developer of the Original Code is Daniel Gasienica.
//  Portions created by the Initial Developer are Copyright (c) 2007-2010
//  the Initial Developer. All Rights Reserved.
//
//  Contributor(s):
//    Daniel Gasienica <daniel@gasienica.ch>
//
//  Alternatively, the contents of this file may be used under the terms of
//  either the GNU General Public License Version 3 or later (the "GPL"), or
//  the GNU Lesser General Public License Version 3 or later (the "LGPL"),
//  in which case the provisions of the GPL or the LGPL are applicable instead
//  of those above. If you wish to allow use of your version of this file only
//  under the terms of either the GPL or the LGPL, and not to allow others to
//  use your version of this file under the terms of the MPL, indicate your
//  decision by deleting the provisions above and replace them with the notice
//  and other provisions required by the GPL or the LGPL. If you do not delete
//  the provisions above, a recipient may use your version of this file under
//  the terms of any one of the MPL, the GPL or the LGPL.
//
////////////////////////////////////////////////////////////////////////////////
package org.openzoom.flash.utils
{

import flash.utils.Dictionary;

import org.openzoom.flash.core.openzoom_internal;

use namespace openzoom_internal;

/**
 * Basic implementation of a cache that evicts lowest item in order
 * in case its capacity has been reached.
 */
public final class Cache implements ICache
{
	include "../core/Version.as"

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    /**
     * Constructor.
     */
    public function Cache(size:int)
    {
        _size = size
        cache = new Dictionary()
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
