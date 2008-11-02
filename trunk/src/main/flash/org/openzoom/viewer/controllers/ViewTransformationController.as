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

import caurina.transitions.Tweener;

import flash.display.DisplayObject;
import flash.events.Event;

import org.openzoom.core.INormalizedViewport;
import org.openzoom.core.ViewportControllerBase;
import org.openzoom.events.ViewportEvent;    

/**
 * Transforms the view in the viewport.
 */
public class ViewTransformationController extends ViewportControllerBase
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------
    
    private static const CRITICAL_DIMENSION : Number = 3000000
    
    private static const DEFAULT_TRANSFORMATION_DURATION : Number = 2.0
    private static const DEFAULT_TRANSFORMATION_EASING : String = "easeOutExpo"
    
    private static const FALLBACK_TRANSFORMATION_DURATION : Number = 0.2
    private static const FALLBACK_TRANSFORMATION_EASING : String = "linear"
    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     * Constructor.
     */ 
    public function ViewTransformationController()
    {
    }
      
    //--------------------------------------------------------------------------
    //
    //  Overridden properties: ViewportControllerBase
    //
    //--------------------------------------------------------------------------

    override public function set viewport( value : INormalizedViewport ) : void
    {
        if( viewport === value )
            return
    
        // remove old event listeners
        if( viewport ) 
        {
            viewport.removeEventListener( ViewportEvent.CHANGE, viewport_changeHandler );
            viewport.removeEventListener( ViewportEvent.RESIZE, viewport_resizeHandler );
        }
        
        // set new viewport
        super.viewport = value  
        
        // register new event listeners
        if( viewport )
        {
            viewport.addEventListener( ViewportEvent.CHANGE, viewport_changeHandler, false, 0, true );
            viewport.addEventListener( ViewportEvent.RESIZE, viewport_resizeHandler, false, 0, true );
        }
    }
    
    override public function set view( value : DisplayObject ) : void
    {
        super.view = value
        transformView( 0 )
    }
    
    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

    private function viewport_changeHandler( event : ViewportEvent ) : void
    {
        transformView( DEFAULT_TRANSFORMATION_DURATION )
    }
    
    private function viewport_resizeHandler( event : ViewportEvent ) : void
    {
        transformView( 0 )    
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Internal
    //
    //--------------------------------------------------------------------------
    
    private function transformView( duration : Number ) : void
    {
        var transition : String = DEFAULT_TRANSFORMATION_EASING
        var newWidth  : Number = viewport.bounds.width  / viewport.normalizedWidth
        var newHeight : Number = viewport.bounds.height / viewport.normalizedHeight
        var newX      : Number = -viewport.normalizedX * newWidth
        var newY      : Number = -viewport.normalizedY * newHeight
        
        // FIXME
//        if( duration != 0 && ( newWidth > CRITICAL_DIMENSION || newHeight > CRITICAL_DIMENSION ))
//        {
//          duration = FALLBACK_TRANSFORMATION_DURATION
//          transition = FALLBACK_TRANSFORMATION_EASING
//        }
        
        Tweener.addTween(
                            view,
                            {
                                x: newX,
                                y: newY,
                                width: newWidth,
                                height: newHeight,
                                time: duration,
                                transition: transition,
                                onComplete: viewport.dispatchChangeCompleteEvent
                            }
                        )
    }
    
    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------
    
    private function transformation_completeHandler( event : Event ) : void
    {
        viewport.dispatchChangeCompleteEvent()
    }
}

}