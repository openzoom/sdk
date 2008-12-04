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
    
    /**
     * @private
     */ 
    protected var source : String
  
    //----------------------------------
    //  width
    //----------------------------------
    
    /**
     * @private
     */   
    protected var _width : uint
  
    /**
     * @copy IMultiScaleImageDescriptor#width
     */ 
    public function get width() : uint
    {
        return _width
    }
    
    //----------------------------------
    //  height
    //----------------------------------
    
    /**
     * @private
     */ 
    protected var _height : uint
  
    /**
     * @copy IMultiScaleImageDescriptor#height
     */
    public function get height() : uint
    {
        return _height
    }
    
    //----------------------------------
    //  numLevels
    //----------------------------------
    
    /**
     * @private
     */ 
    protected var _numLevels : int
  
    /**
     * @copy IMultiScaleImageDescriptor#numLevels
     */
    public function get numLevels() : int
    {
        return _numLevels
    }

    //----------------------------------
    //  tileWidth
    //----------------------------------

    /**
     * @private
     */     
    protected var _tileWidth : uint
  
    /**
     * @copy IMultiScaleImageDescriptor#tileWidth
     */
    public function get tileWidth() : uint
    {
        return _tileWidth
    }
        
    //----------------------------------
    //  tileHeight
    //----------------------------------
    
    /**
     * @private
     */ 
    protected var _tileHeight : uint
  
    /**
     * @copy IMultiScaleImageDescriptor#tileHeight
     */
    public function get tileHeight() : uint
    {
        return _tileHeight
    }
    
    //----------------------------------
    //  tileOverlap
    //----------------------------------
    
    /**
     * @private
     */ 
    protected var _tileOverlap : uint = 0
  
    /**
     * @copy IMultiScaleImageDescriptor#tileOverlap
     */
    public function get tileOverlap() : uint
    {
        return _tileOverlap
    }
    
    //----------------------------------
    //  type
    //----------------------------------
    
    /**
     * @private
     */ 
    protected var _type : String
  
    /**
     * @copy IMultiScaleImageDescriptor#type
     */
    public function get type() : String
    {
        return _type
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods: IMultiScaleImageDescriptor
    //
    //--------------------------------------------------------------------------
    
    /**
     * @copy IMultiScaleImageDescriptor#getTilePosition()
     */
    public function getTilePosition( column : uint, row : uint ) : Point
    {
        var position : Point = new Point()

        var offsetX : uint = ( column == 0 ) ? 0 : tileOverlap
        var offsetY : uint = ( row    == 0 ) ? 0 : tileOverlap

        position.x = ( column * tileWidth )  - offsetX 
        position.y = ( row    * tileHeight ) - offsetY

        return position
    }
    
    /**
     * @copy IMultiScaleImageDescriptor#existsTile()
     */
    public function existsTile( level : int, column : uint, row : uint ) : Boolean
    {
    	// By default, all tiles exist
    	return true
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods: Debug
    //
    //--------------------------------------------------------------------------
    
    /**
     * @inheritDoc
     */ 
    public function toString() : String
    {
        return "source:" + source + "\n" +
               "width:" + width + "\n" +
               "height:" + height + "\n" +
               "tileWidth:" + tileWidth + "\n" +
               "tileHeight:" + tileHeight + "\n" +
               "tileOverlap:" + tileOverlap + "\n" +
               "tileFormat:" + type
    }
}

}