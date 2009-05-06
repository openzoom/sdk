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
package org.openzoom.flash.descriptors.zoomify
{

import flash.utils.Dictionary;

import org.openzoom.flash.descriptors.IMultiScaleImageDescriptor;
import org.openzoom.flash.descriptors.IMultiScaleImageLevel;
import org.openzoom.flash.descriptors.MultiScaleImageDescriptorBase;
import org.openzoom.flash.descriptors.MultiScaleImageLevel;
import org.openzoom.flash.utils.math.clamp;

/**
 * Descriptor for the <a href="http://www.zoomify.com/">Zoomify</a>
 * multiscale image format.
 */
public class ZoomifyDescriptor extends MultiScaleImageDescriptorBase
                               implements IMultiScaleImageDescriptor
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    private static const DEFAULT_DESCRIPTOR_FILE_NAME:String = "ImageProperties.xml"
    private static const DEFAULT_TILE_FOLDER_NAME:String = "TileGroup"
    private static const DEFAULT_TILE_FORMAT:String = "jpg"
    private static const DEFAULT_TILE_OVERLAP:uint = 0
    private static const DEFAULT_NUM_TILES_IN_FOLDER:uint = 256

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function ZoomifyDescriptor(source:String, data:XML)
    {
        this.data = data
        this.uri = source

        parseXML(data)
        _numLevels = computeNumLevels(width, height, tileWidth, tileHeight)
        levels = computeLevels(width, height, tileWidth, tileHeight, numLevels)
        tileCountUpToLevel = computeLevelTileCounts(numLevels)
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var data:XML
    private var levels:Dictionary
    private var tileCountUpToLevel:Array = []
    private var numTiles:uint

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
        var length:Number = uri.length - DEFAULT_DESCRIPTOR_FILE_NAME.length

        var tileGroup:uint = getTileGroup(level, column, row)
        var path:String = uri.substr(0, length) + DEFAULT_TILE_FOLDER_NAME + tileGroup
        var url:String =  [path, "/", level, "-", column, "-", row, ".", type].join("")

        return url
    }

    /**
     * @inheritDoc
     */
    public function getLevelForSize(width:Number, height:Number):IMultiScaleImageLevel
    {
        // TODO: Adapt Deep Zoom algorithm
        // for finding optimal tile level
        var index:int = numLevels - 1

        while (index >= 0 &&
               IMultiScaleImageLevel(levels[index]).width > width &&
               IMultiScaleImageLevel(levels[index]).height > height)
        {
            index--
        }

        var maxLevel:uint = numLevels - 1
        index = clamp(index, 0, maxLevel)

        return IMultiScaleImageLevel(levels[index]).clone()
    }

    /**
     * @inheritDoc
     */
    public function getLevelAt(index:int):IMultiScaleImageLevel
    {
        return levels[index]
    }

    /**
     * @inheritDoc
     */
    public function clone():IMultiScaleImageDescriptor
    {
        return new ZoomifyDescriptor(uri, data.copy())
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
        return "[ZoomifyDescriptor]" + "\n" + super.toString()
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Internal
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    private function parseXML(data:XML):void
    {
        // <IMAGE_PROPERTIES WIDTH="2203" HEIGHT="3290" NUMTILES="169"
        //        NUMIMAGES="1" VERSION="1.8" TILESIZE="256" />
        _width = data.@WIDTH
        _height = data.@HEIGHT
        _tileWidth = _tileHeight = data.@TILESIZE

        _type = DEFAULT_TILE_FORMAT
        _tileOverlap = DEFAULT_TILE_OVERLAP

        numTiles = data.@NUMTILES
    }

    /**
     * @private
     */
    private function computeNumLevels(width:uint, height:uint,
                                      tileWidth:uint, tileHeight:uint):uint
    {
        var numLevels:uint = 1

        while (width > tileWidth || height > tileHeight)
        {
            width = Math.ceil(width / 2)
            height = Math.ceil(height / 2)
            numLevels++
        }

        return numLevels
    }

    /**
     * @private
     */
    private function computeLevels(originalWidth:uint, originalHeight:uint,
                                   tileWidth:uint, tileHeight:uint,
                                   numLevels:int):Dictionary
    {
        var levels:Dictionary = new Dictionary()

        var width:uint = originalWidth
        var height:uint = originalHeight

        for (var index:int = numLevels - 1; index >= 0; index--)
        {
            levels[index] = new MultiScaleImageLevel(this, index, width, height,
                                                     Math.ceil(width / tileWidth),
                                                     Math.ceil(height / tileHeight))
            width = Math.floor(width / 2)
            height = Math.floor(height / 2)
        }

        return levels
    }

    private function computeLevelTileCounts(numLevels:int):Array
    {
        var levelTileCount:Array = []
        levelTileCount[0] = 0

        for (var i:int = 1; i < numLevels; i++)
        {
            var l:IMultiScaleImageLevel = IMultiScaleImageLevel(levels[i-1])
            levelTileCount.push(l.numColumns * l.numRows + levelTileCount[i-1])
        }

        return levelTileCount
    }

    /**
     * @private
     *
     * Calculates the folder this tile resides in.
     * There's probably a more efficient way to do this.
     * Correctness has a higher priority for now, so I didn't bother.
     */
    private function getTileGroup(level:int, column:uint, row:uint):uint
    {
        var numColumns:uint = getLevelAt(level).numColumns
        var tileIndex:uint = column + row * numColumns + tileCountUpToLevel[level]
        var tileGroup:uint = tileIndex / DEFAULT_NUM_TILES_IN_FOLDER

        return tileGroup
    }
}

}
