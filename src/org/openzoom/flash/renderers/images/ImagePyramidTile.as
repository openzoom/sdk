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
import flash.errors.IllegalOperationError;
import flash.geom.Rectangle;

import org.openzoom.flash.core.openzoom_internal;
import org.openzoom.flash.utils.IComparable;
import org.openzoom.flash.utils.IDisposable;
import org.openzoom.flash.utils.string.format;

use namespace openzoom_internal;

[ExcludeClass]
/**
 * Tile of an image pyramid.
 */
internal class ImagePyramidTile implements IDisposable,
                                           IComparable
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
    public function ImagePyramidTile(level:int,
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

    public function get bitmapData():BitmapData
    {
        if (source)
           return source.bitmapData

        return null
    }

    //----------------------------------
    //  url
    //----------------------------------

    public var url:String

    //--------------------------------------------------------------------------
    //
    //  Properties: Loading
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  loading
    //----------------------------------

    public var loading:Boolean = false

    //----------------------------------
    //  loaded
    //----------------------------------

    public function get loaded():Boolean
    {
        if (bitmapData)
           return true

        return false
    }

    //--------------------------------------------------------------------------
    //
    //  Properties: Rendering
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  blendStartTime
    //----------------------------------

    public var blendStartTime:int = 0

    //----------------------------------
    //  alpha
    //----------------------------------

    public var alpha:Number = 0

    //----------------------------------
    //  distance
    //----------------------------------

    public var distance:Number = Number.MAX_VALUE

    //--------------------------------------------------------------------------
    //
    //  Properties: Caching
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  source
    //----------------------------------

    private var _source:SourceTile

    public function get source():SourceTile
    {
        return _source
    }

    public function set source(value:SourceTile):void
    {
        if (!value)
           throw new ArgumentError("[ImagePyramidTile] Source cannot be null.")

        _source = value
        _source.addOwner(this)
    }

    //----------------------------------
    //  lastAccessTime
    //----------------------------------

    public function get lastAccessTime():int
    {
        if (!source)
            throw new IllegalOperationError("[ImagePyramidTile] Source missing.")

        return source.lastAccessTime
    }

    public function set lastAccessTime(value:int):void
    {
        if (!source)
            throw new IllegalOperationError("[ImagePyramidTile] Source missing.")

        source.lastAccessTime = value
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: IDisposable
    //
    //--------------------------------------------------------------------------

    public function dispose():void
    {
        _source = null

        loading = false

        alpha = 0
		blendStartTime = 0
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: IComparable
    //
    //--------------------------------------------------------------------------

    public function compareTo(other:*):int
    {
        var tile:ImagePyramidTile = other as ImagePyramidTile

        if (!tile)
           throw new ArgumentError("[ImagePyramidTile] Object to compare has wrong type.")

        if (level < tile.level)
            return 1

        if (level > tile.level)
            return -1

        if (distance < tile.distance)
            return 1

        if (distance > tile.distance)
            return -1

        // Tiles in the upper part of the image seem
        // more important than those in the lower part
        if (row < tile.row)
            return 1

        if (row > tile.row)
            return -1

        return 0
    }
	
	//--------------------------------------------------------------------------
	//
	//  Methods: Debug
	//
	//--------------------------------------------------------------------------
	
	public function toString():String
	{
		return format("[ImagePyramidTile]: ({0}, {1}, {2}) alpha: {3}",
			level, column, row, alpha)
	}
}

}
