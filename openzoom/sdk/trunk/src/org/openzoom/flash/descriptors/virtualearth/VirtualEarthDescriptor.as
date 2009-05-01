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
package org.openzoom.flash.descriptors.virtualearth
{

import org.openzoom.flash.descriptors.IMultiScaleImageDescriptor;
import org.openzoom.flash.descriptors.IMultiScaleImageLevel;
import org.openzoom.flash.descriptors.MultiScaleImageDescriptorBase;
import org.openzoom.flash.descriptors.MultiScaleImageLevel;
import org.openzoom.flash.utils.math.clamp;

/**
 * <a href="http://www.microsoft.com/virtualearth/">Microsoft VirtualEarth</a> descriptor.
 * @see http://msdn.microsoft.com/en-us/library/bb259689.aspx
 */
public class VirtualEarthDescriptor extends MultiScaleImageDescriptorBase
                                    implements IMultiScaleImageDescriptor
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    private static const DEFAULT_MAP_SIZE:uint = 2147483648
    private static const DEFAULT_NUM_LEVELS:uint = 23
    private static const DEFAULT_TILE_SIZE:uint = 256
    private static const DEFAULT_TILE_FORMAT:String = "image/jpeg"
    private static const DEFAULT_TILE_OVERLAP:uint = 0
    private static const DEFAULT_BASE_LEVEL:uint = 9

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function VirtualEarthDescriptor()
    {
        _width = _height = DEFAULT_MAP_SIZE
        _tileWidth = _tileHeight = DEFAULT_TILE_SIZE
        _type = DEFAULT_TILE_FORMAT
        _tileOverlap = DEFAULT_TILE_OVERLAP
        _numLevels = DEFAULT_NUM_LEVELS

        for (var i:int = 0; i < DEFAULT_NUM_LEVELS; i++)
        {
            var size:uint = uint(Math.pow(2, DEFAULT_BASE_LEVEL + i))
            levels.push(new MultiScaleImageLevel(this, i,
                                                 size, size,
                                                 size / tileWidth,
                                                 size / tileHeight))
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var levels:Array = []

    //--------------------------------------------------------------------------
    //
    //  Methods: IMultiScaleImageDescriptor
    //
    //--------------------------------------------------------------------------

    /**
     * @inheritDoc
     */
    public function getLevelAt(index:int):IMultiScaleImageLevel
    {
        var i:int = clamp(index, 0, numLevels - 1)
        return levels[i]
    }

    /**
     * @inheritDoc
     */
    public function getMinLevelForSize(width:Number, height:Number):IMultiScaleImageLevel
    {
        var longestSide:Number = Math.max(width, height)
        var log2:Number = Math.log(longestSide) / Math.LN2
        var maxLevel:uint = numLevels - 1
        var index:uint = clamp(Math.floor(log2) - DEFAULT_BASE_LEVEL, 0, maxLevel)
        return levels[index]
    }

    /**
     * @inheritDoc
     */
    public function getTileURL(level:int, column:uint, row:uint):String
    {
        var baseURL:String = "http://ecn.t2.tiles.virtualearth.net/tiles/h"
        var extension:String = ".jpeg?g=282&mkt=en-us"
        var tileURL:String = [baseURL, getQuadKey(level, column, row), extension].join("")

        return tileURL
    }

    /**
     * @inheritDoc
     */
    public function clone():IMultiScaleImageDescriptor
    {
        return new VirtualEarthDescriptor()
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Helper
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    private function getQuadKey(level:int, column:uint, row:uint):String
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