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
package org.openzoom.flash.renderers.images
{

import org.openzoom.flash.descriptors.IMultiScaleImageLevel;

/**
 * @private
 *
 * Tile layer interface.
 */
public interface ITileLayer
{
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    function containsTile(tile:Tile):Boolean
    function addTile(tile:Tile):Tile
    function removeAllTiles():void

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  level
    //----------------------------------

    function get level():IMultiScaleImageLevel

    //----------------------------------
    //  width
    //----------------------------------

    function get width():Number
    function set width(value:Number):void

    //----------------------------------
    //  height
    //----------------------------------

    function get height():Number
    function set height(value:Number):void

    //----------------------------------
    //  visible
    //----------------------------------

    function get visible():Boolean
    function set visible(value:Boolean):void

    //----------------------------------
    //  alpha
    //----------------------------------

    function get alpha():Number
    function set alpha(value:Number):void
}

}