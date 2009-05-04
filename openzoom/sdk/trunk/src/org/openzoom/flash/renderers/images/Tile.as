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

import flash.display.Bitmap;

/**
 * @private
 *
 * Multiscale image tile.
 */
public class Tile
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function Tile(bitmap:Bitmap,
                         level:uint,
                         row:uint,
                         column:uint,
                         overlap:uint=0)
    {
        this.bitmap = bitmap
        _level = level
        _row = row
        _column = column
        _overlap = overlap
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  bitmap
    //----------------------------------

    public var bitmap:Bitmap

    //----------------------------------
    //  level
    //----------------------------------

    private var _level:int

    public function get level():int
    {
        return _level
    }

    //----------------------------------
    //  column
    //----------------------------------

    private var _column:uint

    public function get column():uint
    {
        return _column
    }

    //----------------------------------
    //  row
    //----------------------------------

    private var _row:uint

    public function get row():uint
    {
        return _row
    }

    //----------------------------------
    //  overlap
    //----------------------------------

    private var _overlap:uint = 0

    public function get overlap():uint
    {
        return _overlap
    }

    //----------------------------------
    //  hashCode
    //----------------------------------

    public function get hashCode():int
    {
        return int(level.toString() + column.toString() + row.toString())
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Debug
    //
    //--------------------------------------------------------------------------

    public function toString():String
    {
        return "[Tile]" + "\n" +
               "width: " + (bitmap ? bitmap.width:0) + "\n" +
               "height: " + (bitmap ? bitmap.height:0) + "\n" +
               "level: " + level + "\n" +
               "column: " + column + "\n" +
               "row: " + row + "\n" +
               "overlap: " + overlap
    }
}

}
