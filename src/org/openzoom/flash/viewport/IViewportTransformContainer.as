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

/**
 * Interface to the viewport for a viewport container.
 * Allows the container to the set the size (viewportWidth and viewportHeight)
 * of IViewportTransform.
 */
public interface IViewportTransformContainer extends IViewportTransform
{
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     * Sets viewportWidth and viewportHeight.
     * Dispatches ViewportEvent.RESIZE
     *
     * @see org.openzoom.flash.events.ViewportEvent#resize
     */
    function setSize(width:Number, height:Number):void
}

}
