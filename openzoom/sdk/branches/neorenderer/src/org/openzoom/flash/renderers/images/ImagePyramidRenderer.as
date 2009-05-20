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
package org.openzoom.flash.renderers.images
{

import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.Shape;
import flash.geom.Rectangle;
import flash.utils.Dictionary;

import org.openzoom.flash.core.openzoom_internal;
import org.openzoom.flash.descriptors.IImagePyramidDescriptor;
import org.openzoom.flash.renderers.Renderer;

/**
 * Image pyramid renderer.
 */
public final class ImagePyramidRenderer extends Renderer
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     * Constructor.
     */ 
    public function ImagePyramidRenderer()
    {
    	openzoom_internal::tileLayer = new Shape()
    	addChild(openzoom_internal::tileLayer)
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var tileCache:Dictionary /* of Tile2 */ = new Dictionary()
    openzoom_internal var tileLayer:Shape

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  source
    //----------------------------------
    
    private var _source:*
    
    public function get source():*
    {
    	return _source
    }
    
    public function set source(value:*):void
    {
    	if (_source === value)
    	   return
    	
    	_source = value
    	
//    	var descriptor:IImagePyramidDescriptor = value as IImagePyramidDescriptor
//    	
//    	if (descriptor)
//    	{
//    		var tileLayer:Shape = openzoom_internal::tileLayer
//	    	var g:Graphics = tileLayer.graphics 
//	    	g.clear()
//	    	g.beginFill(0x000000, 0)
//	    	g.drawRect(0, 0, descriptor.width, descriptor.height)
//	    	g.endFill()
//	    	
//	    	updateDisplayList()
//    	}
    }

    //----------------------------------
    //  width
    //----------------------------------
    
    private var _width:Number = 0
    
    override public function get width():Number
    {
        return _width
    }
    
    override public function set width(value:Number):void
    {
    	if (value === _width)
    	   return
    	   
        _width = value
        
        updateDisplayList()
    }

    //----------------------------------
    //  height
    //----------------------------------
    
    private var _height:Number = 0
    
    override public function get height():Number
    {
        return _height
    }
    
    override public function set height(value:Number):void
    {
    	if (value === _height)
    	   return
    	   
        _height = value
        
        updateDisplayList()    
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    private function updateDisplayList():void
    {
    	var g:Graphics = graphics
    	g.clear()
    	g.beginFill(0x000000, 0)
    	g.drawRect(0, 0, _width, _height)
    	g.endFill()
    	
//    	var tileLayer:Shape = openzoom_internal::tileLayer
//	    tileLayer.width = _width
//	    tileLayer.height = _width
    }

    //--------------------------------------------------------------------------
    //
    //  Properties: Internal
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    openzoom_internal var renderManager:ImagePyramidRenderManager
    
    //--------------------------------------------------------------------------
    //
    //  Methods: Internal
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */     
    openzoom_internal function getTile(level:int, column:int, row:int):Tile2
    {
    	var descriptor:IImagePyramidDescriptor = _source as IImagePyramidDescriptor
    	
    	if (!descriptor)
    	   trace("[ImagePyramidRenderer] getTile: Source undefined")
    	
        var tile:Tile2 = tileCache[Tile2.getHashCode(level, column, row)]
        
        if (!tile)
        {
	        var url:String = descriptor.getTileURL(level, column, row)
            var bounds:Rectangle = descriptor.getTileBounds(level, column, row)
            
            tile = new Tile2(level, column, row, url, bounds)
            tileCache[tile.hashCode] = tile
        }
        
        if (!tile.bitmapData)
        {
        	var cache:Dictionary = openzoom_internal::renderManager.openzoom_internal::tileBitmapDataCache
        	var bitmapData:BitmapData = cache[tile.url] as BitmapData
        	
        	if (bitmapData)
        	{
	        	tile.bitmapData = bitmapData 
	        	tile.loaded = true
	        	tile.loading = false
        	}
        	else
        	{
        		tile.loaded = false
        	}
        }
        
        return tile
    }
}

}
