////////////////////////////////////////////////////////////////////////////////
//
//  OpenZoom
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
package org.openzoom.core
{

import flash.events.Event;
import flash.geom.Point;
import flash.geom.Rectangle;

import org.openzoom.events.ViewportEvent;
import org.openzoom.utils.math.clamp;

public class ViewportTransform implements IViewportTransform
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function ViewportTransform( viewport : IReadonlyViewport, scene : IReadonlyMultiScaleScene )
    {
        this.viewport = viewport
        this.viewport.addEventListener( ViewportEvent.RESIZE, viewport_resizeHandler, false, 0, true )
        
        this.scene = scene
        this.scene.addEventListener( Event.RESIZE, scene_resizeHandler, false, 0, true )
        
        validate()
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    private var viewport : IReadonlyViewport
    private var scene : IReadonlyMultiScaleScene
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  zoom
    //----------------------------------

    private var _zoom : Number = 1;

    public function get zoom() : Number
    {
        return _zoom
    }

    public function set zoom( value : Number ) : void
    {
        zoomTo( value )
    }

    //----------------------------------
    //  scale
    //----------------------------------

    public function get scale() : Number
    {
        return viewportWidth / ( scene.sceneWidth * width ) 
    }


    //--------------------------------------------------------------------------
    //
    //  Methods: Zooming
    //
    //--------------------------------------------------------------------------

    public function zoomTo( zoom : Number,
                            transformX : Number = 0.5,
                            transformY : Number = 0.5 ) : void
    {
        // keep z within min/max range
        _zoom = clamp( zoom, viewport.minZoom, viewport.maxZoom )

        // remember old origin
        var oldOrigin : Point = getViewportOrigin( transformX, transformY )

        // Compute normalized dimensions aspect ratio
        // This is ratio of the normalized content width and height 
        var ratio : Number = sceneAspectRatio / aspectRatio

        if( ratio >= 1 )
        {
            // content is wider than viewport
            _width = 1 / _zoom
            _height  = _width * ratio
        }
        else
        {
            // content is taller than viewport
            _height = 1 / _zoom
            _width  = _height / ratio
        }

        // move new origin to old origin
        moveOriginTo( oldOrigin.x, oldOrigin.y, transformX, transformY )
    }

    public function zoomBy( factor : Number,
                            transformX : Number = 0.5,
                            transformY : Number = 0.5 ) : void
    {
        zoomTo( zoom * factor, transformX, transformY )
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Panning
    //
    //--------------------------------------------------------------------------

    public function moveTo( x : Number, y : Number ) : void
    {
        _x = x
        _y = y
    }


    public function moveBy( dx : Number, dy : Number ) : void
    {
        moveTo( x + dx, y + dy )
    }

    public function moveCenterTo( x : Number, y : Number ) : void
    {
        moveOriginTo( x, y, 0.5, 0.5 )
    }

    public function showRect( rect : Rectangle, scale : Number = 1.0 ) : void
    {
    	// TODO: Implement for normalized coordinate system
    	var area : Rectangle = denormalizeRectangle( rect )
    	
        var centerX : Number = area.x + area.width  * 0.5
        var centerY : Number = area.y + area.height * 0.5
    
        var normalizedCenter : Point = new Point( centerX / scene.sceneWidth,
                                                  centerY / scene.sceneHeight )
                                                 
        var scaledWidth : Number = area.width / scale
        var scaledHeight : Number = area.height / scale
    
        var ratio : Number = sceneAspectRatio / aspectRatio
     
        // We have be careful here, the way the zoom factor is
        // interpreted depends on the relative ratio of scene and viewport
        if( scaledWidth > ( aspectRatio * scaledHeight ) )
        {
            // Area must fit horizontally in the viewport
            ratio = ( ratio < 1 ) ? ( scene.sceneWidth / ratio ) : scene.sceneWidth
            ratio = ratio / scaledWidth
        }
        else
        {
            // Area must fit vertically in the viewport  
            ratio = ( ratio > 1 ) ? ( scene.sceneHeight * ratio ) : scene.sceneHeight
            ratio = ratio / scaledHeight
        }
    
        var oldZoom : Number = zoom
    
        zoomTo( ratio, 0.5, 0.5 )
        moveCenterTo( normalizedCenter.x, normalizedCenter.y )
    }
    
    public function showAll() : void
    {
    	var area : Rectangle = new Rectangle( 0, 0, scene.sceneWidth, scene.sceneHeight )
        showRect( normalizeRectangle( area ))
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Coordinate transformations
    //
    //--------------------------------------------------------------------------

    public function localToScene( point : Point ) : Point
    {
        var p : Point = new Point()
        p.x = ( x * scene.sceneWidth ) 
              + ( point.x / viewportWidth )  * ( width  * scene.sceneWidth )
        p.y = ( y * scene.sceneHeight )
              + ( point.y / viewportHeight ) * ( height * scene.sceneHeight )
        return p
    }

    public function sceneToLocal( point : Point ) : Point
    {
        var p : Point = new Point()
        p.x = ( point.x - ( x  * scene.sceneWidth ))
              / ( width  * scene.sceneWidth ) * viewportWidth
        p.y = ( point.y - ( y  * scene.sceneHeight ))
              / ( height * scene.sceneHeight ) * viewportHeight
        return p
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Internal
    //
    //--------------------------------------------------------------------------

    private function moveOriginTo( x : Number, y : Number,
                                   transformX : Number, transformY : Number ) : void
    {
        var newX : Number = x - width * transformX
        var newY : Number = y - height * transformY

        moveTo( newX, newY )
    }

    private function getViewportOrigin( transformX : Number,
                                        transformY : Number ) : Point
    {
        var viewportOriginX : Number = x + width * transformX
        var viewportOriginY : Number = y + height * transformY
 
        return new Point( viewportOriginX, viewportOriginY )
    }

    /**
     * @private
     * 
     * Validate the viewport.
     */ 
    private function validate() : void
    {
        zoomTo( _zoom, 0.5, 0.5 )
    }


    //--------------------------------------------------------------------------
    //
    //  Properties: Internal
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  aspectRatio
    //----------------------------------
    
    /**
     * @private 
     * Returns the aspect ratio of this Viewport object.
     */
    private function get aspectRatio() : Number
    {
        return viewportWidth / viewportHeight
    }
 
    //----------------------------------
    //  sceneAspectRatio
    //----------------------------------
    
    /**
     * @private 
     * Returns the aspect ratio of scene.
     */
    private function get sceneAspectRatio() : Number
    {
        return scene.sceneWidth / scene.sceneHeight
    }
    

    //--------------------------------------------------------------------------
    //
    //  Properties: IViewport
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  x
    //----------------------------------
    
    private var _x : Number = 0
    
    public function get x() : Number
    {
        return _x
    }
    
    public function set x( value : Number ) : void
    {
        moveTo( value, y )
    }
    
    //----------------------------------
    //  y
    //----------------------------------
    
    private var _y : Number = 0
    
    public function get y() : Number
    {
       return _y
    }
    
    public function set y( value : Number ) : void
    {
        moveTo( x, value )
    }
    
    //----------------------------------
    //  width
    //----------------------------------
    
    private var _width : Number = 1;
    
    public function get width() : Number
    {
        return _width
    }
    
    //----------------------------------
    //  height
    //----------------------------------
    
    private var _height : Number = 1;
    
    public function get height() : Number
    {
        return _height
    }
    
    //----------------------------------
    //  left
    //----------------------------------
    
    public function get left() : Number
    {
        return x
    }
    
    //----------------------------------
    //  right
    //----------------------------------
    
    public function get right() : Number
    {
        return x + width
    }
    
    //----------------------------------
    //  top
    //----------------------------------
    
    public function get top() : Number
    {
        return y
    }
    
    //----------------------------------
    //  bottom
    //----------------------------------
    
    public function get bottom() : Number
    {
        return y + height
    }

    
    //----------------------------------
    //  viewportWidth
    //----------------------------------
    
    public function get viewportWidth() : Number
    {
        return viewport.viewportWidth
    }
    
    //----------------------------------
    //  viewportHeight
    //----------------------------------
    
    public function get viewportHeight() : Number
    {
        return viewport.viewportHeight
    }    
    //--------------------------------------------------------------------------
    //
    //  Methods: Coordinate conversion
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private
     */ 
    private function normalizeX( value : Number ) : Number
    {
        return value / scene.sceneWidth
    }

    /**
     * @private
     */
    private function normalizeY( value : Number ) : Number
    {
        return value / scene.sceneHeight
    }
    
    /**
     * @private
     */
    private function normalizeRectangle( value : Rectangle ) : Rectangle
    {
        return new Rectangle( normalizeX( value.x ),
                              normalizeY( value.y ),
                              normalizeX( value.width ),
                              normalizeY( value.height ))
    }
    
    /**
     * @private
     */
    private function normalizePoint( value : Point ) : Point
    {
        return new Point( normalizeX( value.x ),
                          normalizeY( value.y ))
    }
    
    /**
     * @private
     */ 
    private function denormalizeX( value : Number ) : Number
    {
        return value * scene.sceneWidth
    }

    /**
     * @private
     */
    private function denormalizeY( value : Number ) : Number
    {
        return value * scene.sceneHeight
    }
    
    /**
     * @private
     */
    private function denormalizePoint( value : Point ) : Point
    {
        return new Point( denormalizeX( value.x ),
                          denormalizeY( value.y ))
    }
    
    /**
     * @private
     */
    private function denormalizeRectangle( value : Rectangle ) : Rectangle
    {
        return new Rectangle( denormalizeX( value.x ),
                              denormalizeY( value.y ),
                              denormalizeX( value.width ),
                              denormalizeY( value.height ))
    }
    
    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------
    
    private function scene_resizeHandler( event : Event ) : void
    {
    	validate()
    }
    
    private function viewport_resizeHandler( event : ViewportEvent ) : void
    {
    	validate()
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods: Debug
    //
    //--------------------------------------------------------------------------
    
    public function toString() : String
    {
        return "[ViewportTransform]" + "\n"
               + "x=" + x + "\n" 
               + "y=" + y  + "\n"
               + "z=" + zoom + "\n"
               + "w=" + width + "\n"
               + "h=" + height + "\n"
               + "sW=" + scene.sceneWidth + "\n"
               + "sH=" + scene.sceneHeight
    }
    
    public function clone() : IViewportTransform
    {
        var transform : ViewportTransform =
                new ViewportTransform( viewport, scene )
            transform._x = x	
            transform._y = y	
            transform._width = width	
            transform._height = height
            
        return transform	
    }
}

}