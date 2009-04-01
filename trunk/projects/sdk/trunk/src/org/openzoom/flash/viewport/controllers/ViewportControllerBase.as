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
package org.openzoom.flash.viewport.controllers
{

import flash.display.DisplayObject;
import flash.events.Event;

import org.openzoom.flash.viewport.INormalizedViewport;
import org.openzoom.flash.viewport.IViewportController;

/**
 * Base class for viewport controllers. For your own controller, extend
 * this class and implement org.openzoom.flash.viewport.IViewportController.
 *
 * @see org.openzoom.flash.viewport.IViewportController
 */
public class ViewportControllerBase
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
    * Constructor.
    */
    public function ViewportControllerBase():void
    {
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  viewport
    //----------------------------------

    private var _viewport:INormalizedViewport

    /**
     * Indicates which viewport is controlled by this controller.
     */
    public function get viewport():INormalizedViewport
    {
        return _viewport
    }

    public function set viewport(value:INormalizedViewport):void
    {
        _viewport = value
    }

    //----------------------------------
    //  view
    //----------------------------------

    private var _view:DisplayObject

    /**
     * Indicates the display object this controller receives its events from.
     */
    public function get view():DisplayObject
    {
        return _view
    }

    public function set view(value:DisplayObject):void
    {
        if (view === value)
            return

        if (!value)
            view_removedFromStageHandler(null)

        _view = value

        if (value)
        {
            view.addEventListener(Event.ADDED_TO_STAGE,
                                  view_addedToStageHandler,
                                  false, 0, true)
            view.addEventListener(Event.REMOVED_FROM_STAGE,
                                  view_removedFromStageHandler,
                                  false, 0, true)

            if (view.stage)
                view_addedToStageHandler(null)
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     *
     * Documentation not available.
     */
    protected function view_addedToStageHandler(event:Event):void
    {
    }

    /**
     * @private
     *
     * Documentation not available.
     */
    protected function view_removedFromStageHandler(event:Event):void
    {
    }
}

}