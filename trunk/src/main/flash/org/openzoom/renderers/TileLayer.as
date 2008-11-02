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

import caurina.transitions.Tweener;

import flash.display.Bitmap;
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.geom.Point;
import flash.utils.Dictionary;

import org.openzoom.descriptors.IMultiScaleImageLevel;

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
    
    private static const DEFAULT_TILE_SHOW_DURATION : Number = 2.0
    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
  
    /**
     * Constructor.
     */
    public function TileLayer( width : Number, height : Number, level : IMultiScaleImageLevel )
    {
        _level = level
        scaleXFactor = width  / level.width
        scaleYFactor = height / level.height
        frame = createFrame( width, height )
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
        
    
        tileBitmap.smoothing = true
        tileBitmap.alpha = 0
    
        addChild( tileBitmap )
        
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
    
    private function createFrame( width : Number, height : Number ) : Shape
    {
        var background : Shape = new Shape()
        var g : Graphics = background.graphics
//        g.lineStyle( 0, 0xFF0000 )
//        g.beginFill( Math.random() * 0xFFFFFF, 0.05 )
        g.beginFill( 0x000000, 0 )
        g.drawRect( 0, 0, width, height )
        g.endFill()
        
        addChild( background )
        
        return background
    }
}

}