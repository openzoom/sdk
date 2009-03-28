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
 * Provides a way to limit the minimum and maximum zoom the viewport can reach.
 */
public class ZoomConstraint implements IViewportConstraint
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    private static const DEFAULT_MIN_ZOOM:Number = 0.000001
    private static const DEFAULT_MAX_ZOOM:Number = 10000000

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function ZoomConstraint()
    {
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  minZoom
    //----------------------------------

    private var _minZoom:Number = DEFAULT_MIN_ZOOM

    /**
     * Minimum zoom the viewport can reach.
     */
    public function get minZoom():Number
    {
        return _minZoom
    }

    public function set minZoom( value:Number ):void
    {
        _minZoom = value
    }

    //----------------------------------
    //  maxZoom
    //----------------------------------

    private var _maxZoom:Number = DEFAULT_MAX_ZOOM


    /**
     * Maximum zoom the viewport can reach.
     */
    public function get maxZoom():Number
    {
        return _maxZoom
    }

    public function set maxZoom( value:Number ):void
    {
       _maxZoom = value
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
        // Prevent from moving when the zoom limit are reached
//        if( transform.zoom == minZoom || transform.zoom == maxZoom )
//        {
////          target.panTo( transform.x, transform.y )
//            return target
//        }

        // validate zoom
        if( transform.zoom > maxZoom )
            transform.zoomTo( maxZoom )

        if( transform.zoom < minZoom )
            transform.zoomTo( minZoom )

        // return validated transform
        return transform
    }
}

}