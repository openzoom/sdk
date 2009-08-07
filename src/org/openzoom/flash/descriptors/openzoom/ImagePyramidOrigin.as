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
package org.openzoom.flash.descriptors.openzoom
{

/**
 * Represents the coordinate system origin of the image pyramid.
 * Added due to great feedback from Klokan Petr Pridal to support the
 * Tile Map Service Specification (TMS).
 *
 * @see http://wiki.osgeo.org/wiki/Tile_Map_Service_Specification
 */
internal final class ImagePyramidOrigin
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------
    
    public static const TOP_LEFT:String = "topLeft"
    public static const TOP_RIGHT:String = "topRight"
    public static const BOTTOM_RIGHT:String = "bottomRight"
    public static const BOTTOM_LEFT:String = "bottomLeft"
    
    //--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------

    /**
     * Returns <code>true</code> if <code>value</code> is one of the
     * values in the enumeration, otherwise <code>false</code>.
     */
    public static function isValid(value:String):Boolean
    {
        return value == ImagePyramidOrigin.TOP_LEFT ||
               value == ImagePyramidOrigin.TOP_RIGHT ||
               value == ImagePyramidOrigin.BOTTOM_RIGHT ||
               value == ImagePyramidOrigin.BOTTOM_LEFT
    }
}

}
