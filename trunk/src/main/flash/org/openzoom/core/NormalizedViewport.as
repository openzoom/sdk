////////////////////////////////////////////////////////////////////////////////
//
//  OpenZoom
//
//  Copyright (c) 2007â€“2008, Daniel Gasienica <daniel@gasienica.ch>
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

public class NormalizedViewport extends EventDispatcher implements INormalizedViewport
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------
    
    private static const DEFAULT_MIN_Z : Number = 0.01
    private static const DEFAULT_MAX_Z : Number = 100
    private static const BOUNDS_TOLERANCE : Number = 0

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function NormalizedViewport() : void
    {
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

    public function get z() : Number
    {
        return _z
    }

    public function set z( value : Number ) : void
    {
        normalizedZoomTo( value )
    }

    //----------------------------------
    //  minZ
    //----------------------------------

    private var _minZ : Number = DEFAULT_MIN_Z

    public function get minZ() : Number
    {
        return _minZ
    }

    public function set minZ( value : Number ) : void
    {
        _minZ = value
        validate()
    }

    //----------------------------------
    //  maxZ
    //----------------------------------
    
    private var _maxZ : Number = DEFAULT_MAX_Z
    
    public function get maxZ() : Number
    {
        return _maxZ
    }
    
    public function set maxZ( value : Number ) : void
    {
       _maxZ = value
       validate()
    }

    //----------------------------------
    //  scale
    //----------------------------------

    public function get scale() : Number
    {
        // TODO: Cache
        var topLeft : Point = sceneToLocal( new Point( 0, 0 ) )
        var bottomRight : Point = sceneToLocal( new Point( scene.width, scene.height ))

        // Pick one, should be the same =)
        var distanceX : Number = bottomRight.x - topLeft.x
        return distanceX / scene.width

        //var distanceY : Number = bottomRight.y - topLeft.y
        //return distanceY / scene.height
    }
 
    //----------------------------------
    //  content
    //----------------------------------

//    private var _content : Rectangle = new Rectangle( 0, 0, 100, 100 )
    private var _scene : IScene = new Scene( 100, 100 )

    public function get scene() : IScene
    {
        return new Scene( _scene.width, _scene.height )
    }

    public function set scene( value : IScene ) : void
    {
        if( _scene.width == value.width && _scene.height == value.height )
           return 
        
        _scene = new Scene( value.width, value.height )
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
        
        dispatchEvent( new ViewportEvent( ViewportEvent.RESIZE, false, false, z ) )
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods: Zooming (content coordinate system)
    //
    //--------------------------------------------------------------------------

//    public function zoomTo( z : Number, originX : Number = NaN, originY : Number = NaN,
//                            dispatchEvent : Boolean = true ) : void
//    {
//        normalizedZoomTo( z,
//                          isNaN( originX ) ? 0.5 : normalizeXCoordinate( originX ),
//                          isNaN( originY ) ? 0.5 : normalizeYCoordinate( originY ),
//                          dispatchEvent )
//    }
//
//    public function zoomBy( factor : Number, originX : Number = NaN,
//                            originY : Number = NaN, dispatchEvent : Boolean = true ) : void
//    {
//        normalizedZoomBy( factor,
//                          isNaN( originX ) ? 0.5 : normalizeXCoordinate( originX ),
//                          isNaN( originY ) ? 0.5 : normalizeYCoordinate( originY ),
//                          dispatchEvent )
//    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Zooming (normalized coordinate system)
    //
    //--------------------------------------------------------------------------

    public function normalizedZoomTo( z : Number,
                                      originX : Number = 0.5,
                                      originY : Number = 0.5,
                                      dispatchChangeEvent : Boolean = true ) : void
    {
        var oldZ : Number = this.z

        // keep z within min/max range
        _z = clamp( z, minZ, maxZ )

        // remember old origin
        var oldOrigin : Point = getNormalizedViewportOrigin( originX, originY )

        // Compute normalized dimensions aspect ratio
        // This is ratio of the normalized content width and height 
        var ratio : Number = contentAspectRatio / aspectRatio

        if( ratio > 1 )
        {
            // content is wider than viewport
            _normalizedWidth = 1 / _z
            _normalizedHeight  = _normalizedWidth * ratio
        }
        else
        {
            // content is taller than viewport
            _normalizedHeight = 1 / _z
            _normalizedWidth  = _normalizedHeight / ratio
        }

        // move new origin to old origin
        normalizedMoveOriginTo( oldOrigin.x, oldOrigin.y, originX, originY, false )

        if( dispatchChangeEvent )
            this.dispatchChangeEvent( oldZ )
    }

    public function normalizedZoomBy( factor : Number,
                                      originX : Number = 0.5, originY : Number = 0.5,
                                      dispatchChangeEvent : Boolean = true ) : void
    {
        normalizedZoomTo( z * factor, originX, originY, dispatchChangeEvent )
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Panning
    //
    //--------------------------------------------------------------------------

//    public function moveTo( x : Number, y : Number,
//                            dispatchChangeEvent : Boolean = true ) : void
//    {
//        normalizedMoveTo( normalizeXCoordinate( x ),
//                          normalizeYCoordinate( y ),
//                          dispatchChangeEvent )
//    }

    public function normalizedMoveTo( x : Number, y : Number,
                                      dispatchChangeEvent : Boolean = true ) : void
    {
        // store the given (normalized) coordinates
        _normalizedX = x
        _normalizedY = y
    
        // content is wider than viewport
        if( _normalizedWidth < 1 )
        {
            // horizontal bounds checking:
            // the viewport sticks out on the left:
            // align it with the left margin
            if( _normalizedX + _normalizedWidth * BOUNDS_TOLERANCE < 0 )
                _normalizedX = -_normalizedWidth * BOUNDS_TOLERANCE
    
           // the viewport sticks out on the right:
           // align it with the right margin
           if( ( _normalizedX + _normalizedWidth * ( 1 - BOUNDS_TOLERANCE ) ) > 1 )
               _normalizedX = 1 - _normalizedWidth * ( 1 - BOUNDS_TOLERANCE )      
         }
        else
        {
            // viewport is wider than content:
            // center the content horizontally
            _normalizedX = ( 1 - _normalizedWidth ) * 0.5
        }
    
        // content is taller than viewport
        if( _normalizedHeight < 1 )
        {
            // vertical bounds checking:
            // the viewport sticks out at the top:
            // align it with the top margin
            if( _normalizedY + _normalizedHeight * BOUNDS_TOLERANCE < 0 )
             _normalizedY = -_normalizedHeight * BOUNDS_TOLERANCE
        
            // the viewport sticks out at the bottom:
            // align it with the bottom margin
            if( _normalizedY + _normalizedHeight * ( 1 - BOUNDS_TOLERANCE ) > 1 )
              _normalizedY = 1 - _normalizedHeight * ( 1 - BOUNDS_TOLERANCE )
        }
        else
        {
            // viewport is taller than content
            // center the content vertically
            _normalizedY = ( 1 - _normalizedHeight ) * 0.5
        } 
        
        if( dispatchChangeEvent )
            this.dispatchChangeEvent()
    }

//    public function moveBy( x : Number, y : Number,
//                            dispatchChangeEvent : Boolean = true ) : void
//    {
//        normalizedMoveBy( normalizeXCoordinate( x ),
//                          normalizeYCoordinate( y ),
//                          dispatchChangeEvent )
//    }

    public function normalizedMoveBy( x : Number, y : Number,
                                      dispatchChangeEvent : Boolean = true  ) : void
    {
        normalizedMoveTo( normalizedX + x, normalizedY + y, dispatchChangeEvent )
    }

//    public function goto( x : Number, y : Number, z : Number,
//                          dispatchChangeEvent : Boolean = true ) : void
//    {
//        normalizedGoto( normalizeXCoordinate( x ),
//                        normalizeYCoordinate( y ),
//                        z, dispatchChangeEvent )
//    }

    public function normalizedGoto( x : Number, y : Number, z : Number,
                                    dispatchChangeEvent : Boolean = true ) : void
    {
        normalizedZoomTo( z, 0.5, 0.5, false )
        normalizedMoveTo( x, y, dispatchChangeEvent )
    }

//    public function moveCenterTo( x : Number, y : Number,
//                                  dispatchChangeEvent : Boolean = true ) : void
//    {
//        normalizedMoveCenterTo( normalizeXCoordinate( x ),
//                                normalizeYCoordinate( y ),
//                                dispatchChangeEvent )
//    }

    public function normalizedMoveCenterTo( x : Number, y : Number,
                                            dispatchChangeEvent : Boolean = true ) : void
    {
        normalizedMoveOriginTo( x, y, 0.5, 0.5, dispatchChangeEvent )
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
    
        var ratio : Number = contentAspectRatio / aspectRatio
     
        // We have be careful here, the way the zoom factor is
        // interpreted depends on the relative ratio of content and viewport
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
    
        var oldZ : Number = z
    
        normalizedZoomTo( ratio, 0.5, 0.5, false )
        normalizedMoveCenterTo( normalizedCenter.x, normalizedCenter.y, false )
    
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
        p.x = ( normalizedX  * scene.width ) + ( point.x / _bounds.width )  * ( normalizedWidth  * scene.width )
        p.y = ( normalizedY  * scene.height ) + ( point.y / _bounds.height ) * ( normalizedHeight * scene.height )
        return p
    }

    public function sceneToLocal( point : Point ) : Point
    {
        var p : Point = new Point()
        p.x = ( point.x - ( normalizedX  * scene.width )) / ( normalizedWidth  * scene.width )   * _bounds.width
        p.y = ( point.y - ( normalizedY  * scene.height )) / ( normalizedHeight * scene.height ) * _bounds.height
        return p
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Internal
    //
    //--------------------------------------------------------------------------

    private function normalizedMoveOriginTo( x : Number, y : Number,
                                             originX : Number, originY : Number,
                                             dispatchChangeEvent : Boolean = true ) : void
    {
        var newX : Number = x - normalizedWidth * originX
        var newY : Number = y - normalizedHeight * originY

        normalizedMoveTo( newX, newY, dispatchChangeEvent )
    }

    private function getNormalizedViewportOrigin( originX : Number,
                                                  originY : Number ) : Point
    {
        var viewportOriginX : Number = normalizedX + normalizedWidth * originX
        var viewportOriginY : Number = normalizedY + normalizedHeight * originY
 
        return new Point( viewportOriginX, viewportOriginY )
    }

    /**
     * @private
     * 
     * Validate the viewport.
     */ 
    private function validate( dispatchEvent : Boolean = true ) : void
    {
        normalizedZoomTo( _z, 0.5, 0.5, dispatchEvent )
    }

    /**
     * @private
     */ 
    private function normalizeXCoordinate( value : Number ) : Number
    {
        return value / scene.width
    }

    /**
     * @private
     */
    private function normalizeYCoordinate( value : Number ) : Number
    {
        return value / scene.height
    }

    /**
     * @private
     */ 
    private function denormalizeXCoordinate( value : Number ) : Number
    {
        return value * scene.width
    }

    /**
     * @private
     */ 
    private function denormalizeYCoordinate( value : Number ) : Number
    {
        return value * scene.height
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
    //  contentAspectRatio
    //----------------------------------
    
    /**
     * @private 
     * Returns the aspect ratio of the content.
     */
    private function get contentAspectRatio() : Number
    {
        return scene.width / scene.height
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: IViewport (content coordinate system )
    //
    //--------------------------------------------------------------------------
    
//    public function contains( x : Number, y : Number ) : Boolean
//    {
//        return ( x >= left ) && ( x <= right ) && ( y >= top ) && ( y <= bottom )
//    }
    
//    public function intersects( toIntersect : Rectangle ) : Boolean
//    {
//        return new Rectangle( x, y, width, height ).intersects( toIntersect )
//    }
    
    public function intersection( toIntersect : Rectangle ) : Rectangle
    {
        return new Rectangle( x, y, width, height ).intersection( toIntersect )
    }

    //--------------------------------------------------------------------------
    //
    //  Properties: IViewport
    //
    //--------------------------------------------------------------------------  
    
    //----------------------------------
    //  x
    //----------------------------------
    
    public function get x() : Number
    {
        return normalizedX * scene.width
    }
    
    //----------------------------------
    //  y
    //----------------------------------
    
    public function get y() : Number
    {
       return normalizedY * scene.height
    }
    
    //----------------------------------
    //  width
    //----------------------------------
    
    public function get width() : Number
    {
        return normalizedWidth * scene.width
    }
    
    //----------------------------------
    //  height
    //----------------------------------
    
    public function get height() : Number
    {
        return normalizedHeight * scene.height
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
    //  normalizedX
    //----------------------------------
    
    private var _normalizedX : Number = 0
    
    public function get normalizedX() : Number
    {
        return _normalizedX
    }
    
    public function set normalizedX( value : Number ) : void
    {
        normalizedMoveTo( value, normalizedY )
    }
    
    //----------------------------------
    //  normalizedY
    //----------------------------------
    
    private var _normalizedY : Number = 0
    
    public function get normalizedY() : Number
    {
       return _normalizedY
    }
    
    public function set normalizedY( value : Number ) : void
    {
        normalizedMoveTo( normalizedX, value )
    }
    
    //----------------------------------
    //  normalizedCenterX
    //----------------------------------
    
    public function get normalizedCenterX() : Number
    {
        return _normalizedX + _normalizedWidth * 0.5
    }
    
    public function set normalizedCenterX( value : Number ) : void
    {
        normalizedMoveTo( value - _normalizedWidth * 0.5, normalizedY )
    }
    
    //----------------------------------
    //  normalizedCenterY
    //----------------------------------
    
    public function get normalizedCenterY() : Number
    {
        return _normalizedY + _normalizedHeight * 0.5
    }
    
    public function set normalizedCenterY( value : Number ) : void
    {
        normalizedMoveTo( normalizedX, value - _normalizedHeight * 0.5 )
    }
    
    //----------------------------------
    //  normalizedWidth
    //----------------------------------
    
    private var _normalizedWidth : Number = 1
    
    public function get normalizedWidth() : Number
    {
        return _normalizedWidth
    }
    
    //----------------------------------
    //  normalizedHeight
    //----------------------------------
    
    private var _normalizedHeight : Number = 1
    
    public function get normalizedHeight() : Number
    {
        return _normalizedHeight
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Events
    //
    //--------------------------------------------------------------------------
    
    public function dispatchChangeEvent( oldZ : Number = NaN ) : void
    {
        dispatchEvent( new ViewportEvent( ViewportEvent.CHANGE,
                           false, false, isNaN( oldZ ) ? z : oldZ ) )
    }
    
    public function dispatchChangeCompleteEvent() : void
    {
        dispatchEvent( new ViewportEvent( ViewportEvent.CHANGE_COMPLETE ) )
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods: Debug
    //
    //--------------------------------------------------------------------------
    
    override public function toString() : String
    {
        return "[NormalizedViewport]" + "\n" 
               + "x=" + normalizedX + "\n" 
               + "y=" + normalizedY  + "\n"
               + "z=" + z + "\n"
               + "w=" + normalizedWidth + "\n"
               + "h=" + normalizedHeight + "\n"
               + "sW=" + scene.width + "\n"
               + "sH=" + scene.height
    }
}

}