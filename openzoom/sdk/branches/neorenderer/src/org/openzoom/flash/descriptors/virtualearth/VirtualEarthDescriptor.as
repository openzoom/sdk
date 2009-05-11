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

import flash.geom.Point;
import flash.geom.Rectangle;

import org.openzoom.flash.descriptors.IImagePyramidDescriptor;
import org.openzoom.flash.descriptors.IImagePyramidLevel;
import org.openzoom.flash.descriptors.ImagePyramidDescriptorBase;
import org.openzoom.flash.descriptors.ImagePyramidLevel;
import org.openzoom.flash.utils.math.clamp;

/**
 * <a href="http://www.microsoft.com/virtualearth/">Microsoft VirtualEarth</a> descriptor.
 * @see http://msdn.microsoft.com/en-us/library/bb259689.aspx
 */
public class VirtualEarthDescriptor extends ImagePyramidDescriptorBase
                                    implements IImagePyramidDescriptor
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    private static const DEFAULT_MAP_SIZE:uint = 67108864 //2147483648
    private static const DEFAULT_NUM_LEVELS:uint = 18 //23
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
            var columns:uint = Math.ceil(size / tileWidth)
            var rows:uint = Math.ceil(size / tileHeight)
            var level:IImagePyramidLevel =
                    new ImagePyramidLevel(this, i, size, size, columns, rows)
            levels.push(level)
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
    public function getLevelAt(index:int):IImagePyramidLevel
    {
        var i:int = clamp(index, 0, numLevels - 1)
        return levels[i]
    }

    /**
     * @inheritDoc
     */
    public function getLevelForSize(width:Number, height:Number):IImagePyramidLevel
    {
        var longestSide:Number = Math.max(width, height)
        var log2:Number = Math.log(longestSide) / Math.LN2
        var maxLevel:uint = numLevels - 1
        var index:uint = clamp(Math.floor(log2) - DEFAULT_BASE_LEVEL, 0, maxLevel)
        return getLevelAt(index)
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
    override public function getTileAtPoint(level:int, point:Point):Point
    {
        var p:Point = new Point()
        
        var l:IImagePyramidLevel = getLevelAt(level)
        p.x = Math.floor((point.x * l.width) / tileWidth)
        p.y = Math.floor((point.y * l.height) / tileHeight)
        
        return p
    }

    /**
     * @inheritDoc
     */
    override public function getTileBounds(level:int, column:uint, row:uint):Rectangle
    {
        var bounds:Rectangle = new Rectangle()
        var offsetX:uint = (column == 0) ? 0 : tileOverlap
        var offsetY:uint = (row == 0) ? 0 : tileOverlap
        bounds.x = (column * tileWidth) - offsetX
        bounds.y = (row * tileHeight) - offsetY
        
        var l:IImagePyramidLevel = getLevelAt(level)
        var width:uint = tileWidth + (column == 0 ? 1 : 2) * tileOverlap
        var height:uint = tileHeight + (row == 0 ? 1 : 2) * tileOverlap
        bounds.width = Math.min(width, l.width - bounds.x)
        bounds.height = Math.min(height, l.height - bounds.y)
                
        return bounds
    }

    /**
     * @inheritDoc
     */
    public function clone():IImagePyramidDescriptor
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