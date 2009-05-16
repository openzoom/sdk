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
package org.openzoom.flash.descriptors.gigapan
{

import flash.utils.Dictionary;

import org.openzoom.flash.descriptors.IImagePyramidDescriptor;
import org.openzoom.flash.descriptors.IImagePyramidLevel;
import org.openzoom.flash.descriptors.ImagePyramidDescriptorBase;
import org.openzoom.flash.descriptors.ImagePyramidLevel;
import org.openzoom.flash.utils.math.clamp;

/**
 * Descriptor for the GigaPan.org project panoramas.
 * Copyright GigaPan.org, <a href="http://gigapan.org/">http://gigapan.org/</a>
 */
public class GigaPanDescriptor extends ImagePyramidDescriptorBase
                               implements IImagePyramidDescriptor
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    private static const DEFAULT_BASE_LEVEL:uint = 8
    private static const DEFAULT_TILE_SIZE:uint = 256

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function GigaPanDescriptor(id:uint, width:uint, height:uint)
    {
        this.id = id

        _width = width
        _height = height
        _numLevels = computeNumLevels(width, height)

        _tileWidth = DEFAULT_TILE_SIZE
        _tileHeight = DEFAULT_TILE_SIZE

        _type = "image/jpeg"

        createLevels(width, height, DEFAULT_TILE_SIZE, numLevels)
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var id:uint
    private var extension:String = ".jpg"

    //--------------------------------------------------------------------------
    //
    //  Methods: IMultiScaleImageDescriptor
    //
    //--------------------------------------------------------------------------

    /**
     * @inheritDoc
     */
    public function getTileURL(level:int, column:uint, row:uint):String
    {
        var url:String = "http://share.gigapan.org/gigapans0/" + id + "/tiles"
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
        return tileURL
    }

    /**
     * @inheritDoc
     */
    public function getLevelAt(index:int):IImagePyramidLevel
    {
        return IMultiScaleImageLevel(levels[index])
    }

    /**
     * @inheritDoc
     */
    public function getLevelForSize(width:Number, height:Number):IImagePyramidLevel
    {
        var maxDimension:uint = Math.max(width, height)
        var level:uint = Math.floor(Math.log(maxDimension) / Math.LN2)
        var actualLevel:uint = level - DEFAULT_BASE_LEVEL
        var index:int = clamp(actualLevel, 0, numLevels - 1)
        
        return getLevelAt(index)
    }

    /**
     * @inheritDoc
     */
    public function clone():IImagePyramidDescriptor
    {
        return new GigaPanDescriptor(id, width, height)
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
        size.x = Math.ceil(width * scale)
        size.y = Math.ceil(height * scale)
        
        return size
    }
}

}
