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

import flash.geom.Point
import flash.geom.Rectangle;

/**
 * Interface of a multiscale image pyramid descriptor.
 */
public interface IImagePyramidDescriptor extends IMultiScaleImageDescriptor
{
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

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
    function existsTile(level:int, column:int, row:int):Boolean

    /**
     * Returns the URL of the tile specified by its level, column and row.
     */
    function getTileURL(level:int, column:int, row:int):String

    /**
     * Returns the bounds (position and dimensions) of the tile specified
     * by the level, column and row.
     */
    function getTileBounds(level:int, column:int, row:int):Rectangle

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
