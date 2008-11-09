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

import br.com.stimuli.loading.BulkLoader;

import flash.display.Bitmap;
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Rectangle;

import org.openzoom.core.INormalizedViewport;
import org.openzoom.core.IScene;
import org.openzoom.core.IZoomable;
import org.openzoom.descriptors.IMultiScaleImageDescriptor;
import org.openzoom.descriptors.IMultiScaleImageLevel;
import org.openzoom.events.ViewportEvent;
import org.openzoom.utils.math.clamp;

/**
 * Generic renderer for multi-scale images.
 */
public class MultiScaleImageRenderer extends Sprite implements IZoomable, IScene
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------
    
    private static const TILE_LOADER_NAME : String = "tileLoader"
    private static const BACKGROUND_LOADER_NAME : String = "backgroundLoader"
    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     * Constructor.
     */
    public function MultiScaleImageRenderer( descriptor : IMultiScaleImageDescriptor,
                                             width : Number, height : Number )
    {
        this.descriptor = descriptor
        
        createFrame( width, height )
        createLoader()
        createLayers( descriptor, width, height )
        
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
    private var tileLoader : BulkLoader
    private var backgroundLoader : BulkLoader

    private var layers : Array /* of ITileLayer */ = []
    private var backgroundTile : Bitmap
    private var frame : Shape
    
    //--------------------------------------------------------------------------
    //
    //  Properties: IZoomable
    //
    //--------------------------------------------------------------------------
    
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
    
    private function createLoader() : void
    {       
        tileLoader = new BulkLoader( TILE_LOADER_NAME )
        backgroundLoader = new BulkLoader( BACKGROUND_LOADER_NAME )
    }
    
    private function createLayers( descriptor : IMultiScaleImageDescriptor, width : Number, height : Number  ) : void
    {
        for( var i : int = 0; i < descriptor.numLevels; i++ )
        {
        	var layer : TileLayer = new TileLayer( frame.width, frame.height, descriptor.getLevelAt( i ))
        	layers[ i ] = layer
        	
        	// FIXME: Very large layer dimensions cause problems…
//        	layer.width = width
//        	layer.height = height
        	
        	addChild( layer )
        }	
    }
    
    private function loadBackground() : void
    {
        var level : int = getHighestSingleTileLevel()
        var url : String = descriptor.getTileURL( level, 0, 0 )
        
        backgroundLoader.add( url, { id: "background", type: "image" } )
                        .addEventListener( Event.COMPLETE, backgroundCompleteHandler )
        backgroundLoader.start()
    } 
    
    private function updateDisplayList() : void
    {
        var bounds : Rectangle = new Rectangle( 0, 0, unscaledWidth, unscaledHeight )
        var normalizedBounds : Rectangle = new Rectangle( bounds.x / viewport.scene.width,
                                                          bounds.y / viewport.scene.height,
                                                          bounds.width / viewport.scene.width,
                                                          bounds.height / viewport.scene.height )
        var visibleArea : Rectangle = viewport.intersection( normalizedBounds )
        
        var level : IMultiScaleImageLevel = descriptor.getMinimumLevelForSize( width, height )
        
        // remove all tiles from loading queue
        tileLoader.removeAll()
        
        
        for( var i : int = level.index + 1; i < descriptor.numLevels; i++ )
            getLayer( i ).removeAllTiles()
        
        
        if( renderingMode == RenderingMode.SMOOTH )
        {
	        for( var l : int = 0; l <= level.index; l++ )
	            loadTiles( descriptor.getLevelAt( l ), visibleArea )
        }
        else
        {
            loadTiles( level, visibleArea )
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
                tileLoader.add( url, { type: "image", data: tile } )
                          .addEventListener( Event.COMPLETE, tileCompleteHandler, false, 0, true  )
            }
        }
        
        // begin loading   
        tileLoader.start()
    }
    
    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------
    
    private function tileCompleteHandler( event : Event ) : void
    {
        var tile : Tile = event.target.data as Tile
        if( tile )
           tile.bitmap = event.target.loader.content
        
        var layer : ITileLayer = getLayer( tile.level )
        layer.addTile( tile )
    }
    
    private function backgroundCompleteHandler( event : Event ) : void
    {
        backgroundTile = backgroundLoader.getBitmap( "background", true )
        
        backgroundTile.smoothing = true
        backgroundTile.width = frame.width
        backgroundTile.height = frame.height
        
        addChildAt( backgroundTile, getChildIndex( frame ) )
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
    	return 1;
    	// FIXME
    	
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