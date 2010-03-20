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
package org.openzoom.flash.descriptors.zoomify
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
 * Descriptor for the <a href="http://www.zoomify.com/">Zoomify</a>
 * multiscale image format.
 */
public class ZoomifyDescriptor extends ImagePyramidDescriptorBase
                               implements IImagePyramidDescriptor
{
    include "../../core/Version.as"

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    private static const DEFAULT_DESCRIPTOR_FILE_NAME:String = "ImageProperties.xml"
    private static const DEFAULT_TILE_FOLDER_NAME:String = "TileGroup"
    private static const DEFAULT_TILE_FORMAT:String = "jpg"
    private static const DEFAULT_TYPE:String = "image/jpeg"
    private static const DEFAULT_TILE_OVERLAP:uint = 0
    private static const DEFAULT_NUM_TILES_IN_FOLDER:uint = 256

    private static const DEFAULT_NUM_IMAGES:int = 1
    private static const DEFAULT_VERSION:String = "1.8"

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function ZoomifyDescriptor(source:String,
                                      width:uint,
                                      height:uint,
                                      tileSize:uint=256)
    {
        this.source = source

        _width = width
        _height = height

        _tileWidth = _tileHeight = tileSize
        _tileOverlap = DEFAULT_TILE_OVERLAP

        _type = DEFAULT_TYPE
        format = DEFAULT_TILE_FORMAT

        _numLevels = getNumLevels(width, height, tileSize)
        createLevels(width, height, tileSize, numLevels)
        tileCountUpToLevel = computeLevelTileCounts(numLevels)
    }

    /**
     * Create descriptor from XML.
     */
    public static function fromXML(source:String, xml:XML):ZoomifyDescriptor
    {
        // <IMAGE_PROPERTIES WIDTH="2203" HEIGHT="3290" NUMTILES="169"
        //        NUMIMAGES="1" VERSION="1.8" TILESIZE="256" />

        var width:uint = xml.@WIDTH
        var height:uint = xml.@HEIGHT
        var tileSize:uint = xml.@TILESIZE

        return new ZoomifyDescriptor(source,
                                     width,
                                     height,
                                     tileSize)
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var tileCountUpToLevel:Array = []
    private var format:String

    //--------------------------------------------------------------------------
    //
    //  Properties: Zoomify file format
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  tileSize
    //----------------------------------

    /**
     * Returns the size of a single tile of the image pyramid in pixels.
     */
    public function get tileSize():uint
    {
        return _tileWidth
    }

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
        var length:Number = source.length - DEFAULT_DESCRIPTOR_FILE_NAME.length

        var tileGroup:uint = getTileGroup(level, column, row)
        var path:String = source.substr(0, length) + DEFAULT_TILE_FOLDER_NAME + tileGroup
        var url:String = [path, "/", level, "-", column, "-", row, ".", format].join("")

        return url
    }

    /**
     * @inheritDoc
     */
    public function getLevelForSize(width:Number, height:Number):IImagePyramidLevel
    {
        var longestSide:Number = Math.max(width, height)
        var log2:Number = (Math.log(longestSide) - Math.log(tileSize)) / Math.LN2
        var maxLevel:uint = numLevels - 1
        var index:int = clamp(Math.ceil(log2) + 1, 0, maxLevel)
        var level:IImagePyramidLevel = getLevelAt(index)

        // FIXME
        if (width / level.width < 0.5)
            level = getLevelAt(Math.max(0, index - 1))

        if (width / level.width < 0.5)
            trace("[ZoomifyDescriptor] getLevelForSize():", width / level.width)

        return level
    }

    /**
     * @inheritDoc
     */
    public function clone():IImagePyramidDescriptor
    {
        return new ZoomifyDescriptor(source, width, height, tileSize)
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
    private function getNumLevels(width:uint, height:uint, tileSize:uint):uint
    {
        // How many levels until image fits into a single tile
        return Math.ceil(Math.log(Math.ceil(Math.max(width, height) / tileSize))/Math.LN2) + 1
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
            var numColumns:int = Math.ceil(width / tileSize)
            var numRows:int = Math.ceil(height / tileSize)
            var level:IImagePyramidLevel = new ImagePyramidLevel(this,
                                                                 index,
                                                                 width,
                                                                 height,
                                                                 numColumns,
                                                                 numRows)
            addLevel(level)
        }
    }

    private function computeLevelTileCounts(numLevels:int):Array
    {
        var levelTileCount:Array = []
        levelTileCount[0] = 0

        for (var i:int = 1; i < numLevels; i++)
        {
            var l:IImagePyramidLevel = getLevelAt(i-1)
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
    private function getTileGroup(level:int, column:int, row:int):int
    {
        var numColumns:uint = getLevelAt(level).numColumns
        var tileIndex:uint = column + row * numColumns + tileCountUpToLevel[level]
        var tileGroup:uint = tileIndex / DEFAULT_NUM_TILES_IN_FOLDER

        return tileGroup
    }

    /**
     * @private
     */
    private function getScale(level:int):Number
    {
        var maxLevel:int = numLevels - 1
        return Math.pow(0.5, maxLevel - level)
    }

    /**
     * @private
     */
    private function getSize(level:int):Point
    {
        var size:Point = new Point()
        var scale:Number = getScale(level)
        // Verified that Zoomify levels (tiers) logic uses
        // divide by two (2) followed by floor both with
        // official Zoomify Express converter as well as
        // the open source ZoomifyImage project which
        // uses Python integer division.
        size.x = Math.floor(width * scale)
        size.y = Math.floor(height * scale)

        return size
    }
}

}
