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
package org.openzoom.flash.events
{

import flash.events.Event;

import org.openzoom.flash.viewport.IViewportTransform;

/**
 * Viewport event class.
 */
public class ViewportEvent extends Event
{
    //--------------------------------------------------------------------------
    //
    //  Class Constants
    //
    //--------------------------------------------------------------------------

    public static const RESIZE : String = "resize"
    public static const TRANSFORM_START : String = "transformStart"
    public static const TRANSFORM_UPDATE : String = "transformUpdate"
    public static const TRANSFORM_END : String = "transformComplete"
    public static const TARGET_UPDATE : String = "targetUpdate"

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function ViewportEvent( type : String,
                                   bubbles : Boolean = false,
                                   cancelable : Boolean = false,
                                   oldTransform : IViewportTransform = null )
    {
        super( type, bubbles, cancelable )

        _oldTransform = oldTransform
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  oldTransform
    //----------------------------------

    private var _oldTransform : IViewportTransform

    /**
     * The transform that was previously applied to the viewport.
     */
    public function get oldTransform() : IViewportTransform
    {
        return _oldTransform
    }

    //--------------------------------------------------------------------------
    //
    //  Overriden methods: Event
    //
    //--------------------------------------------------------------------------

    /**
     * @inheritDoc
     */
    override public function clone() : Event
    {
        return new ViewportEvent( type, bubbles, cancelable, oldTransform )
    }
}

}