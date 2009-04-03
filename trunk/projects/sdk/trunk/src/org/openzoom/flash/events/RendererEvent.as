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
 * Renderer event class.
 */
public class RendererEvent extends Event
{
    //--------------------------------------------------------------------------
    //
    //  Class Constants
    //
    //--------------------------------------------------------------------------

    public static const ADDED_TO_SCENE:String = "addedToScene"

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function RendererEvent(type:String,
                                  bubbles:Boolean=false,
                                  cancelable:Boolean=false)
    {
        super(type, bubbles, cancelable)
    }

    //--------------------------------------------------------------------------
    //
    //  Overriden methods: Event
    //
    //--------------------------------------------------------------------------

    /**
     * @inheritDoc
     */
    override public function clone():Event
    {
        return new RendererEvent(type, bubbles, cancelable)
    }
}

}
