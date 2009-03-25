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
package org.openzoom.flash.utils
{

import flash.geom.Point;


/**
 * Utility class for doing computations with the Z-order (Morton-order) which
 * is a space-filling curve. For example, the Z-order is used by Deep Zoom for
 * laying out tiles in collections. Creates beautiful fractal layouts.
 *
 * @see http://en.wikipedia.org/wiki/Z-order_(curve)
 * @see http://msdn.microsoft.com/en-us/library/cc645077(VS.95).aspx#Collections
 * @see http://graphics.stanford.edu/~seander/bithacks.html#InterleaveTableObvious
 */
public final class ZOrder
{
    /**
     * Returns the position (column, row) of a given Morton number.
     *
     * @param value Z-order (Morton number)
     *
     * @return Position of the Z-order in space (column, row)
     */
    public static function getPosition( value:uint ):Point
    {
        var column:uint
        var row:uint

        for( var i:uint = 0; i < 32; i += 2 )
        {
            var offset:uint = i / 2

            var columnOffset:uint = i
            var columnMask:uint = 1 << columnOffset
            var columnValue:uint = ( value & columnMask ) >> columnOffset
            column |= columnValue << offset

            var rowOffset:uint = i + 1
            var rowMask:uint = 1 << rowOffset
            var rowValue:uint = ( value & rowMask ) >> rowOffset
            row |= rowValue << offset
        }

        var position:Point = new Point( column, row )
        return position
    }

    /**
     * Returns Z-order (Morton number) for the given position (column, row).
     *
     * @param column Column of the position
     * @param row Row of the position
     *
     * @return Z-order (Morton number) for the given coordinates.
     */
    public static function getValue( column:uint, row:uint ):uint
    {
        var zOrder:uint

        for( var i:int = 0; i < 32; i++ )
            zOrder |= ( column & 1 << i ) << i | ( row & 1 << i ) << ( i + 1 )

        return zOrder
    }
}

}