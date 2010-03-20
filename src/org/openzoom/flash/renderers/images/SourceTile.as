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
package org.openzoom.flash.renderers.images
{

import flash.display.BitmapData;

import org.openzoom.flash.core.openzoom_internal;
import org.openzoom.flash.utils.ICacheItem;

use namespace openzoom_internal;

[ExcludeClass]
/**
 * @private
 *
 * Cache entry for bitmaps that could or could not be shared by several tiles.
 */
internal final class SourceTile implements ICacheItem
{
	include "../../core/Version.as"

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function SourceTile(url:String,
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
//          throw new ArgumentError("[SharedTile] Owner already added.")
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
        var otherTile:SourceTile = other as SourceTile

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
