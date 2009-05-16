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
package org.openzoom.flash.descriptors
{

import flash.errors.IllegalOperationError;
import flash.geom.Point;
import flash.geom.Rectangle;

/**
 * @private
 *
 * Base class for classes implementing IImagePyramidDescriptor.
 * Provides the basic getter/setter skeletons.
 */
public class ImagePyramidDescriptorBase
{
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  uri
    //----------------------------------

    /**
     * @private
     */
    protected var _uri:String

    /**
     * @private
     */
    public function get uri():String
    {
        return _uri
    }

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
    public function getTileBounds(level:int, column:uint, row:uint):Rectangle
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
    public function existsTile(level:int, column:uint, row:uint):Boolean
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

        p.x = Math.floor(point.x / tileWidth)
        p.y = Math.floor(point.y / tileHeight)
        
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
        return "source:" + uri + "\n" +
               "width:" + width + "\n" +
               "height:" + height + "\n" +
               "tileWidth:" + tileWidth + "\n" +
               "tileHeight:" + tileHeight + "\n" +
               "tileOverlap:" + tileOverlap + "\n" +
               "tileFormat:" + type
    }
}

}
