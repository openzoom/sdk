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
package org.openzoom.flash.descriptors.gigapan
{

import flash.geom.Point;

import org.openzoom.flash.core.openzoom_internal;
import org.openzoom.flash.descriptors.IImagePyramidDescriptor;
import org.openzoom.flash.descriptors.IImagePyramidLevel;
import org.openzoom.flash.descriptors.ImagePyramidDescriptorBase;
import org.openzoom.flash.descriptors.ImagePyramidLevel;
import org.openzoom.flash.utils.math.clamp;

use namespace openzoom_internal;

/**
 * Descriptor for the <a href="http://gigapan.org/">GigaPan.org</a> project panoramas.
 * For educational purposes only. Please respect the project's copyright.
 */
public final class GigaPanDescriptor extends ImagePyramidDescriptorBase
                                     implements IImagePyramidDescriptor
{
	include "../../core/Version.as"

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    private static const DEFAULT_TILE_SIZE:uint = 256
    private static const DEFAULT_BASE_LEVEL:uint = 8

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function GigaPanDescriptor(source:String, width:uint, height:uint)
    {
        this.source = source

        _width = width
        _height = height
        _numLevels = computeNumLevels(width, height)

        _tileWidth = DEFAULT_TILE_SIZE
        _tileHeight = DEFAULT_TILE_SIZE

        _type = "image/jpeg"

        createLevels(width, height, DEFAULT_TILE_SIZE, numLevels)
    }

    /**
     * Constructor.
     */
    public static function fromID(id:uint, width:uint, height:uint):GigaPanDescriptor
    {
        // FIXME: Legacy
//        var path:String = "http://share.gigapan.org/gigapans0/" + id + "/tiles"

        var tileServer:uint = Math.floor(id / 1000.0)
        var zeroPaddedTileServer:String = tileServer <= 9 ? "0" + tileServer : tileServer.toString()
        var path:String = "http://tile" + zeroPaddedTileServer + ".gigapan.org/gigapans0/" + id + "/tiles"

        var descriptor:GigaPanDescriptor = new GigaPanDescriptor(path, width, height)

        return descriptor
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var extension:String = ".jpg"

    //--------------------------------------------------------------------------
    //
    //  Methods: IImagePyramidDescriptor
    //
    //--------------------------------------------------------------------------

    /**
     * @inheritDoc
     */
    public function getTileURL(level:int, column:int, row:int):String
    {
		trace("[GigaPanDescriptor] getTileURL")
		
        var url:String = source
        var name:String = "r"
        var z:int = level
        var bit:int = (1 << z) >> 1
        var x:int = column
        var y:int = row

        while (bit > 0)
        {
            name += String((x & bit ? 1 : 0) + (y & bit ? 2 : 0))
            bit = bit >> 1
        }

        var i:int = 0
        while (i < name.length - 3)
        {
            url = url + "/" + name.substr(i, 3)
            i = i + 3
        }

        var tileURL:String = [url, "/", name, extension].join("")
		
		trace(tileURL)
		
        return tileURL
    }

    /**
     * @inheritDoc
     */
    public function getLevelForSize(width:Number, height:Number):IImagePyramidLevel
    {
        var longestSide:Number = Math.max(width, height)
        var log2:Number = Math.log(longestSide) / Math.LN2
        var maxLevel:uint = numLevels - 1
        var index:uint = clamp(Math.ceil(log2) - DEFAULT_BASE_LEVEL + 1, 0, maxLevel)
        var level:IImagePyramidLevel = getLevelAt(index)

        // FIXME
        if (width / level.width < 0.5)
            level = getLevelAt(Math.max(0, index - 1))

        if (width / level.width < 0.5)
            trace("[GigaPanDescriptor] getLevelForSize():", width / level.width)

        return level
    }

    /**
     * @inheritDoc
     */
    public function clone():IImagePyramidDescriptor
    {
        return new GigaPanDescriptor(source, width, height)
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Debug
    //
    //--------------------------------------------------------------------------

    /**
     * @inheritDoc
     */
    override public function toString():String
    {
        return "[GigaPanDescriptor]" + "\n" + super.toString()
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Internal
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    private function computeNumLevels(width:uint, height:uint):uint
    {
        var maxDimension:uint = Math.max(width, height)
        var actualLevels:uint = Math.ceil(Math.log(maxDimension) / Math.LN2)
        var numLevels:uint = Math.max(0, actualLevels - DEFAULT_BASE_LEVEL + 1)

        return numLevels
    }

    /**
     * @private
     */
    private function createLevels(originalWidth:uint,
                                  originalHeight:uint,
                                  tileSize:uint,
                                  numLevels:int):void
    {
        var maxLevel:int = numLevels - 1

        for (var index:int = 0; index <= maxLevel; index++)
        {
            var size:Point = getSize(index)
            var width:uint = size.x
            var height:uint = size.y
            var numColumns:int = Math.ceil(width / tileWidth)
            var numRows:int = Math.ceil(height / tileHeight)
            var level:IImagePyramidLevel = new ImagePyramidLevel(this,
                                                                 index,
                                                                 width,
                                                                 height,
                                                                 numColumns,
                                                                 numRows)
            addLevel(level)
        }
    }

    /**
     * @private
     */
    private function getScale(level:int):Number
    {
        var maxLevel:int = numLevels - 1
        // 1 / (1 << maxLevel - level)
        return Math.pow(0.5, maxLevel - level)
    }

    /**
     * @private
     */
    private function getSize(level:int):Point
    {
        var size:Point = new Point()
        var scale:Number = getScale(level)
        size.x = Math.floor(width * scale)
        size.y = Math.floor(height * scale)

        return size
    }
}

}
