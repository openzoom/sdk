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
package org.openzoom.flash.descriptors
{

import flash.geom.Point;
import flash.geom.Rectangle;

import org.openzoom.flash.core.openzoom_internal;
import org.openzoom.flash.utils.math.clamp;

use namespace openzoom_internal;

/**
 * @private
 *
 * Base class for classes implementing IImagePyramidDescriptor.
 * Provides the basic getter/setter skeletons.
 */
public class ImagePyramidDescriptorBase
{
	include "../core/Version.as"

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  source
    //----------------------------------

    /**
     * @private
     */
    protected var source:String

    //----------------------------------
    //  sources
    //----------------------------------

    /**
     * @copy IImagePyramidDescriptor#sources
     */
    public function get sources():Array
    {
        return []
    }

    //----------------------------------
    //  width
    //----------------------------------

    /**
     * @private
     */
    protected var _width:uint

    /**
     * @copy IImagePyramidDescriptor#width
     */
    public function get width():uint
    {
        return _width
    }

    //----------------------------------
    //  height
    //----------------------------------

    /**
     * @private
     */
    protected var _height:uint

    /**
     * @copy IImagePyramidDescriptor#height
     */
    public function get height():uint
    {
        return _height
    }

    //----------------------------------
    //  numLevels
    //----------------------------------

    /**
     * @private
     */
    protected var _numLevels:int

    /**
     * @copy IImagePyramidDescriptor#numLevels
     */
    public function get numLevels():int
    {
        return _numLevels
    }

    //----------------------------------
    //  tileWidth
    //----------------------------------

    /**
     * @private
     */
    protected var _tileWidth:uint

    /**
     * @copy IImagePyramidDescriptor#tileWidth
     */
    public function get tileWidth():uint
    {
        return _tileWidth
    }

    //----------------------------------
    //  tileHeight
    //----------------------------------

    /**
     * @private
     */
    protected var _tileHeight:uint

    /**
     * @copy IImagePyramidDescriptor#tileHeight
     */
    public function get tileHeight():uint
    {
        return _tileHeight
    }

    //----------------------------------
    //  tileOverlap
    //----------------------------------

    /**
     * @private
     */
    protected var _tileOverlap:uint = 0

    /**
     * @copy IImagePyramidDescriptor#tileOverlap
     */
    public function get tileOverlap():uint
    {
        return _tileOverlap
    }

    //----------------------------------
    //  type
    //----------------------------------

    /**
     * @private
     */
    protected var _type:String

    /**
     * @copy IImagePyramidDescriptor#type
     */
    public function get type():String
    {
        return _type
    }

    //----------------------------------
    //  origin
    //----------------------------------

    /**
     * @private
     */
    protected var _origin:String = "topLeft"

    /**
     * @copy IImagePyramidDescriptor#origin
     */
    public function get origin():String
    {
        return _origin
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: IImagePyramidDescriptor
    //
    //--------------------------------------------------------------------------

    /**
     * @copy IImagePyramidDescriptor#getTileBounds()
     */
    public function getTileBounds(level:int, column:int, row:int):Rectangle
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
     * @copy IImagePyramidDescriptor#existsTile()
     */
    public function existsTile(level:int, column:int, row:int):Boolean
    {
        // By default, all tiles exist
        return true
    }

    /**
     * @copy IImagePyramidDescriptor#getTileAtPoint()
     */
    public function getTileAtPoint(level:int, point:Point):Point
    {
        var p:Point = new Point()

        var l:IImagePyramidLevel = getLevelAt(level)
        p.x = clamp(Math.floor(point.x / tileWidth), 0, l.numColumns - 1)
        p.y = clamp(Math.floor(point.y / tileHeight), 0, l.numRows - 1)

        return p
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Level management
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    private var levels:Array = []

    /**
     * @private
     */
    protected function addLevel(level:IImagePyramidLevel):IImagePyramidLevel
    {
        levels.push(level)
        return level
    }

    /**
     * @copy IImagePyramidDescriptor#getLevelAt()
     */
    public function getLevelAt(index:int):IImagePyramidLevel
    {
        if (index < 0 || index >= numLevels)
           throw new ArgumentError("[ImagePyramidDescriptorBase] Illegal level index.")

        return levels[index]
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Debug
    //
    //--------------------------------------------------------------------------

    /**
     * @inheritDoc
     */
    public function toString():String
    {
        return "source:" + source + "\n" +
               "width:" + width + "\n" +
               "height:" + height + "\n" +
               "tileWidth:" + tileWidth + "\n" +
               "tileHeight:" + tileHeight + "\n" +
               "tileOverlap:" + tileOverlap + "\n" +
               "tileFormat:" + type
    }
}

}
