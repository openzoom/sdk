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
package org.openzoom.flash.descriptors.bing
{

import org.openzoom.flash.core.openzoom_internal;
import org.openzoom.flash.descriptors.IImagePyramidDescriptor;
import org.openzoom.flash.descriptors.IImagePyramidLevel;
import org.openzoom.flash.descriptors.ImagePyramidDescriptorBase;
import org.openzoom.flash.descriptors.ImagePyramidLevel;
import org.openzoom.flash.utils.math.clamp;

use namespace openzoom_internal;

/**
 * <a href="http://www.microsoft.com/virtualearth/">Microsoft Bing Maps</a> descriptor.
 * For educational purposes only. Please respect the owner's copyright.
 *
 * @see http://msdn.microsoft.com/en-us/library/bb259689.aspx
 */
public final class BingMapsDescriptor extends ImagePyramidDescriptorBase
                                      implements IImagePyramidDescriptor
{
    include "../../core/Version.as"

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    public static const ROAD:String = "r"
    public static const AERIAL:String = "h"

    private static const DEFAULT_MAP_SIZE:uint = 67108864 //2147483648
    private static const DEFAULT_NUM_LEVELS:uint = 18 //23
    private static const DEFAULT_TILE_SIZE:uint = 256
    private static const DEFAULT_TILE_FORMAT:String = "image/jpeg"
    private static const DEFAULT_TILE_OVERLAP:uint = 0
    private static const DEFAULT_BASE_LEVEL:int = 9

    private static const NUM_TILE_SERVERS:int = 8
    private static const LATEST_VERSION:int = 373

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function BingMapsDescriptor(style:String=AERIAL)
    {
        this.style = style

        _width = _height = DEFAULT_MAP_SIZE
        _tileWidth = _tileHeight = DEFAULT_TILE_SIZE
        _type = DEFAULT_TILE_FORMAT
        _tileOverlap = DEFAULT_TILE_OVERLAP
        _numLevels = DEFAULT_NUM_LEVELS

        for (var i:int = 0; i < DEFAULT_NUM_LEVELS; i++)
        {
            var size:uint = uint(Math.pow(2, DEFAULT_BASE_LEVEL + i))
            var columns:uint = Math.ceil(size / tileWidth)
            var rows:uint = Math.ceil(size / tileHeight)
            var level:IImagePyramidLevel =
                    new ImagePyramidLevel(this, i, size, size, columns, rows)
            addLevel(level)
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private static var tileServer:uint = 0
    private var style:String

    //--------------------------------------------------------------------------
    //
    //  Methods: IImagePyramidDescriptor
    //
    //--------------------------------------------------------------------------

    /**
     * @inheritDoc
     */
    public function getLevelForSize(width:Number, height:Number):IImagePyramidLevel
    {
        var longestSide:Number = Math.max(width, height)
        var log2:Number = Math.log(longestSide) / Math.LN2
        var maxLevel:uint = numLevels - 1

        var index:uint
		index = clamp(Math.floor(log2) - DEFAULT_BASE_LEVEL, 0, maxLevel)		
        // FIXME Increase level for spatial blending
//		index = clamp(Math.ceil(log2) - DEFAULT_BASE_LEVEL, 0, maxLevel)		
        var level:IImagePyramidLevel = getLevelAt(index)

        return level
    }

    /**
     * @inheritDoc
     */
    public function getTileURL(level:int, column:int, row:int):String
    {
        var server:int = (++tileServer) % NUM_TILE_SERVERS
        var baseURL:String = "http://ecn.t" + server + ".tiles.virtualearth.net/tiles/" + style

        var extension:String
        if (style == AERIAL)
            extension = ".jpeg?g=" + LATEST_VERSION + "&mkt=en-us"
        else
            extension = ".png?g=" + LATEST_VERSION + "&mkt=en-us&shading=hill"

        var tileURL:String = [baseURL, getQuadKey(level, column, row), extension].join("")

        return tileURL
    }

    /**
     * @inheritDoc
     */
    public function clone():IImagePyramidDescriptor
    {
        return new BingMapsDescriptor()
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
        return "[BingMapsDescriptor]" + "\n" + super.toString()
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Helper
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    private function getQuadKey(level:int, column:int, row:int):String
    {
        var quadKey:String = "";

        for (var i:uint = level + 1; i > 0; i--)
        {
            var d:uint = 0;
            var mask:uint = 1 << (i - 1)

            if ((column & mask) != 0)
            {
                d++
            }
            if ((row & mask) != 0)
            {
                d++
                d++
            }

            quadKey += d.toString()
        }

        return quadKey
    }
}

}
