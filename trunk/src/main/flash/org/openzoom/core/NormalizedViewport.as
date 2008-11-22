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
package org.openzoom.core
{

import flash.display.Sprite;
import flash.events.EventDispatcher;
import flash.geom.Point;
import flash.geom.Rectangle;

import org.openzoom.events.ViewportEvent;
import org.openzoom.utils.math.clamp;

//------------------------------------------------------------------------------
//
//  Events
//
//------------------------------------------------------------------------------

[Event(name="resize", type="org.openzoom.events.ViewportEvent")]
[Event(name="change", type="org.openzoom.events.ViewportEvent")]
[Event(name="changeComplete", type="org.openzoom.events.ViewportEvent")]

/**
 * IViewport implementation that is based on a normalized [0, 1] coordinate system.
 */
public class NormalizedViewport extends EventDispatcher implements INormalizedViewport
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------
    
    private static const DEFAULT_MIN_Z : Number = 0.01
    private static const DEFAULT_MAX_Z : Number = 100
    private static const BOUNDS_TOLERANCE : Number = 0.5

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function NormalizedViewport( scene : IScene ) : void
    {
    	this.scene = scene
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  z
    //----------------------------------

    private var _z : Number = 1

    public function get zoom() : Number
    {
        return _z
    }

    public function set zoom( value : Number ) : void
    {
        zoomTo( value )
    }

    //----------------------------------
    //  minZ
    //----------------------------------

    private var _minZ : Number = DEFAULT_MIN_Z

    public function get minZoom() : Number
    {
        return _minZ
    }

    public function set minZoom( value : Number ) : void
    {
        _minZ = value
        validate()
    }

    //----------------------------------
    //  maxZ
    //----------------------------------
    
    private var _maxZ : Number = DEFAULT_MAX_Z
    
    public function get maxZoom() : Number
    {
        return _maxZ
    }
    
    public function set maxZoom( value : Number ) : void
    {
       _maxZ = value
       validate()
    }

    //----------------------------------
    //  scale
    //----------------------------------

    public function get scale() : Number
    {
        return bounds.width / ( scene.width * width ) 
    }
 
    //----------------------------------
    //  transform
    //----------------------------------

    public function get transform() : IViewportTransform
    {
    	return null
    }

    public function set transform( value : IViewportTransform ) : void
    {
    }
    
    //----------------------------------
    //  scene
    //----------------------------------

    private var _scene : IScene = new Scene( null, 100, 100 )

    public function get scene() : IScene
    {
        return new Scene( null, _scene.width, _scene.height )
    }

    public function set scene( value : IScene ) : void
    {
        if( _scene.width == value.width && _scene.height == value.height )
           return 
        
        _scene = new Scene( null, value.width, value.height )
        validate()
    }
    
    //----------------------------------
    //  bounds
    //----------------------------------
    
    private var _bounds : Rectangle = new Rectangle( 0, 0, 100, 100 )
    
    public function get bounds() : Rectangle
    {
        return _bounds.clone()
    }

    public function set bounds( value : Rectangle ) : void
    {
        if( _bounds.equals( value ) )
          return
        
        _bounds = value
        validate( false )
        
        dispatchEvent( new ViewportEvent( ViewportEvent.RESIZE, false, false, zoom ) )
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Zooming
    //
    //--------------------------------------------------------------------------
    
    public function showAll() : void
    {
    	showArea( new Rectangle( 0, 0, scene.width, scene.height ))
    }

    public function zoomTo( z : Number,
                            originX : Number = 0.5,
                            originY : Number = 0.5,
                            dispatchChangeEvent : Boolean = true ) : void
    {
        var oldZ : Number = this.zoom

        // keep z within min/max range
        _z = clamp( z, minZoom, maxZoom )

        // remember old origin
        var oldOrigin : Point = getViewportOrigin( originX, originY )

        // Compute normalized dimensions aspect ratio
        // This is ratio of the normalized content width and height 
        var ratio : Number = sceneAspectRatio / aspectRatio

        if( ratio >= 1 )
        {
            // content is wider than viewport
            _width = 1 / _z
            _height  = _width * ratio
        }
        else
        {
            // content is taller than viewport
            _height = 1 / _z
            _width  = _height / ratio
        }

        // move new origin to old origin
        moveOriginTo( oldOrigin.x, oldOrigin.y, originX, originY, false )

        if( dispatchChangeEvent )
            this.dispatchChangeEvent( oldZ )
    }

    public function zoomBy( factor : Number,
                            originX : Number = 0.5, originY : Number = 0.5,
                            dispatchChangeEvent : Boolean = true ) : void
    {
        zoomTo( zoom * factor, originX, originY, dispatchChangeEvent )
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Panning
    //
    //--------------------------------------------------------------------------

    public function moveTo( x : Number, y : Number,
                            dispatchChangeEvent : Boolean = true ) : void
    {
        // store the given (normalized) coordinates
        _x = x
        _y = y
    
        // content is wider than viewport
//        if( _width < 1 )
//        {
            // horizontal bounds checking:
            // the viewport sticks out on the left:
            // align it with the left margin
            if( _x + _width * BOUNDS_TOLERANCE < 0 )
                _x = -_width * BOUNDS_TOLERANCE
    
           // the viewport sticks out on the right:
           // align it with the right margin
           if(( _x + _width * ( 1 - BOUNDS_TOLERANCE )) > 1 )
               _x = 1 - _width * ( 1 - BOUNDS_TOLERANCE )      
//        }
//        else
//        {
//            // viewport is wider than content:
//            // center scene horizontally
//            _x = ( 1 - _width ) * 0.5
//        }
    
        // scene is taller than viewport
//        if( _height < 1 )
//        {
            // vertical bounds checking:
            // the viewport sticks out at the top:
            // align it with the top margin
            if( _y + _height * BOUNDS_TOLERANCE < 0 )
             _y = -_height * BOUNDS_TOLERANCE
        
            // the viewport sticks out at the bottom:
            // align it with the bottom margin
            if( _y + _height * (1 - BOUNDS_TOLERANCE) > 1 )
              _y = 1 - _height * ( 1 - BOUNDS_TOLERANCE )
//        }
//        else
//        {
//            // viewport is taller than scene
//            // center scene vertically
//            _y = ( 1 - _height ) * 0.5
//        } 
        
        if( dispatchChangeEvent )
            this.dispatchChangeEvent()
    }


    public function moveBy( dx : Number, dy : Number,
                            dispatchChangeEvent : Boolean = true  ) : void
    {
        moveTo( x + dx, y + dy, dispatchChangeEvent )
    }

    public function goto( x : Number, y : Number, z : Number,
                                    dispatchChangeEvent : Boolean = true ) : void
    {
        zoomTo( z, 0.5, 0.5, false )
        moveTo( x, y, dispatchChangeEvent )
    }


    public function moveCenterTo( x : Number, y : Number,
                                  dispatchChangeEvent : Boolean = true ) : void
    {
        moveOriginTo( x, y, 0.5, 0.5, dispatchChangeEvent )
    }

    public function showArea( area : Rectangle, scale : Number = 1.0, 
                              dispatchChangeEvent : Boolean = true ) : void
    {
        var centerX : Number = area.x + area.width  * 0.5
        var centerY : Number = area.y + area.height * 0.5
    
        var normalizedCenter : Point = new Point( centerX / scene.width,
                                                  centerY / scene.height )
                                                 
        var scaledWidth : Number = area.width / scale
        var scaledHeight : Number = area.height / scale
    
        var ratio : Number = sceneAspectRatio / aspectRatio
     
        // We have be careful here, the way the zoom factor is
        // interpreted depends on the relative ratio of scene and viewport
        if( scaledWidth  > ( aspectRatio * scaledHeight ) )
        {
            // Area must fit horizontally in the viewport
            ratio = ( ratio < 1 ) ? ( scene.width / ratio ) : scene.width
            ratio = ratio / scaledWidth
        }
        else
        {
            // Area must fit vertically in the viewport  
            ratio = ( ratio > 1 ) ? ( scene.height * ratio )  : scene.height
            ratio = ratio / scaledHeight
        }
    
        var oldZ : Number = zoom
    
        zoomTo( ratio, 0.5, 0.5, false )
        moveCenterTo( normalizedCenter.x, normalizedCenter.y, false )
    
        if( dispatchChangeEvent )
            this.dispatchChangeEvent( oldZ )
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Coordinate transformations
    //
    //--------------------------------------------------------------------------

    public function localToScene( point : Point ) : Point
    {
        var p : Point = new Point()
        p.x = ( x  * scene.width ) + ( point.x / _bounds.width )  * ( width  * scene.width )
        p.y = ( y  * scene.height ) + ( point.y / _bounds.height ) * ( height * scene.height )
        return p
    }

    public function sceneToLocal( point : Point ) : Point
    {
        var p : Point = new Point()
        p.x = ( point.x - ( x  * scene.width )) / ( width  * scene.width )   * _bounds.width
        p.y = ( point.y - ( y  * scene.height )) / ( height * scene.height ) * _bounds.height
        return p
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Internal
    //
    //--------------------------------------------------------------------------

    private function moveOriginTo( x : Number, y : Number,
                                   originX : Number, originY : Number,
                                   dispatchChangeEvent : Boolean = true ) : void
    {
        var newX : Number = x - width * originX
        var newY : Number = y - height * originY

        moveTo( newX, newY, dispatchChangeEvent )
    }

    private function getViewportOrigin( originX : Number,
                                        originY : Number ) : Point
    {
        var viewportOriginX : Number = x + width * originX
        var viewportOriginY : Number = y + height * originY
 
        return new Point( viewportOriginX, viewportOriginY )
    }

    /**
     * @private
     * 
     * Validate the viewport.
     */ 
    private function validate( dispatchEvent : Boolean = true ) : void
    {
        zoomTo( _z, 0.5, 0.5, dispatchEvent )
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
        return _bounds.width / _bounds.height
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
        return scene.width / scene.height
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: IViewport (scene coordinate system )
    //
    //--------------------------------------------------------------------------
    
    public function contains( x : Number, y : Number ) : Boolean
    {
        return ( x >= left ) && ( x <= right ) && ( y >= top ) && ( y <= bottom )
    }
    
    public function intersects( toIntersect : Rectangle ) : Boolean
    {
    	var sceneViewport : Rectangle = new Rectangle( x * scene.width,
                                                       y * scene.height, 
                                                       width * scene.width,
                                                       height * scene.height )
        return sceneViewport.intersects( denormalizeRectangle( toIntersect ))
    }
    
    public function intersection( toIntersect : Rectangle ) : Rectangle
    {
        var sceneViewport : Rectangle = new Rectangle( x * scene.width,
                                                       y * scene.height, 
                                                       width * scene.width,
                                                       height * scene.height )
        return sceneViewport.intersection( denormalizeRectangle( toIntersect ))
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
    
    private var _width : Number = 1
    
    public function get width() : Number
    {
        return _width
    }
    
    //----------------------------------
    //  height
    //----------------------------------
    
    private var _height : Number = 1
    
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

    //--------------------------------------------------------------------------
    //
    //  Methods: Events
    //
    //--------------------------------------------------------------------------
    
    private function dispatchChangeEvent( oldZ : Number = NaN ) : void
    {
        dispatchEvent( new ViewportEvent( ViewportEvent.CHANGE,
                           false, false, isNaN( oldZ ) ? zoom : oldZ ) )
    }
    
    public function dispatchChangeCompleteEvent() : void
    {
        dispatchEvent( new ViewportEvent( ViewportEvent.CHANGE_COMPLETE ) )
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
        return value / scene.width
    }

    /**
     * @private
     */
    private function normalizeY( value : Number ) : Number
    {
        return value / scene.height
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
        return value * scene.width
    }

    /**
     * @private
     */
    private function denormalizeY( value : Number ) : Number
    {
        return value * scene.height
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
    //  Methods: Debug
    //
    //--------------------------------------------------------------------------
    
    override public function toString() : String
    {
        return "[NormalizedViewport]" + "\n"
               + "x=" + x + "\n" 
               + "y=" + y  + "\n"
               + "z=" + zoom + "\n"
               + "w=" + width + "\n"
               + "h=" + height + "\n"
               + "sW=" + scene.width + "\n"
               + "sH=" + scene.height
    }
}

}