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
package org.openzoom.flash.viewport
{

import flash.display.DisplayObject;

import org.openzoom.flash.viewport.INormalizedViewport;

/**
 * Interface for a viewport controller.
 */
public interface IViewportController
{
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  view
    //----------------------------------

    /**
     * Indicates the display object the controller receives events from.
     */
    function get view():DisplayObject
    function set view( value:DisplayObject ):void

    //----------------------------------
    //  viewport
    //----------------------------------

    /**
     * Indicates the viewport this controller acts upon.
     */
    function get viewport():INormalizedViewport
    function set viewport( value:INormalizedViewport ):void
}

}