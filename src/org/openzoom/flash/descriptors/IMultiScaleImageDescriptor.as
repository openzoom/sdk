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
 * Interface for describing a multiscale image.
 */
public interface IMultiScaleImageDescriptor
{
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  sources
    //----------------------------------
    
    /**
     * Returns an array of IImageSourceDescriptor objects.
     * Returns empty array in case there are no descriptors.
     */ 
    function get sources():Array

    //----------------------------------
    //  width
    //----------------------------------

    /**
     * Returns the intrinsic width of the image in pixels.
     */
    function get width():uint

    //----------------------------------
    //  height
    //----------------------------------

    /**
     * Returns the intrinsic height of the image in pixels.
     */
    function get height():uint
}

}
