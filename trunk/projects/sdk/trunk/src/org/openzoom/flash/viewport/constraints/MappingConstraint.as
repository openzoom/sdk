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
package org.openzoom.flash.viewport.constraints
{

import org.openzoom.flash.viewport.IViewportConstraint;
import org.openzoom.flash.viewport.IViewportTransform;

/**
 * @private
 *
 * Viewport constraint that ensures that the viewport only reaches zoom
 * values that are powers of two. Very useful for mapping application where
 * map tiles contain text labels and best look at scales that are power of two.
 */
public class MappingConstraint implements IViewportConstraint
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    private static const LOG2_3:Number = 1.5849625007211563

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function MappingConstraint()
    {
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: IViewportConstraint
    //
    //--------------------------------------------------------------------------

    /**
     * @inheritDoc
     */
    public function validate(transform:IViewportTransform,
                              target:IViewportTransform):IViewportTransform
    {
        transform.scale = roundToNearestPowerOf2(transform.scale)
        return transform
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Internal
    //
    //--------------------------------------------------------------------------

    private function roundToNearestPowerOf2(value:Number):Number
    {
        // snap to scale that are powers of two
        // most map tiles look best that way
        var exp:Number = Math.log(value) / Math.LN2
        var r:Number = exp - Math.floor(exp)

        var n:Number
        if (r < LOG2_3 - 1)
            n = Math.floor(exp)
        else
            n = Math.ceil(exp)

        if (n == 0)
            n = 1

        return Math.pow(2, n)
    }
}

}
