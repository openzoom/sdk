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

import flash.geom.Point;
import flash.geom.Rectangle;

/**
 * Interface of a multiscale image pyramid descriptor.
 */
public interface IImagePyramidDescriptor
{
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  sources
    //----------------------------------
    
    /**
     * Returns an array of IImageSourceDescriptor objects.
     * Returns empty array in case there are no descriptors.
     */ 
    function get sources():Array

    //----------------------------------
    //  width
    //----------------------------------

    /**
     * Returns the intrinsic width of the image in pixels.
     */
    function get width():uint

    //----------------------------------
    //  height
    //----------------------------------

    /**
     * Returns the intrinsic height of the image in pixels.
     */
    function get height():uint

    //----------------------------------
    //  numLevels
    //----------------------------------

    /**
     * Returns the number of levels of this object.
     */
    function get numLevels():int

    //----------------------------------
    //  tileWidth
    //----------------------------------

    /**
     * Returns the width of a single tile of the image pyramid in pixels.
     */
    function get tileWidth():uint

    //----------------------------------
    //  tileHeight
    //----------------------------------

    /**
     * Returns the height of a single tile of the image pyramid in pixels.
     */
    function get tileHeight():uint

    //----------------------------------
    //  tileOverlap
    //----------------------------------

    /**
     * Returns the tile overlap in pixels.
     * @default 0
     */
    function get tileOverlap():uint

    //----------------------------------
    //  type
    //----------------------------------

    /**
     * Returns the mime-type of the image pyramid tiles, e.g. &lt;image/jpeg&gt; or &lt;image/png&gt;.
     */
    function get type():String

    //----------------------------------
    //  origin
    //----------------------------------

    /**
     * Returns the origin of the coordinate system for addressing tiles.
     *
     * @default topLeft
     */
    function get origin():String

    //--------------------------------------------------------------------------
    //
    //  Methods: Levels
    //
    //--------------------------------------------------------------------------

    /**
     * Returns the image pyramid level that exists at the specified index.
     */
    function getLevelAt(index:int):IImagePyramidLevel

    /**
     * Returns the minimum pyramid level that has a greater or equal size
     * than specified by the arguments width and height.
     */
    function getLevelForSize(width:Number, height:Number):IImagePyramidLevel

    //--------------------------------------------------------------------------
    //
    //  Methods: Tiles
    //
    //--------------------------------------------------------------------------

    /**
     * Returns a Boolean indicating if the tile at the given level, row and column exists.
     */
    function existsTile(level:int, column:uint, row:uint):Boolean

    /**
     * Returns the URL of the tile specified by its level, column and row.
     */
    function getTileURL(level:int, column:uint, row:uint):String

    /**
     * Returns the bounds (position and dimensions) of the tile specified
     * by the level, column and row.
     */
    function getTileBounds(level:int, column:uint, row:uint):Rectangle

    /**
     * Returns the tile at the given level under the given point.
     */
    function getTileAtPoint(level:int, point:Point):Point

    //--------------------------------------------------------------------------
    //
    //  Methods: Utility
    //
    //--------------------------------------------------------------------------

    /**
     * Returns a copy of this object.
     */
    function clone():IImagePyramidDescriptor
}

}
