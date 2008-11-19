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
import flash.events.KeyboardEvent;
import flash.events.TimerEvent;
import flash.ui.Keyboard;
import flash.utils.Timer;

import org.openzoom.core.ViewportControllerBase;

/**
 * Viewport controller for keyboard navigation.
 */
public class KeyboardNavigationController extends ViewportControllerBase
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------
   
    private static const KEYBOARD_REFRESH_DELAY : Number = 60 // milliseconds
   
    private static const ZOOM_IN_FACTOR         : Number = 2.0
    private static const ZOOM_OUT_FACTOR        : Number = 0.3
    private static const ACCELERATION_FACTOR    : Number = 15
    private static const TRANSLATION_FACTOR     : Number = 0.05
   
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
   
    /**
     * Constructor.
     */
    public function KeyboardNavigationController()
    {
    }
   
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
   
    private var keyboardTimer : Timer
   
    private var accelerationActivated : Boolean
   
    private var upActivated : Boolean
    private var downActivated : Boolean
    private var leftActivated : Boolean
    private var rightActivated : Boolean
   
    private var pageUpActivated : Boolean
    private var pageDownActivated : Boolean
    private var homeActivated : Boolean
    private var endActivated : Boolean
    private var spaceActivated : Boolean
   
    private var zoomInActivated : Boolean
    private var zoomOutActivated : Boolean
   
    //--------------------------------------------------------------------------
    //
    //  Overridden methods: AbstractViewportController
    //
    //--------------------------------------------------------------------------
   
    override protected function view_addedToStageHandler( event : Event ) : void
    {
        if( !keyboardTimer )
            keyboardTimer = new Timer( KEYBOARD_REFRESH_DELAY )
     
        keyboardTimer.start()
        keyboardTimer.addEventListener( TimerEvent.TIMER, keyboardTimerHandler, false, 0, true )
     
        view.stage.addEventListener( KeyboardEvent.KEY_DOWN, keyDownHandler, false, 0, true )
        view.stage.addEventListener( KeyboardEvent.KEY_UP, keyUpHandler, false, 0, true )
   }
   
   override protected function view_removedFromStageHandler( event : Event ) : void
   {
        keyboardTimer.removeEventListener( TimerEvent.TIMER, keyboardTimerHandler )
        keyboardTimer.stop()
        keyboardTimer = null
     
        view.stage.removeEventListener( KeyboardEvent.KEY_DOWN, keyDownHandler )
        view.stage.removeEventListener( KeyboardEvent.KEY_UP, keyUpHandler )
   }
   
   //--------------------------------------------------------------------------
   //
   //  Event handlers: Keyboard
   //
   //--------------------------------------------------------------------------
   
    private function keyDownHandler( event : KeyboardEvent ) : void
    {
        updateFlags( event, true )
    }
   
    private function keyUpHandler( event : KeyboardEvent ) : void
    {
        updateFlags( event, false )
    }
   
    private function updateFlags( event : KeyboardEvent,
                                  value : Boolean = true ) : void
    {
        switch( event.keyCode )
        { 
            // booster
            case Keyboard.SHIFT:
                accelerationActivated = value
                break
               
            // panning
            case Keyboard.UP:
            case 87: // W
                upActivated = value
                break
               
            case Keyboard.DOWN:
            case 83: // S
                downActivated = value
                break
               
            case Keyboard.LEFT:
            case 65: // A
                leftActivated = value
                break
               
            case Keyboard.RIGHT:
            case 68: // D
                rightActivated = value
                break
               
            // quick navigation    
            case Keyboard.PAGE_UP:
                pageUpActivated = value
                break
               
            case Keyboard.PAGE_DOWN:
                pageDownActivated = value
                break
               
            case Keyboard.HOME:
                homeActivated = value
                break
               
            case Keyboard.END:
                endActivated = value
                break
               
            case Keyboard.SPACE:
                spaceActivated = value
                break
               
            // zooming
            case Keyboard.NUMPAD_ADD:
            case 73: // I
                zoomInActivated = value
                break
               
            case Keyboard.NUMPAD_SUBTRACT:
            case 79: // O
                zoomOutActivated = value
                break
        }
    }
       
    private function keyboardTimerHandler( event : TimerEvent ) : void
    {
        var dx : Number = viewport.width * TRANSLATION_FACTOR
        var dy : Number = viewport.height * TRANSLATION_FACTOR
         
        if( accelerationActivated )
        {
            dx *= ACCELERATION_FACTOR
            dy *= ACCELERATION_FACTOR
        }
         
        // panning
        if( upActivated )
            viewport.moveBy( 0, -dy )
         
        if( downActivated )
            viewport.moveBy( 0, dy )
         
        if( leftActivated )
            viewport.moveBy( -dx, 0 )
         
        if( rightActivated )
            viewport.moveBy( dx, 0 )
         
        // quick navigation
        if( pageUpActivated )
            viewport.moveTo( viewport.x, 0 )
         
        if( pageDownActivated )
            viewport.moveTo( viewport.x, 1 )
         
        if( homeActivated )
            viewport.moveTo( 0, viewport.y )
         
        if( endActivated )
            viewport.moveTo( 1, viewport.y )
         
        if( spaceActivated )
            viewport.showAll()
         
        // zooming
        if( zoomInActivated )
            viewport.zoomBy( ZOOM_IN_FACTOR )
         
        if( zoomOutActivated )
            viewport.zoomBy( ZOOM_OUT_FACTOR )
    }    
}

}