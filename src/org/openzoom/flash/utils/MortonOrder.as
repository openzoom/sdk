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
package org.openzoom.flash.utils
{

import flash.geom.Point;

import org.openzoom.flash.core.openzoom_internal;

use namespace openzoom_internal;

/**
 * Utility class for doing computations with the Morton-order (Z-order) which
 * is a space-filling curve. For example, the Morton-order is used by Deep Zoom for
 * laying out tiles in collections. Creates beautiful fractal layouts.
 *
 * @see http://en.wikipedia.org/wiki/Z-order_(curve)
 * @see http://msdn.microsoft.com/en-us/library/cc645077(VS.95).aspx#Collections
 * @see http://graphics.stanford.edu/~seander/bithacks.html#InterleaveTableObvious
 */
public final class MortonOrder
{
	include "../core/Version.as"

    //--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------

    /**
     * Returns the position (column, row) for a given Morton number.
     *
     * @param value Morton number (Z-order)
     *
     * @return Position of the Morton number in space (column, row)
     */
    public static function getPosition(value:uint):Point
    {
        var column:uint
        var row:uint

        for (var i:uint = 0; i < 32; i += 2)
        {
            var offset:uint = i / 2

            var columnOffset:uint = i
            var columnMask:uint = 1 << columnOffset
            var columnValue:uint = (value & columnMask) >> columnOffset
            column |= columnValue << offset

            var rowOffset:uint = i + 1
            var rowMask:uint = 1 << rowOffset
            var rowValue:uint = (value & rowMask) >> rowOffset
            row |= rowValue << offset
        }

        var position:Point = new Point(column, row)
        return position
    }

    /**
     * Returns Morton number for the given position (column, row).
     *
     * @param column Column of the position
     * @param row Row of the position
     *
     * @return Morton number for the given coordinates.
     */
    public static function getValue(column:int, row:int):uint
    {
        var mortonOrder:uint

        for (var i:int = 0; i < 32; i++)
            mortonOrder |= (column & 1 << i) << i | (row & 1 << i) << (i + 1)

        return mortonOrder
    }
}

}
