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

import org.openzoom.flash.descriptors.IMultiScaleImageDescriptor;
import org.openzoom.flash.descriptors.IMultiScaleImageLevel;
import org.openzoom.flash.descriptors.MultiScaleImageDescriptorBase;
import org.openzoom.flash.descriptors.MultiScaleImageLevel;
import org.openzoom.flash.utils.math.clamp;

/**
 * @private
 *
 * Descriptor for the GigaPan.org project panoramas.
 * Copyright GigaPan.org, <a href="http://gigapan.org/">http://gigapan.org/</a>
 */
public class GigaPanDescriptor extends MultiScaleImageDescriptorBase
                               implements IMultiScaleImageDescriptor
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

        levels = computeLevels(width, height, DEFAULT_TILE_SIZE, numLevels)
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var id:uint
    private var extension:String = ".jpg"
    private var levels:Dictionary

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

        var tileURL:String = url + "/" + name + extension
        return tileURL
    }

    /**
     * @inheritDoc
     */
    public function getLevelAt(index:int):IMultiScaleImageLevel
    {
        return IMultiScaleImageLevel(levels[index])
    }

    /**
     * @inheritDoc
     */
    public function getMinLevelForSize(width:Number, height:Number):IMultiScaleImageLevel
    {
    	var maxDimension:uint = Math.max(width, height)
    	var level:uint = Math.ceil(Math.log(maxDimension) / Math.LN2)
    	var actualLevel:uint = level - DEFAULT_BASE_LEVEL
        var index:int = clamp(actualLevel, 0, numLevels - 1)
        return IMultiScaleImageLevel(getLevelAt(index)).clone()
    }

    /**
     * @inheritDoc
     */
    public function clone():IMultiScaleImageDescriptor
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
    private function computeLevels(originalWidth:uint, originalHeight:uint,
                                   tileSize:uint, numLevels:int):Dictionary
    {
        var levels:Dictionary = new Dictionary()

        var width:uint = originalWidth
        var height:uint = originalHeight

        for (var index:int = numLevels - 1; index >= 0; index--)
        {
            levels[index] = new MultiScaleImageLevel(this, index, width, height,
                                                     Math.ceil(width / tileWidth),
                                                     Math.ceil(height / tileHeight))
            width = Math.ceil(width / 2)
            height = Math.ceil(height / 2)
        }

        return levels
    }
}

}