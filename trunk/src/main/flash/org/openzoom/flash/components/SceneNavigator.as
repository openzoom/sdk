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
package org.openzoom.flash.components
{

import flash.display.Graphics;
import flash.display.LineScaleMode;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Rectangle;

import org.openzoom.flash.events.ViewportEvent;
import org.openzoom.flash.utils.math.clamp;
import org.openzoom.flash.viewport.INormalizedViewport;

/**
 * Component for quickly navigating a multi-scale scene.
 */
public class SceneNavigator extends Sprite
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    private static const DEFAULT_DIMENSION    : Number = 150
    private static const DEFAULT_WINDOW_COLOR : uint   = 0x0088FF
  
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
  
    /**
     *  Constructor.
     */
    public function SceneNavigator() : void
    {
        addEventListener( Event.ADDED_TO_STAGE, addedToStageHandler )
    
        createBackground()
        createWindow()
    }
  
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
  
    private var background       : Sprite
    private var backgroundWidth  : Number
    private var backgroundHeight : Number
  
    private var window : Sprite
  
    private var oldMouseX : Number
    private var oldMouseY : Number
    
    private var panning : Boolean = false
  
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    private var _viewport : INormalizedViewport
  
    public function get viewport() : INormalizedViewport
    {
        return _viewport
    }
  
    public function set viewport( value : INormalizedViewport ) : void
    {
        if( value === viewport )
            return
    
        _viewport = value
    
        if( viewport )
        {
            viewport.addEventListener( ViewportEvent.TRANSFORM_UPDATE,
                                       viewport_transformUpdateHandler,
                                       false, 0, true )
            viewport.addEventListener( ViewportEvent.RESIZE,
                                       viewport_resizeHandler,
                                       false, 0, true )
            viewport_transformUpdateHandler( null )
      
            // resize background
            var aspectRatio : Number =
                    viewport.scene.sceneWidth / viewport.scene.sceneHeight
      
            background.width  = Math.min( DEFAULT_DIMENSION, DEFAULT_DIMENSION * aspectRatio )
            background.height = Math.min( DEFAULT_DIMENSION, DEFAULT_DIMENSION / aspectRatio )
    
            var backgroundBounds : Rectangle = background.getRect( this )
            backgroundWidth = backgroundBounds.width
            backgroundHeight = backgroundBounds.height
      
            transformWindow()   
        }
        else
        {
            viewport.removeEventListener( ViewportEvent.TRANSFORM_UPDATE,
                                          viewport_transformUpdateHandler )
            viewport.removeEventListener( ViewportEvent.RESIZE,
                                          viewport_resizeHandler )      
        }
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods: Children
    //
    //--------------------------------------------------------------------------

    private function createBackground() : void
    {
        background = new Sprite()
    
        var g : Graphics = background.graphics
            g.lineStyle( 1.0, 0x000000, 0.8, false, LineScaleMode.NONE )
            g.beginFill( 0xEFEFEF, 0.1 )
            g.drawRect( 0, 0, DEFAULT_DIMENSION, DEFAULT_DIMENSION )
            g.endFill()
    
            background.buttonMode = true
            background.addEventListener( MouseEvent.CLICK,
                                         background_clickHandler )
    
        addChildAt( background, 0 )
    }

    private function createWindow() : void
    {
        window = new Sprite()
    
        var g : Graphics = window.graphics
            g.beginFill( DEFAULT_WINDOW_COLOR, 0.3 )
            g.drawRect( 0, 0, DEFAULT_DIMENSION, DEFAULT_DIMENSION )
            g.endFill()
    
            window.buttonMode = true
            window.addEventListener( MouseEvent.MOUSE_DOWN, window_mouseDownHandler )
    
            addChild( window )
    }
  
    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------
  
    private function addedToStageHandler( event : Event ) : void
    {
        stage.addEventListener( Event.MOUSE_LEAVE,
                                stage_mouseLeaveHandler,
                                false, 0, true )
        stage.addEventListener( MouseEvent.MOUSE_UP,
                                stage_mouseLeaveHandler,
                                false, 0, true )
    }
       
    private function viewport_transformUpdateHandler( event : ViewportEvent ) : void
    {
    	if( panning )
    	   return
    	   
        transformWindow()
    }

    private function viewport_resizeHandler( event : ViewportEvent ) : void
    {
        transformWindow()
    }
  
    private function window_mouseDownHandler( event : MouseEvent ) : void
    {
        oldMouseX = stage.mouseX
        oldMouseY = stage.mouseY
    
        stage.addEventListener( MouseEvent.MOUSE_MOVE,
                                stage_mouseMoveHandler )
        panning = true
    }
  
    private function stage_mouseMoveHandler( event : MouseEvent ) : void
    {    
        var dx : Number = stage.mouseX - oldMouseX
        var dy : Number = stage.mouseY - oldMouseY
    
        var targetX : Number = window.x + dx
        var targetY : Number = window.y + dy

        var windowBounds : Rectangle = window.getBounds( this )
        var windowWidth  : Number    = windowBounds.width
        var windowHeight : Number    = windowBounds.height
    
        if( targetX < 0 )
            targetX = 0
      
        if( targetY < 0 )
            targetY = 0
    
        if( windowBounds.right > backgroundWidth )
            targetX = backgroundWidth - windowWidth
      
        if( windowBounds.bottom > backgroundHeight )
            targetY = backgroundHeight - windowHeight
      
        window.x = targetX
        window.y = targetY
    
        oldMouseX = stage.mouseX
        oldMouseY = stage.mouseY
    
        viewport.moveTo( clamp( window.x, 0, backgroundWidth ) / backgroundWidth,
                         clamp( window.y, 0, backgroundHeight ) / backgroundHeight )
    }
  
    private function stage_mouseUpHandler( event : MouseEvent ) : void
    {   
        stage.removeEventListener( MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler )
        panning = false
    }
  
    private function background_clickHandler( event : MouseEvent ) : void
    {
        var transformX : Number = ( background.scaleX * background.mouseX )
                                    / backgroundWidth
        var transformY : Number = ( background.scaleY * background.mouseY )
                                    / backgroundHeight
    
        viewport.moveCenterTo( transformX, transformY )
    }
  
    private function stage_mouseLeaveHandler( event : Event ) : void
    {
        stage_mouseUpHandler( null ) 
    }
  
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
  
    private function transformWindow() : void
    {
    	// compute bounds
    	var v : INormalizedViewport = viewport
        var targetX : Number      = clamp( v.x, 0, 1 - v.width ) * backgroundWidth
        var targetY : Number      = clamp( v.y, 0, 1 - v.height ) * backgroundHeight
        var targetWidth : Number  = clamp( v.width ) * backgroundWidth
        var targetHeight : Number = clamp( v.height ) * backgroundHeight
    
        // enable / disable window dragging
        if( viewport.transformer.target.width >= 1
            && viewport.transformer.target.height >= 1 )
            window.mouseEnabled = false
        else
            window.mouseEnabled = true
    
        // transform
        window.x = targetX
        window.y = targetY
        window.width = targetWidth
        window.height = targetHeight
  }
}

}