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
 * Provides a way to limit the minimum and maximum scale the scene can reach.
 */
public class ScaleConstraint implements IViewportConstraint
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    private static const DEFAULT_MIN_SCALE:Number = 0.00001
    private static const DEFAULT_MAX_SCALE:Number = 1000000

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function ScaleConstraint()
    {
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  minScale
    //----------------------------------

    private var _minScale:Number = DEFAULT_MIN_SCALE

    /**
     * Minimum scale the scene can reach.
     */
    public function get minScale():Number
    {
        return _minScale
    }

    public function set minScale( value:Number ):void
    {
        _minScale = value
    }

    //----------------------------------
    //  maxScale
    //----------------------------------

    private var _maxScale:Number = DEFAULT_MAX_SCALE

    /**
     * Maximum scale the scene can reach.
     */
    public function get maxScale():Number
    {
        return _maxScale
    }

    public function set maxScale( value:Number ):void
    {
       _maxScale = value
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: IViewportConstraint
    //
    //--------------------------------------------------------------------------

    /**
     * @inheritDoc
     */
    public function validate( transform:IViewportTransform,
                              target:IViewportTransform ):IViewportTransform
    {
        // FIXME
        // Prevent from moving when the scale limist are reached
//        if( transform.scale == minScale || transform.scale == maxScale )
//        {
////            target.panTo( transform.x, transform.y )
//            return target
//        }

        // validate zoom
        if( transform.scale > maxScale )
            transform.scale = maxScale

        if( transform.scale < minScale )
            transform.scale = minScale

        // return validated transform
        return transform
    }
}

}