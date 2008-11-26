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
package org.openzoom.flash.renderers.images
{

import caurina.transitions.Tweener;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.geom.Point;
import flash.utils.Dictionary;

import org.openzoom.flash.descriptors.IMultiScaleImageLevel;

/**
 * Layer for holding tiles.
 */
public class TileLayer extends Sprite implements ITileLayer
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------
    
    private static const DEFAULT_TILE_SHOW_DURATION : Number = 2.5
    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
  
    /**
     * Constructor.
     */
    public function TileLayer( width : Number, height : Number,
                               level : IMultiScaleImageLevel )
    {
        _level = level
        // FIXME
//        scaleXFactor = width  / level.width
//        scaleYFactor = height / level.height
        createFrame( width, height )
    }
    
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    // TODO: Consider using Sprite because of event propagation.
    private var frame : Shape
    private var data : IMultiScaleImageLevel
    private var scaleXFactor : Number = 1
    private var scaleYFactor : Number = 1
    
    private var tiles : Dictionary = new Dictionary( true )
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    private var _level : IMultiScaleImageLevel
    
    public function get level() : IMultiScaleImageLevel
    {
        return _level
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    public function containsTile( tile : Tile ) : Boolean
    {
        return tiles[ tile.hashCode ]
    }
    
    public function addTile( tile : Tile ) : Tile
    {
        if( tile.level != level.index )
        {
            trace( "[TileLayer]: Adding Tile from wrong level." )
            return null
        }
        
//        trace( level.index, level.width, level.height )
        
        // return if tile already added
        if( tiles[ tile.hashCode ] )
           return null
        
        // store reference to tile
        tiles[ tile.hashCode ] = tile
        
        // add tile
        var tileBitmap : Bitmap = tile.bitmap 

        var position : Point = level.getTilePosition( tile.column, tile.row )
        
        tileBitmap.scaleX = scaleXFactor
        tileBitmap.scaleY = scaleYFactor
        
        tileBitmap.x = position.x * scaleXFactor
        tileBitmap.y = position.y * scaleYFactor
        
        var tileBitmapRight : Number = tileBitmap.x + tileBitmap.width
        var tileBitmapBottom : Number = tileBitmap.y + tileBitmap.height
        var horizontalOverflow : Boolean = tileBitmapRight > level.width 
        var verticalOverflow : Boolean = tileBitmapBottom > level.height
        
        if( tileBitmap.x >= level.width || tileBitmap.y >= level.height )
            trace( "[TileLayer]: Wrong tile positioning" )

            
        // Fix for too large tiles
        if( horizontalOverflow || verticalOverflow )
        {
        	var cropBitmapData : BitmapData =
        	       new BitmapData( Math.min( level.width  - tileBitmap.x, tileBitmap.width ),
        	                       Math.min( level.height - tileBitmap.y, tileBitmap.height ))
        	cropBitmapData.copyPixels( tileBitmap.bitmapData, cropBitmapData.rect, new Point( 0, 0 ))
        	var croppedTileBitmap : Bitmap = new Bitmap( cropBitmapData )
        	croppedTileBitmap.x = tileBitmap.x
        	croppedTileBitmap.y = tileBitmap.y
        	croppedTileBitmap.scaleX = tileBitmap.scaleX
        	croppedTileBitmap.scaleY = tileBitmap.scaleY
        	tileBitmap = croppedTileBitmap
        }
        
        if( tileBitmap.x + tileBitmap.width > level.width || tileBitmap.y + tileBitmap.height > level.height )
            trace( "[TileLayer]: Bad cropping" )
        
        tileBitmap.smoothing = true
        tileBitmap.alpha = 0
    
        addChild( tileBitmap )
        
//        tileBitmap.alpha = 1
        Tweener.addTween( tileBitmap, { alpha: 1, time: DEFAULT_TILE_SHOW_DURATION } )
        
        return tile
    }
    
    public function removeAllTiles() : void
    {
        // Keep Frame
        while( numChildren > 1 )
          removeChildAt( 1 )
          
        tiles = new Dictionary( true )
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
        // DEBUG
//        g.lineStyle( 0, 0xFF0000 )
//        g.beginFill( Math.random() * 0xFFFFFF, 0.05 )
        g.beginFill( 0x000000, 0 )
        g.drawRect( 0, 0, width, height )
        g.endFill()
        
        addChild( frame )
    }
}

}