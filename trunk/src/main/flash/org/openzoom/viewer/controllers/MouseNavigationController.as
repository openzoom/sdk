////////////////////////////////////////////////////////////////////////////////
//
//  OpenZoom
//
//  Copyright (c) 2007–2008, Daniel Gasienica <daniel@gasienica.ch>
//  Copyright (c) 2008,      Zoomorama
//                           Olivier Gambier <viapanda@gmail.com>
//                           Daniel Gasienica <daniel@gasienica.ch>
//                           Eric Hubscher <erich@zoomorama.com>
//                           David Marteau <dhmarteau@gmail.com>
//  Copyright (c) 2007,      Rick Companje <rick@companje.nl>
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
package org.openzoom.viewer.controllers
{

import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.utils.Timer;

import org.openzoom.core.ViewportControllerBase;

/**
 * Viewport controller for mouse navigation.
 */
public class MouseNavigationController extends ViewportControllerBase
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------
    
    private static const CLICK_THRESHOLD_DURATION : Number = 500 // milliseconds
    private static const CLICK_THRESHOLD_DISTANCE : Number = 8   // pixels
    
    private static const ZOOM_IN_FACTOR           : Number = 2.0
    private static const ZOOM_OUT_FACTOR          : Number = 0.3
    
    private static const MOUSE_WHEEL_STEP_FACTOR  : Number = 20
    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Constructor.
     */ 
    public function MouseNavigationController()
    {
        createClickTimer()
    }
    
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var clickTimer : Timer
    private var click : Boolean = false
    private var mouseDownPosition : Point
    
    private var viewDragVector : Rectangle = new Rectangle()
    private var viewportDragVector : Rectangle = new Rectangle()
    private var panning : Boolean = false
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    private function createClickTimer() : void
    {
        clickTimer = new Timer( CLICK_THRESHOLD_DURATION, 1 )
        clickTimer.addEventListener( TimerEvent.TIMER_COMPLETE, clickTimer_completeHandler )
    }
    //--------------------------------------------------------------------------
    //
    //  Overridden methods: AbstractViewportController
    //
    //--------------------------------------------------------------------------
      
    override protected function view_addedToStageHandler( event : Event ) : void
    {    
        // panning listeners
        view.addEventListener( MouseEvent.MOUSE_DOWN, view_mouseDownHandler, false, 0, true )
        view.addEventListener( MouseEvent.ROLL_OUT, view_rollOutHandler, false, 0, true )
        view.stage.addEventListener( Event.MOUSE_LEAVE, stage_mouseLeaveHandler, false, 0, true )
      
        // zooming listeners
        view.addEventListener( MouseEvent.MOUSE_WHEEL, view_mouseWheelHandler, false, 0, true )    
    }
    
    override protected function view_removedFromStageHandler( event : Event ) : void
    {    
        // panning listeners
        view.removeEventListener( MouseEvent.MOUSE_DOWN, view_mouseDownHandler )
        view.removeEventListener( MouseEvent.ROLL_OUT, view_rollOutHandler )
        view.removeEventListener( Event.MOUSE_LEAVE, stage_mouseLeaveHandler )
      
        // zooming listeners
        view.removeEventListener( MouseEvent.MOUSE_WHEEL, view_mouseWheelHandler )    
    }
    
    //--------------------------------------------------------------------------
    //
    //  Event Handlers: Zooming
    //
    //--------------------------------------------------------------------------

    private function view_mouseWheelHandler( event : MouseEvent ) : void
    {
        // TODO: React appropriately to different platforms and/or browsers,
        // as they at times report completely different mouse wheel deltas. 
        var factor : Number = 1 + event.delta / MOUSE_WHEEL_STEP_FACTOR
    
        // compute normalized origin of mouse relative to viewport.
        var originX : Number = view.mouseX / view.width
        var originY : Number = view.mouseY / view.height
    
        // transform viewport
        viewport.normalizedZoomBy( factor, originX, originY )
    }
    
    //--------------------------------------------------------------------------
    //
    //  Event Handlers: Panning
    //
    //--------------------------------------------------------------------------
    
    private function clickTimer_completeHandler( event : TimerEvent ) : void
    {
        click = false
        clickTimer.reset()
    }
        
    private function view_mouseDownHandler( event : MouseEvent ) : void
    { 
        view.addEventListener( MouseEvent.MOUSE_UP, view_mouseUpHandler, false, 0, true )
        
        // remember mouse position
        mouseDownPosition = new Point( view.mouseX, view.mouseY )
        
        // assume mouse down is a click
        click = true
        
        // start click timer
        clickTimer.reset()
        clickTimer.start()
         
        // register where we are in the view as well as in the viewport
        viewDragVector.topLeft = new Point( view.mouseX, view.mouseY )
        viewportDragVector.topLeft = new Point( viewport.normalizedX, viewport.normalizedY )
        
        beginPanning()
    }
    
    private function view_mouseMoveHandler( event : MouseEvent ) : void
    {     
        if( !panning )
           return
   
        // update view drag vector
        viewDragVector.bottomRight = new Point( view.mouseX, view.mouseY )
        
        viewport.normalizedMoveTo(
            viewportDragVector.x - ( viewDragVector.width / viewport.bounds.width )
              * viewport.normalizedWidth,
          viewportDragVector.y - ( viewDragVector.height / viewport.bounds.height )
              * viewport.normalizedHeight )
    }
    
    private function view_mouseUpHandler( event : MouseEvent ) : void
    {
        view.removeEventListener( MouseEvent.MOUSE_UP, view_mouseUpHandler )
        
        var mouseUpPosition : Point = new Point( view.mouseX, view.mouseY )
        var dx : Number = mouseUpPosition.x - mouseDownPosition.x
        var dy : Number = mouseUpPosition.y - mouseDownPosition.y
        
        var distance : Number = Math.sqrt( dx * dx + dy * dy ) 
        
        if( click && distance < CLICK_THRESHOLD_DISTANCE )
        {
            var factor : Number
            
            if( event.shiftKey || event.ctrlKey )
                factor = ZOOM_OUT_FACTOR
            else
                factor = ZOOM_IN_FACTOR
            
            viewport.normalizedZoomBy( factor,
                                       view.mouseX / view.width,
                                       view.mouseY / view.height )
        }
        
        click = false
        clickTimer.reset()
        
        stopPanning()
    }
    
    private function beginPanning() : void
    {
        // begin panning
        panning = true
      
        // register for mouse move events
        view.addEventListener( MouseEvent.MOUSE_MOVE, view_mouseMoveHandler, false, 0, true )
    }
    
    private function stopPanning() : void
    {    
        // unregister from mouse move events
        if( view.hasEventListener( MouseEvent.MOUSE_MOVE ) )
            view.removeEventListener( MouseEvent.MOUSE_MOVE, view_mouseMoveHandler )
      
        panning = false
    }
    
    private function stage_mouseLeaveHandler( event : Event ) : void
    {
        stopPanning()
    }
    
    private function view_rollOutHandler( event : MouseEvent ) : void
    {
        stopPanning()
    }
}

}