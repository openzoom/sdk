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
 * Base class for classes implementing IMultiScaleImageDescriptor.
 * Provides the basic getter / setter skeletons.
 */
public class MultiScaleImageDescriptorBase
{    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  source
    //----------------------------------
    
    protected var _source : String
  
    public function get source() : String
    {
        return _source
    }
    
    //----------------------------------
    //  format
    //----------------------------------
    
    protected var _format : String
  
    public function get format() : String
    {
        return _format
    }
        
    //----------------------------------
    //  width
    //----------------------------------
    
    protected var _width : uint
  
    public function get width() : uint
    {
        return _width
    }
    
    //----------------------------------
    //  height
    //----------------------------------
    
    protected var _height : uint
  
    public function get height() : uint
    {
        return _height
    }
    
    //----------------------------------
    //  numLevels
    //----------------------------------
    
    protected var _numLevels : int
  
    public function get numLevels() : int
    {
        return _numLevels
    }
        
    //----------------------------------
    //  tileWidth
    //----------------------------------
    
    protected var _tileWidth : uint
  
    public function get tileWidth() : uint
    {
        return _tileWidth
    }
        
    //----------------------------------
    //  tileHeight
    //----------------------------------
    
    protected var _tileHeight : uint
  
    public function get tileHeight() : uint
    {
        return _tileHeight
    }
    
    //----------------------------------
    //  tileOverlap
    //----------------------------------
    
    protected var _tileOverlap : uint = 0
  
    public function get tileOverlap() : uint
    {
        return _tileOverlap
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods: IMultiScaleImageDescriptor
    //
    //--------------------------------------------------------------------------
    
    public function getTilePosition( level : int, column : uint, row : uint ) : Point
    {
        var position : Point = new Point()

        var offsetX : uint = ( column == 0 ) ? 0 : tileOverlap
        var offsetY : uint = ( row    == 0 ) ? 0 : tileOverlap

        position.x = ( column * tileWidth )  - offsetX 
        position.y = ( row    * tileHeight ) - offsetY

        return position
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods: Debug
    //
    //--------------------------------------------------------------------------
    
    public function toString() : String
    {
        return "source:" + source + "\n" +
               "width:" + width + "\n" +
               "height:" + height + "\n" +
               "tileWidth:" + tileWidth + "\n" +
               "tileHeight:" + tileHeight + "\n" +
               "tileOverlap:" + tileOverlap + "\n" +
               "format:" + format
    }
}

}