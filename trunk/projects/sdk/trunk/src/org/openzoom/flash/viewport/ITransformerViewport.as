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
 * Represents a viewport that can be animated / transformed.
 */
public interface ITransformerViewport extends IViewport
{
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  transform
    //----------------------------------

    /**
     * Transformation that is currently applied to the viewport
     */
    function get transform():IViewportTransform
    function set transform(value:IViewportTransform):void

    //--------------------------------------------------------------------------
    //
    //  Methods: Events
    //
    //--------------------------------------------------------------------------

    /**
     * Dispatch <code>transformStart</code> event to
     * let all listeners know that a viewport transition has started.
     */
    function beginTransform():void

    /**
     * Dispatch <code>transformEnd</code> event to
     * let all listeners know that a viewport transition has finished.
     */
    function endTransform():void
}

}