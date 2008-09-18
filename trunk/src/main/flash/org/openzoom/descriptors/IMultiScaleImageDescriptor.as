////////////////////////////////////////////////////////////////////////////////
//
//  OpenZoom
//  Copyright (c) 2008 Daniel Gasienica <daniel@gasienica.ch>
//
//  OpenZoom is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  OpenZoom is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU Affero General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with OpenZoom. If not, see <http://www.gnu.org/licenses/>.
//
////////////////////////////////////////////////////////////////////////////////
package org.openzoom.descriptors
{

import flash.geom.Point;	

/**
 * Interface describing the common API of a multi-scale image.
 */
public interface IMultiScaleImageDescriptor
{
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  source
    //----------------------------------
    
    /**
     * Returns the source URI of this multiscale image.
     */ 
    function get source() : String
      
    //----------------------------------
    //  format
    //----------------------------------
      
    /**
     * Returns the image format of the image pyramid tiles, e.g. JPEG, PNG, etc.
     */
    function get format() : String
    
    //----------------------------------
    //  width
    //----------------------------------
    
    /**
     * Returns the intrinsic width of the image in pixels.
     */ 
    function get width() : uint
    
    //----------------------------------
    //  height
    //----------------------------------

    /**
     * Returns the intrinsic height of the image in pixels.
     */
    function get height() : uint
      
    //----------------------------------
    //  numLevels
    //----------------------------------
    
    /**
     * Returns the number of levels of this object. 
     */ 
    function get numLevels() : int
    
    //----------------------------------
    //  tileWidth
    //----------------------------------
    
    /**
     * Returns the width of a single tile of the image pyramid in pixels.
     */ 
	function get tileWidth() : uint
    
    //----------------------------------
    //  tileHeight
    //----------------------------------
    
    /**
     * Returns the height of a single tile of the image pyramid in pixels.
     */ 
	function get tileHeight() : uint
    
    //----------------------------------
    //  overlap
    //----------------------------------
    
    /**
     * Returns the tile overlap in pixels.
     * @default 0
     */
	function get tileOverlap() : uint
	
	//--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     * Returns the URL of the tile specified by its level, column & row.
     */
    function getTileURL( level : int, column : uint, row : uint ) : String

    /**
     * Returns the position of the tile specified by its level, column & row.
     */
    function getTilePosition( level : int, column : uint, row : uint ) : Point

    /**
     * Returns the image pyramid level that exists at the specified index.
     */
    function getLevelAt( index : int ) : IMultiScaleImageLevel

    /**
     * Returns the minimum level that has greater or equal size as specified by width and height.
     */
    function getMinimumLevelForSize( width : Number, height : Number ) : IMultiScaleImageLevel
}

}