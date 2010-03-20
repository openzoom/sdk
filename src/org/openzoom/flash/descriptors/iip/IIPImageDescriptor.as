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
package org.openzoom.flash.descriptors.iip
{

import flash.errors.IllegalOperationError;
import flash.geom.Point;

import org.openzoom.flash.core.openzoom_internal;
import org.openzoom.flash.descriptors.IImagePyramidDescriptor;
import org.openzoom.flash.descriptors.IImagePyramidLevel;
import org.openzoom.flash.descriptors.ImagePyramidDescriptorBase;
import org.openzoom.flash.descriptors.ImagePyramidLevel;
import org.openzoom.flash.utils.math.clamp;

use namespace openzoom_internal;

/**
 * Descriptor for the <a href="http://iipimage.sourceforge.net/documentation/protocol/">
 * Internet Imaging Protocol (IIP)</a>
 */
public class IIPImageDescriptor extends ImagePyramidDescriptorBase
                                implements IImagePyramidDescriptor
{
    include "../../core/Version.as"

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    private static const DEFAULT_TILE_FORMAT:String = "jpg"
    private static const DEFAULT_TYPE:String = "image/jpeg"
    private static const DEFAULT_TILE_OVERLAP:uint = 0

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function IIPImageDescriptor(source:String,
                                       width:uint,
                                       height:uint,
                                       tileWidth:uint=256,
                                       tileHeight:uint=256)
    {
        // path to server & image, e.g
        // http://merovingio.c2rmf.cnrs.fr/fcgi-bin/iipsrv.fcgi?FIF=/home/eros/iipimage/cop31/cop31_pyr_000_090.tif
        // http://merovingio.c2rmf.cnrs.fr/fcgi-bin/iipsrv.fcgi?FIF=/home/eros/iipimage/Tuberculous.tif
        this.source = source

        _width = width
        _height = height

        _tileWidth = tileWidth
        _tileHeight = tileHeight
        _tileOverlap = DEFAULT_TILE_OVERLAP

        _type = DEFAULT_TYPE

        _numLevels = getNumLevels(width, height, tileWidth, tileHeight)
        createLevels(width, height, tileWidth, tileHeight, numLevels)
    }

    /**
     * Create descriptor from basic info returned by IIP server.
     */
    public static function fromBasicInfo(source:String, basicInfo:String):IIPImageDescriptor
    {
        // Max-size:4080 3072
        // IIP-server:3.65
        // Max-size:4080 3072
        // Resolution-number:5
        // Colorspace,0-4,0:0 0 3 3 0 1 2

//      var sizeRegex:RegExp = /max-size: (d+) (d+)/
//      var width:uint =
//      var height:uint = ...
//      var tileWidth:uint = ...
//      var tileHeight:uint = ...

//        return new IIPImageDescriptor(source,
//                                      width,
//                                      height,
//                                      tileWidth,
//                                      tileHeight)
        // TODO
        throw new IllegalOperationError("Not implemented.")
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
        var l:IImagePyramidLevel = getLevelAt(level)
        var url:String = [source, "&jtl=", level, ",", (row * l.numColumns) + column].join("")

        return url
    }

    /**
     * @inheritDoc
     */
    public function getLevelForSize(width:Number, height:Number):IImagePyramidLevel
    {
        var log2:Number = Math.log(Math.max(width / tileWidth, height / tileHeight)) / Math.LN2
        var maxLevel:uint = numLevels - 1
        var index:int = clamp(Math.ceil(log2) + 1, 0, maxLevel)
        var level:IImagePyramidLevel = getLevelAt(index)

        // FIXME
        if (width / level.width < 0.5)
            level = getLevelAt(Math.max(0, index - 1))

        return level
    }

    /**
     * @inheritDoc
     */
    public function clone():IImagePyramidDescriptor
    {
        return new IIPImageDescriptor(source, width, height, tileWidth, tileHeight)
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
        return "[IIPImageDescriptor]" + "\n" + super.toString()
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Internal
    //
    //--------------------------------------------------------------------------
    /**
     * @private
     */
    private function getNumLevels(width:uint, height:uint, tileWidth:uint, tileHeight:uint):uint
    {
        // How many levels until image fits into a single tile
        return Math.ceil(Math.log(Math.ceil(Math.max(width / tileWidth, height / tileHeight)))/Math.LN2) + 1
    }


    /**
     * @private
     */
    private function createLevels(originalWidth:uint,
                                  originalHeight:uint,
                                  tileWidth:uint,
                                  tileHeight:uint,
                                  numLevels:int):void
    {
        for (var index:int = 0; index < numLevels; index++)
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
