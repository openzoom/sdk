////////////////////////////////////////////////////////////////////////////////
//
//  OpenZoom
//
//  Copyright (c) 2007–2008, Daniel Gasienica <daniel@gasienica.ch>
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

import flash.geom.Rectangle;	

/**
 * The IMultiScaleImageLevel interface defines a set of properties
 * a level of a multi-scale image pyramid has to expose.
 */
public interface IMultiScaleImageLevel
{
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  index
    //----------------------------------
    
    /**
     * Returns the index of this level which is in the range [0, numLevels)
     */
    function get index() : int
    
    //----------------------------------
    //  width
    //----------------------------------
    
    /**
     * Returns the width of this level in pixels.
     */ 
    function get width() : uint
    
    //----------------------------------
    //  height
    //----------------------------------
    
    /**
     * Returns the height of this level in pixels.
     */
    function get height() : uint
    
    //----------------------------------
    //  numColumns
    //----------------------------------
    
    /**
     * Returns the number of columns of tiles for this level.
     */
    function get numColumns() : uint
    
    //----------------------------------
    //  numRows
    //----------------------------------

    /**
     * Returns the number of rows of tiles for this level.
     */
    function get numRows() : uint
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * Returns the URL of the tile at the specified position.
     */ 
    function getTileURL( column : uint, row : uint ) : String
    
//  /**
//   * Returns the position of the specified tile.
//   */
//  function getTilePosition( column : uint, row : uint ) : Point
    
    /**
     * Returns the bounds of the specified tile.
     */
    function getTileBounds( column : uint, row : uint ) : Rectangle
    
    /**
     * Returns a copy of this object.
     */ 
    function clone() : IMultiScaleImageLevel
}

}