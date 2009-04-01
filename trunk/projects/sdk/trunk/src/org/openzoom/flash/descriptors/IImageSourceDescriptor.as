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
package org.openzoom.flash.descriptors
{

/**
 * Interface for a descriptor of an image source.
 */
public interface IImageSourceDescriptor
{
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  width
    //----------------------------------

    /**
     * Intrinsic width of the image source in pixels.
     */
    function get width():uint

    //----------------------------------
    //  height
    //----------------------------------

    /**
     * Intrinsic height of the image source in pixels.
     */
    function get height():uint

    //----------------------------------
    //  uri
    //----------------------------------

    /**
     * Absolute URI to the image source.
     */
    function get uri():String

    //----------------------------------
    //  type
    //----------------------------------

    /**
     * Mime-type of the image source.
     */
    function get type():String

    //--------------------------------------------------------------------------
    //
    //  Methods: Utility
    //
    //--------------------------------------------------------------------------

    /**
     * Returns a copy of this object.
     */
    function clone():IImageSourceDescriptor
}

}
