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
package org.openzoom.flash.viewport.controllers
{

import caurina.transitions.Tweener;

import flash.display.DisplayObject;

import org.openzoom.flash.events.ViewportEvent;
import org.openzoom.flash.viewport.INormalizedViewport;
import org.openzoom.flash.viewport.ITransformerViewport;
import org.openzoom.flash.viewport.IViewportController;

[ExcludeClass]

/**
 * @private
 * Deprecated.
 * Transforms the scene in the viewport.
 */
public class ViewTransformationController extends ViewportControllerBase
                                          implements IViewportController
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    private static const DEFAULT_TRANSFORMATION_DURATION : Number = 1.5
    private static const DEFAULT_TRANSFORMATION_EASING : String = "easeOutExpo"

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
            viewport.removeEventListener( ViewportEvent.RESIZE,
                                          viewport_resizeHandler )

            viewport.removeEventListener( ViewportEvent.TRANSFORM_START,
                                          viewport_transformStartHandler )
            viewport.removeEventListener( ViewportEvent.TRANSFORM_UPDATE,
                                          viewport_transformUpdateHandler )
            viewport.removeEventListener( ViewportEvent.TRANSFORM_END,
                                          viewport_transformEndHandler )
        }

        // set new viewport
        super.viewport = value

        // register new event listeners
        if( viewport )
        {
            viewport.addEventListener( ViewportEvent.RESIZE,
                                       viewport_resizeHandler, false, 0, true )

            viewport.addEventListener( ViewportEvent.TRANSFORM_START,
                                       viewport_transformStartHandler, false, 0, true )
            viewport.addEventListener( ViewportEvent.TRANSFORM_UPDATE,
                                       viewport_transformUpdateHandler, false, 0, true )
            viewport.addEventListener( ViewportEvent.TRANSFORM_END,
                                       viewport_transformEndHandler, false, 0, true )
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

    private function viewport_transformStartHandler( event : ViewportEvent ) : void
    {
//        trace( "[ViewportTransformationController] ViewportEvent.TRANSFORM_START" )
    }

    private function viewport_transformUpdateHandler( event : ViewportEvent ) : void
    {
//        trace( "[ViewportTransformationController] ViewportEvent.TRANSFORM_UPDATE" )
        transformView( DEFAULT_TRANSFORMATION_DURATION )
    }

    private function viewport_transformEndHandler( event : ViewportEvent ) : void
    {
//        trace( "[ViewportTransformationController] ViewportEvent.TRANSFORM_END" )
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
        var transition   : String = DEFAULT_TRANSFORMATION_EASING
        var targetWidth  : Number = viewport.viewportWidth / viewport.width
        var targetHeight : Number = viewport.viewportHeight / viewport.height
        var targetX      : Number = -viewport.x * targetWidth
        var targetY      : Number = -viewport.y * targetHeight

        if( !Tweener.isTweening( view ))
            ITransformerViewport(viewport).beginTransform()

        Tweener.addTween(
                            view,
                            {
                                x: targetX,
                                y: targetY,
                                width: targetWidth,
                                height: targetHeight,
                                time: duration,
                                transition: transition,
                                onComplete: ITransformerViewport(viewport).endTransform
                            }
                        )
    }
}

}