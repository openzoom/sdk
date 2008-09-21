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

public class Viewport extends EventDispatcher implements IViewport
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
    public function Viewport() : void
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
        var topLeft : Point = localToViewport( _content.topLeft )
        var bottomRight : Point = localToViewport( _content.bottomRight )

        // Pick one, should be the same =)
        var distanceX : Number = bottomRight.x - topLeft.x
        return distanceX / _content.width

        //var distanceY : Number = bottomRight.y - topLeft.y
        //return distanceY / _content.height
    }
 
    //----------------------------------
    //  content
    //----------------------------------

    private var _content : Rectangle = new Rectangle( 0, 0, 100, 100 )

    public function get content() : Rectangle
    {
        return _content.clone()
    }

    public function set content( value : Rectangle ) : void
    {
        if( _content.equals( value ) )
           return 
        
        _content = value
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

    public function zoomTo( z : Number, originX : Number = NaN, originY : Number = NaN,
                            dispatchEvent : Boolean = true ) : void
    {
        normalizedZoomTo( z,
                          isNaN( originX ) ? 0.5 : normalizeXCoordinate( originX ),
                          isNaN( originY ) ? 0.5 : normalizeYCoordinate( originY ),
                          dispatchEvent )
    }

    public function zoomBy( factor : Number, originX : Number = NaN,
                            originY : Number = NaN, dispatchEvent : Boolean = true ) : void
    {
        normalizedZoomBy( factor,
                          isNaN( originX ) ? 0.5 : normalizeXCoordinate( originX ),
                          isNaN( originY ) ? 0.5 : normalizeYCoordinate( originY ),
                          dispatchEvent )
    }

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

    public function moveTo( x : Number, y : Number,
                            dispatchChangeEvent : Boolean = true ) : void
    {
        normalizedMoveTo( normalizeXCoordinate( x ),
                          normalizeYCoordinate( y ),
                          dispatchChangeEvent )
    }

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

    public function moveBy( x : Number, y : Number,
                            dispatchChangeEvent : Boolean = true ) : void
    {
        normalizedMoveBy( normalizeXCoordinate( x ),
                          normalizeYCoordinate( y ),
                          dispatchChangeEvent )
    }

    public function normalizedMoveBy( x : Number, y : Number,
                                      dispatchChangeEvent : Boolean = true  ) : void
    {
        normalizedMoveTo( normalizedX + x, normalizedY + y, dispatchChangeEvent )
    }

    public function goto( x : Number, y : Number, z : Number,
                          dispatchChangeEvent : Boolean = true ) : void
    {
        normalizedGoto( normalizeXCoordinate( x ),
                        normalizeYCoordinate( y ),
                        z, dispatchChangeEvent )
    }

    public function normalizedGoto( x : Number, y : Number, z : Number,
                                    dispatchChangeEvent : Boolean = true ) : void
    {
        normalizedZoomTo( z, 0.5, 0.5, false )
        normalizedMoveTo( x, y, dispatchChangeEvent )
    }

    public function moveCenterTo( x : Number, y : Number,
                                  dispatchChangeEvent : Boolean = true ) : void
    {
        normalizedMoveCenterTo( normalizeXCoordinate( x ),
                                normalizeYCoordinate( y ),
                                dispatchChangeEvent )
    }

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
    
        var normalizedCenter : Point = new Point( centerX / _content.width,
                                                  centerY / _content.height )
                                                 
        var scaledWidth : Number = area.width / scale
        var scaledHeight : Number = area.height / scale
    
        var ratio : Number = contentAspectRatio / aspectRatio
     
        // We have be careful here, the way the zoom factor is
        // interpreted depends on the relative ratio of content and viewport
        if( scaledWidth  > ( aspectRatio * scaledHeight ) )
        {
            // Area must fit horizontally in the viewport
            ratio = ( ratio < 1 ) ? ( _content.width / ratio ) : _content.width
            ratio = ratio / scaledWidth
        }
        else
        {
            // Area must fit vertically in the viewport  
            ratio = ( ratio > 1 ) ? ( _content.height * ratio )  : _content.height
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

    public function viewportToLocal( point : Point ) : Point
    {
        var p : Point = new Point()
        p.x = x + ( point.x / _bounds.width ) * width
        p.y = y + ( point.y / _bounds.height ) * height
        return p
    }

    public function localToViewport( point : Point ) : Point
    {
        var p : Point = new Point()
        p.x = ( point.x - x ) / width  * _bounds.width
        p.y = ( point.y - y ) / height * _bounds.height
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
        return value / _content.width
    }

    /**
     * @private
     */
    private function normalizeYCoordinate( value : Number ) : Number
    {
        return value / _content.height
    }

    /**
     * @private
     */ 
    private function denormalizeXCoordinate( value : Number ) : Number
    {
        return value * _content.width
    }

    /**
     * @private
     */ 
    private function denormalizeYCoordinate( value : Number ) : Number
    {
        return value * _content.height
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
        return _content.width / _content.height
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: IViewport (content coordinate system )
    //
    //--------------------------------------------------------------------------
    
    public function contains( x : Number, y : Number ) : Boolean
    {
        return ( x >= left ) && ( x <= right ) && ( y >= top ) && ( y <= bottom )
    }
    
    public function intersects( toIntersect : Rectangle ) : Boolean
    {
        return new Rectangle( x, y, width, height ).intersects( toIntersect )
    }
    
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
        return normalizedX * content.width
    }
    
    //----------------------------------
    //  y
    //----------------------------------
    
    public function get y() : Number
    {
       return normalizedY * content.height
    }
    
    //----------------------------------
    //  width
    //----------------------------------
    
    public function get width() : Number
    {
        return normalizedWidth * content.width
    }
    
    //----------------------------------
    //  height
    //----------------------------------
    
    public function get height() : Number
    {
        return normalizedHeight * content.height
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
        return "[Viewport]" + "\n" 
               + "nX=" + normalizedX + "\n" 
               + "nY=" + normalizedY  + "\n"
               + "z=" + z + "\n"
               + "nW=" + normalizedWidth + "\n"
               + "nH=" + normalizedHeight + "\n"
               + "x=" + x + "\n"
               + "y=" + y + "\n"
               + "w=" + width + "\n"
               + "h=" + height + "\n"
               + "cW=" + content.width + "\n"
               + "cH=" + content.height
    }
}

}