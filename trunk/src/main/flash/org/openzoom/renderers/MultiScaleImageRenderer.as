////////////////////////////////////////////////////////////////////////////////
//
//  OpenZoom
//  Copyright (c) 2008, Daniel Gasienica <daniel@gasienica.ch>
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
package org.openzoom.renderers
{

import flash.display.Bitmap;
import flash.display.Graphics;
import flash.display.Loader;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Rectangle;

import org.openzoom.core.INormalizedViewport;
import org.openzoom.core.IZoomable;
import org.openzoom.descriptors.IMultiScaleImageDescriptor;
import org.openzoom.descriptors.IMultiScaleImageLevel;
import org.openzoom.events.TileRequestEvent;
import org.openzoom.events.ViewportEvent;
import org.openzoom.net.TileLoader;
import org.openzoom.renderers.images.ITileLayer;
import org.openzoom.renderers.images.RenderingMode;
import org.openzoom.renderers.images.Tile;
import org.openzoom.renderers.images.TileLayer;
import org.openzoom.utils.math.clamp;

/**
 * Generic renderer for multi-scale images.
 */
public class MultiScaleImageRenderer extends Sprite implements IZoomable
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     * Constructor.
     */
    public function MultiScaleImageRenderer( descriptor : IMultiScaleImageDescriptor,
                                             loader : TileLoader, width : Number, height : Number )
    {
    	tileLoader = loader
    	
        this.descriptor = descriptor
        
        createFrame( width, height )
        createLayers( descriptor, frame.width, frame.height )
        
        // TODO: Debug
        createDebugLayer()
        
        // Load highest single tile level as background to prevent
        // artifacts between tiles in case we have a format that doesn't
        // feature tile overlap.
        if( descriptor.tileOverlap == 0 ) 
            loadBackground()
    }
    
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    private var renderingMode : String = RenderingMode.SMOOTH
    
    private var descriptor : IMultiScaleImageDescriptor
    private var tileLoader : TileLoader
    private var backgroundLoader : Loader

    private var layers : Array /* of ITileLayer */ = []
    private var backgroundTile : Bitmap
    private var frame : Shape
    private var debugLayer : Shape
    
    //--------------------------------------------------------------------------
    //
    //  Properties: IZoomable
    //
    //--------------------------------------------------------------------------
        
    //----------------------------------
    //  viewport
    //----------------------------------
    
    private var _viewport : INormalizedViewport
    
    public function get viewport() : INormalizedViewport
    {
        return _viewport
    }
    
    public function set viewport( value : INormalizedViewport ) : void
    {
        if( viewport === value )
            return
        
        // remove old event listener
        if( viewport )
            viewport.removeEventListener( ViewportEvent.CHANGE_COMPLETE,
                                          viewport_changeCompleteHandler )
        
        _viewport = value
        
        // register new event listener
        if( viewport )
            viewport.addEventListener( ViewportEvent.CHANGE_COMPLETE,
                                       viewport_changeCompleteHandler, false, 0, true )
    }
    
    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------
    
    private function viewport_changeCompleteHandler( event : ViewportEvent ) : void
    {
        updateDisplayList()
    }
       
    //--------------------------------------------------------------------------
    //
    //  Methods: Internal
    //
    //--------------------------------------------------------------------------
    
    private function createFrame( width : Number, height : Number ) : void
    {
        frame = new Shape()
        var g : Graphics = frame.graphics
        g.beginFill( 0x000000, 0 )
        g.drawRect( 0, 0, width, height )
        g.endFill()
        
        addChildAt( frame, 0 )
    }
    
    private function createDebugLayer() : void
    {
    	debugLayer = new Shape()
    	addChild( debugLayer )
    }
    
    private function drawVisibleRegion( region : Rectangle ) : void
    {
    	var g : Graphics = debugLayer.graphics
    	    g.clear()
    	    g.lineStyle( 0, 0xFF0000 )
    	    g.beginFill( 0x000000, 0 )
    	    // TODO: Debug
//    	    g.drawRect( Math.max( 0, region.x ),
//    	                Math.max( 0, region.y ),
//    	                Math.min( frame.width, region.width ),
//    	                Math.min( frame.height, region.height ))
            g.drawRect( region.x, region.y, region.width, region.height )
    	    g.endFill()	
    }
    
    private function createLayers( descriptor : IMultiScaleImageDescriptor, width : Number, height : Number  ) : void
    {
        for( var i : int = 0; i < descriptor.numLevels; i++ )
        {
            var level : IMultiScaleImageLevel = descriptor.getLevelAt( i )
        	var layer : TileLayer = new TileLayer( level.width, level.height, level )
//          var layer : TileLayer = new TileLayer( frame.width, frame.height, level )
        	layers[ i ] = layer
        	
        	// FIXME: Very large layer dimensions cause problems…
        	layer.width = width
        	layer.height = height
        	
        	addChild( layer )
        }	
    }
    
    private function loadBackground() : void
    {
        var level : int = getHighestSingleTileLevel()
        var url : String = descriptor.getTileURL( level, 0, 0 )
        
        tileLoader.add( url ).addEventListener( Event.COMPLETE, backgroundCompleteHandler )
    } 
    
    private function updateDisplayList() : void
    {
//    	debugLayer.graphics.clear()
    	
        var bounds : Rectangle
            bounds = getBounds( viewport.scene.owner )
            
            bounds.x /= Math.abs( scaleX )
            bounds.y /= Math.abs( scaleY )
            bounds.width /= Math.abs( scaleX )
            bounds.height /= Math.abs( scaleY )
        
        var normalizedBounds : Rectangle = bounds.clone()
            normalizedBounds.x /= viewport.scene.sceneWidth
            normalizedBounds.y /= viewport.scene.sceneHeight
            normalizedBounds.width /= viewport.scene.sceneWidth
            normalizedBounds.height /= viewport.scene.sceneHeight

        var visibleRegion : Rectangle = viewport.intersection( normalizedBounds )
        visibleRegion.offset( -bounds.x, -bounds.y )      

//        drawVisibleRegion( visibleRegion )
        
        var scale : Number = viewport.scale
        var level : IMultiScaleImageLevel = descriptor.getMinimumLevelForSize( width * scale, height * scale )
        
        // remove all tiles from loading queue
//        tileLoader.removeAll()
        
        
        var firstLevel : int = level.index + 1
//        if( !viewport.intersects( normalizedBounds ))
//            firstLevel = Math.max( 1, Math.ceil( level.index / 4 ))
//            
        for( var i : int = firstLevel; i < descriptor.numLevels; i++ )
            getLayer( i ).removeAllTiles()
        
        if( renderingMode == RenderingMode.SMOOTH )
        {
	        for( var l : int = 0; l <= level.index; l++ )
	            loadTiles( descriptor.getLevelAt( l ), visibleRegion )
//	            setTimeout( loadTiles, i * 100, descriptor.getLevelAt( l ), visibleRegion )
        }
        else
        {
            loadTiles( level, visibleRegion )
        }
    }
    
    private function loadTiles( level : IMultiScaleImageLevel, area : Rectangle ) : void
    {
        var minColumn : int = Math.max( 0, Math.floor( area.left * level.numColumns / unscaledWidth ))
        var maxColumn : int = Math.min( level.numColumns, Math.ceil( area.right * level.numColumns / unscaledWidth ))
        var minRow    : int = Math.max( 0, Math.floor( area.top * level.numRows / unscaledHeight ))
        var maxRow    : int = Math.min( level.numRows, Math.ceil( area.bottom * level.numRows / unscaledHeight ))

        var layer : ITileLayer = getLayer( level.index )

        for( var column : int = minColumn; column < maxColumn; column++ )
        {
            for( var row : int = minRow; row < maxRow; row++ ) 
            {
                var tile : Tile = new Tile( null, level.index, row, column, descriptor.tileOverlap )
                
                if( layer.containsTile( tile ))
                   continue
                
                var url : String = descriptor.getTileURL( tile.level, tile.column, tile.row )
                tileLoader.add( url, tile )
                          .addEventListener( Event.COMPLETE, tileCompleteHandler, false, 0, true  )
            }
        }
    }
    
    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------
    
    private function tileCompleteHandler( event : TileRequestEvent ) : void
    {
        var tile : Tile = event.context as Tile
            tile.bitmap = event.data
        
        var layer : ITileLayer = getLayer( tile.level )
        layer.addTile( tile )
    }
    
    private function backgroundCompleteHandler( event : TileRequestEvent ) : void
    {
        backgroundTile = event.data as Bitmap
        backgroundTile.smoothing = true
        backgroundTile.width = frame.width
        backgroundTile.height = frame.height
        
        addChildAt( backgroundTile, getChildIndex( frame ))
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties: Internal
    //
    //--------------------------------------------------------------------------
    
    private function get unscaledWidth() : Number
    {
        return width / Math.abs( scaleX )
    }
    
    private function get unscaledHeight() : Number
    {
        return height / Math.abs( scaleY )
    }
    
    
    //--------------------------------------------------------------------------
    //
    //  Methods: Internal
    //
    //--------------------------------------------------------------------------
    
    private function getLayer( index : int ) : ITileLayer
    {
    	return ITileLayer( layers[ index ] )
    }
    
    private function getHighestSingleTileLevel() : int
    {
    	if( !descriptor.getLevelAt( 0 ))
    	   return 0;
    	
        var i : int = 0
        var level : IMultiScaleImageLevel

        do        
        {
            level = descriptor.getLevelAt( i )
            i++
        }
        while( level.numColumns == 1 && level.numRows == 1 )
        
        var index : int = clamp( level.index - 1, 0, descriptor.numLevels - 1 ) 
        return index
    }
}

}