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
package org.openzoom.flash.descriptors.openstreetmap
{

import flash.geom.Point;
import flash.geom.Rectangle;

import org.openzoom.flash.descriptors.IImagePyramidDescriptor;
import org.openzoom.flash.descriptors.IImagePyramidLevel;
import org.openzoom.flash.descriptors.ImagePyramidDescriptorBase;
import org.openzoom.flash.descriptors.ImagePyramidLevel;
import org.openzoom.flash.utils.math.clamp;

/**
 * <a href="http://openstreetmap.org">OpenStreetMap</a> descriptor.
 */
public final class OpenStreetMapDescriptor extends ImagePyramidDescriptorBase
                                           implements IImagePyramidDescriptor
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    private static const DEFAULT_MAP_SIZE:uint = 67108864
    private static const DEFAULT_NUM_LEVELS:uint = 20
    private static const DEFAULT_TILE_SIZE:uint = 256
    private static const DEFAULT_TILE_FORMAT:String = "image/png"
    private static const DEFAULT_TILE_OVERLAP:uint = 0
    private static const DEFAULT_BASE_LEVEL:uint = 8

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function OpenStreetMapDescriptor()
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
            addLevel(level)
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: IMultiScaleImageDescriptor
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
        var index:uint = clamp(Math.floor(log2) - DEFAULT_BASE_LEVEL, 0, maxLevel)
        return getLevelAt(index)
    }

    /**
     * @inheritDoc
     */
    public function getTileURL(level:int, column:uint, row:uint):String
    {
        var baseURL:String = "http://tile.openstreetmap.org/"
        var tileURL:String = [baseURL, level, "/", column, "/", row, ".png"].join("")

        return tileURL
    }

    /**
     * @inheritDoc
     */
    public function clone():IImagePyramidDescriptor
    {
        return new OpenStreetMapDescriptor()
    }
}

}