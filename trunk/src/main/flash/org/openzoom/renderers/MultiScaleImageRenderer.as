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

import org.openzoom.core.IViewport;
import org.openzoom.core.IZoomable;
import org.openzoom.descriptors.IMultiScaleImageDescriptor;
import org.openzoom.descriptors.IMultiScaleImageLevel;
import org.openzoom.events.ViewportEvent;

/**
 * Generic renderer for multi-scale images.
 */
public class MultiScaleImageRenderer extends Sprite implements IZoomable
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------
    
    private static const TILE_LOADER_NAME : String = "tileLoader"
    private static const BACKGROUND_LOADER_NAME : String = "backgroundLoader"
    
    // FIXME
    private static const EXTRA_TILES : uint = 4
    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     * Constructor.
     */
    public function MultiScaleImageRenderer( descriptor : IMultiScaleImageDescriptor )
    {
        this.descriptor = descriptor
        
        explicitWidth = descriptor.width
        explicitHeight = descriptor.height
        
        createChildren()
        createLoader()
        
        // FIXME
//        if( descriptor.tileOverlap == 0 ) 
            loadBackground()
    }
    
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    private var explicitWidth : Number
    private var explicitHeight : Number
    
    private var descriptor : IMultiScaleImageDescriptor
    private var tileLoader : BulkLoader
    private var backgroundLoader : BulkLoader

    private var frame : Shape
    
    private var backgroundTile : Bitmap
    private var backgroundLayer : TileLayer
    private var foregroundLayer : TileLayer
    
    private var debugLayer : Shape
    
    //--------------------------------------------------------------------------
    //
    //  Properties: IZoomable
    //
    //--------------------------------------------------------------------------
    
    private var _viewport : IViewport
    
    public function get viewport() : IViewport
    {
        return _viewport
    }
    
    public function set viewport( value : IViewport ) : void
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
    
    private function createChildren() : void
    {   
        frame = createFrame( explicitWidth, explicitHeight )
        addChild( frame )

        
        backgroundLayer = new TileLayer( descriptor.clone() )
        addChild( backgroundLayer )
        
        foregroundLayer = new TileLayer( descriptor.clone() )
        addChild( foregroundLayer )
        
        
        debugLayer = new Shape()
        debugLayer.visible = false
        addChild( debugLayer )
    }
    
    private function createFrame( width : Number, height : Number ) : Shape
    {
        var background : Shape = new Shape()
        var g : Graphics = background.graphics
        g.beginFill( 0x000000, 0 )
        g.drawRect( 0, 0, width, height )
        g.endFill()
        
        return background
    }
    
    private function createLoader() : void
    {       
        tileLoader = new BulkLoader( TILE_LOADER_NAME )
        backgroundLoader = new BulkLoader( BACKGROUND_LOADER_NAME )
    }
    
    private function loadBackground() : void
    {
        var level : int = getHighestSingleTileLevel()
        
        backgroundLoader.add( descriptor.getTileURL( level, 0, 0 ), { id: "background" } )
                        .addEventListener( Event.COMPLETE, backgroundCompleteHandler )
        backgroundLoader.start()
    } 
    
    private function updateDisplayList() : void
    {
        // FIXME        
        var bounds : Rectangle = new Rectangle( 0, 0, unscaledWidth, unscaledHeight )
        var visibleArea : Rectangle = viewport.intersection( bounds )
        
        var level : IMultiScaleImageLevel = descriptor.getMinimumLevelForSize( width, height )
        
        if( foregroundLayer.level && foregroundLayer.level.index != level.index )
        {
            foregroundLayer.removeAllTiles()
            tileLoader.removeAll()
        }
         
        foregroundLayer.level = level
        
        foregroundLayer.width = explicitWidth
        foregroundLayer.height = explicitHeight
        
        loadTiles( level, visibleArea )
        
        drawVisibleArea( visibleArea )
    }
    
    private function drawVisibleArea( area : Rectangle ) : void
    {
        debugLayer.x = area.x
        debugLayer.y = area.y
        
        // move debug layer to front
        setChildIndex( debugLayer, numChildren - 1 )
        
        var g : Graphics = debugLayer.graphics
            g.clear()
            g.lineStyle( 0, 0xFF0000 )
            g.beginFill( 0xFF0000, 0.2 )
            g.drawRect( 0, 0, area.width, area.height )
            g.endFill()
    }
    
    private function loadTiles( level : IMultiScaleImageLevel, area : Rectangle ) : void
    {
        var minColumn : int = Math.max( 0, Math.floor( ( area.left / width  * level.numColumns ) ) - EXTRA_TILES )
        var maxColumn : int = Math.min( level.numColumns, Math.ceil( ( area.right / width  * level.numColumns ) ) + EXTRA_TILES )
        var minRow    : int = Math.max( 0, Math.floor( ( area.top / height * level.numRows ) ) - EXTRA_TILES )
        var maxRow    : int = Math.min( level.numRows, Math.ceil( ( area.bottom / height * level.numRows ) ) + EXTRA_TILES )

        for( var column : int = minColumn; column < maxColumn; column++ )
        {
            for( var row : int = minRow; row < maxRow; row++ ) 
            {
                var tile : Tile = new Tile( null, level.index, row, column, descriptor.tileOverlap )
                
                if( foregroundLayer.containsTile( tile ) )
                   continue
                
                var url : String = descriptor.getTileURL( tile.level, tile.column, tile.row )
                tileLoader.add( url, { type: "image", data: tile /*, id: tile.hashCode.toString() */ } )
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
//         tile.bitmap = tileLoader.getBitmap( tile.hashCode.toString(), true )
        
        foregroundLayer.addTile( tile )
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
    
    private function getHighestSingleTileLevel() : int
    {
        var i : int = 0
        var level : IMultiScaleImageLevel

        do        
        {
            level = descriptor.getLevelAt( i )
            i++
        }
        while( level.numColumns == 1 && level.numRows == 1 )
        
        return level.index - 1
    }
}

}