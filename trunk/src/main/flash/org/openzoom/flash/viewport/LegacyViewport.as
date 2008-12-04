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
package org.openzoom.flash.viewport
{

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.geom.Point;
import flash.geom.Rectangle;

import mx.skins.halo.DataGridColumnResizeSkin;

import org.openzoom.flash.events.ViewportEvent;
import org.openzoom.flash.scene.IReadonlyMultiScaleScene;
import org.openzoom.flash.viewport.constraints.NullViewportConstraint;
import org.openzoom.flash.viewport.transformers.NullViewportTransformer;

//------------------------------------------------------------------------------
//
//  Events
//
//------------------------------------------------------------------------------

/**
 * @inheritDoc
 */
[Event(name="resize", type="org.openzoom.events.ViewportEvent")]

/**
 * @inheritDoc
 */
[Event(name="transformStart", type="org.openzoom.events.ViewportEvent")]

/**
 * @inheritDoc
 */
[Event(name="transform", type="org.openzoom.events.ViewportEvent")]

/**
 * @inheritDoc
 */
[Event(name="transformComplete", type="org.openzoom.events.ViewportEvent")]


/**
 * Legacy IViewport implementation that is based on a normalized [0, 1] coordinate system.
 * Only used for testing purposes.
 */
public class LegacyViewport extends EventDispatcher
                            implements INormalizedViewport,
                                       IReadonlyViewport,
                                       IViewportContainer,
                                       ITransformerViewport
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    private static const NULL_CONSTRAINT  : IViewportConstraint  = new NullViewportConstraint()
    private static const NULL_TRANSFORMER : IViewportTransformer = new NullViewportTransformer()
    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function LegacyViewport( width : Number, height : Number,
                                        scene : IReadonlyMultiScaleScene )
    {
    	_viewportWidth = width
    	_viewportHeight = height
    	
        _scene = scene
        _scene.addEventListener( Event.RESIZE, scene_resizeHandler, false, 0, true )
        
        _transformer = new TransformerProxy( this )
        
        validate()
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  z
    //----------------------------------

    private var _zoom : Number = 1;

    [Bindable(event="zoomChanged")]
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

    [Bindable(event="scaleChanged")]
    public function get scale() : Number
    {
        return viewportWidth / ( scene.sceneWidth * width ) 
    }
 
    //----------------------------------
    //  constraint
    //----------------------------------
    
    private var _constraint : IViewportConstraint = new NullViewportConstraint()
//    private var _constraint : IViewportConstraint = new DefaultViewportConstraint()

    public function get constraint() : IViewportConstraint
    {
        return _constraint
    }
    
    public function set constraint( value : IViewportConstraint ) : void
    {
    	if( value )
    	   _constraint = value
    	else
    	   _constraint = NULL_CONSTRAINT
    }

    //----------------------------------
    //  transformer
    //----------------------------------

    private var _transformer : IViewportTransformer

    public function get transformer() : IViewportTransformer
    {
        return _transformer
    }

    public function set transformer( value : IViewportTransformer ) : void
    {
        _transformer.stop()
        
        if( value )
           _transformer = value
        else
           _transformer = NULL_TRANSFORMER
           
        _transformer.viewport = this
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
    	// TODO
    }
//    
//    //----------------------------------
//    //  targetTransform
//    //----------------------------------
//
    private var _targetTransform : IViewportTransform
    
    public function get targetTransform() : IViewportTransform
    {  
    	return null     
//        return _targetTransform.clone()
    }

    public function set targetTransform( value : IViewportTransform ) : void
    {
//        _targetTransform = value.clone()
    }
    
    //----------------------------------
    //  scene
    //----------------------------------

    private var _scene : IReadonlyMultiScaleScene

    public function get scene() : IReadonlyMultiScaleScene
    {
        return _scene
    }
    
    //----------------------------------
    //  viewportWidth
    //----------------------------------
    
    private var _viewportWidth : Number
    
    [Bindable(event="viewportWidthChanged")]
    public function get viewportWidth() : Number
    {
        return _viewportWidth
    }
    
    //----------------------------------
    //  viewportHeight
    //----------------------------------
    
    private var _viewportHeight : Number
    
    [Bindable(event="viewportHeightChanged")]
    public function get viewportHeight() : Number
    {
        return _viewportHeight
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Zooming
    //
    //--------------------------------------------------------------------------

    public function zoomTo( zoom : Number,
                            originX : Number = 0.5,
                            originY : Number = 0.5,
                            dispatchChangeEvent : Boolean = true ) : void
    {
        var oldZoom : Number = this.zoom

        // keep z within min/max range
//        _zoom = clamp( zoom, constraint.minZoom, constraint.maxZoom )
        _zoom = zoom

        // remember old origin
        var oldOrigin : Point = getViewportOrigin( originX, originY )

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
        moveOriginTo( oldOrigin.x, oldOrigin.y, originX, originY, false )

        if( dispatchChangeEvent )
            this.updateTransform( oldZoom )
            
        dispatchEvent( new Event( "zoomChanged" ))
        dispatchEvent( new Event( "widthChanged" ))
        dispatchEvent( new Event( "heightChanged" ))
        dispatchEvent( new Event( "scaleChanged" ))
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

        // compute position
//        var position : Point = constraint.computePosition( this )
            
        // capture new position
//        _x = position.x
//        _y = position.y
        
        if( dispatchChangeEvent )
            this.updateTransform()
    }


    public function moveBy( dx : Number, dy : Number,
                            dispatchChangeEvent : Boolean = true  ) : void
    {
        moveTo( x + dx, y + dy, dispatchChangeEvent )
    }

    public function moveCenterTo( x : Number, y : Number,
                                  dispatchChangeEvent : Boolean = true ) : void
    {
        moveOriginTo( x, y, 0.5, 0.5, dispatchChangeEvent )
    }

    public function showRect( rect : Rectangle, scale : Number = 1.0, 
                              dispatchChangeEvent : Boolean = true ) : void
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
    
        zoomTo( ratio, 0.5, 0.5, false )
        moveCenterTo( normalizedCenter.x, normalizedCenter.y, false )
    
        if( dispatchChangeEvent )
            this.updateTransform( oldZoom )
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
        zoomTo( _zoom, 0.5, 0.5, dispatchEvent )
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
    //  Methods: IViewport (scene coordinate system )
    //
    //--------------------------------------------------------------------------
    
    public function contains( x : Number, y : Number ) : Boolean
    {
        return ( x >= left ) && ( x <= right ) && ( y >= top ) && ( y <= bottom )
    }
    
    public function intersects( toIntersect : Rectangle ) : Boolean
    {
    	var sceneViewport : Rectangle = new Rectangle( x * scene.sceneWidth,
                                                       y * scene.sceneHeight, 
                                                       width * scene.sceneWidth,
                                                       height * scene.sceneHeight )
        return sceneViewport.intersects( denormalizeRectangle( toIntersect ))
    }
    
    public function intersection( toIntersect : Rectangle ) : Rectangle
    {
        var sceneViewport : Rectangle = new Rectangle( x * scene.sceneWidth,
                                                       y * scene.sceneHeight, 
                                                       width * scene.sceneWidth,
                                                       height * scene.sceneHeight )
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
    
    private var _width : Number = 1;
    
    [Bindable(event="widthChanged")]
    public function get width() : Number
    {
        return _width
    }
    
    //----------------------------------
    //  height
    //----------------------------------
    
    private var _height : Number = 1;
    
    [Bindable(event="heightChanged")]
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
    //  topLeft
    //----------------------------------
    
    public function get topLeft() : Point
    {
        return new Point( left, top )
    }
    
    //----------------------------------
    //  bottomRight
    //----------------------------------
    
    public function get bottomRight() : Point
    {
        return new Point( right, bottom )
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Events
    //
    //--------------------------------------------------------------------------
    
    
    public function beginTransform() : void
    {
        dispatchEvent( new ViewportEvent( ViewportEvent.TRANSFORM_START ))
    }
    
    private function updateTransform( oldZoom : Number = NaN ) : void
    {
        dispatchEvent( new ViewportEvent( ViewportEvent.TRANSFORM_UPDATE,
                           false, false ))
    }
    
    public function endTransform() : void
    {
//    	updateTransform()
        dispatchEvent( new ViewportEvent( ViewportEvent.TRANSFORM_END ))
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods: Internal
    //
    //--------------------------------------------------------------------------
    
    public function setSize( width : Number, height : Number ) : void
    {
        if( _viewportWidth == width && _viewportHeight == height )
            return
        
        _viewportWidth = width
        _viewportHeight = height
        validate( false )
        
        // FIXME: add beginTransform & endTransform
        dispatchEvent( new ViewportEvent( ViewportEvent.RESIZE, false, false ))
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
               + "sW=" + scene.sceneWidth + "\n"
               + "sH=" + scene.sceneHeight
    }
}

}

    
//------------------------------------------------------------------------------
//
//  Internal classes
//
//------------------------------------------------------------------------------
    
import flash.geom.Rectangle;
import flash.geom.Point;

import org.openzoom.flash.viewport.INormalizedViewport;
import org.openzoom.flash.viewport.ITransformerViewport;
import org.openzoom.flash.viewport.IViewport;
import org.openzoom.flash.viewport.IViewportConstraint;
import org.openzoom.flash.viewport.IViewportTransform;
import org.openzoom.flash.viewport.IViewportTransformer;
import org.openzoom.flash.viewport.ViewportTransform;

/**
 * @private
 * Viewport transformer proxy.
 */
class TransformerProxy implements IViewportTransformer
{
    public function TransformerProxy( viewport : ITransformerViewport )
    {
        _viewport = viewport
        _target = new ViewportTransformProxy( _viewport )
    }
    
    private var _viewport : ITransformerViewport
    private var _target : IViewportTransform
    
    public function get viewport() : ITransformerViewport
    {
        return _viewport
    }
    
    public function set viewport( value : ITransformerViewport ) : void
    {
        _viewport = value
    }
    
    public function get constraint() : IViewportConstraint
    {
    	return null
    }
    
    public function set constraint( value : IViewportConstraint ) : void
    {
    	
    }
    
    public function get targetTransform() : IViewportTransform
    {
        return _target
    }
    
    public function stop() : void
    {
    }
    
    public function transform( target : IViewportTransform,
                               immediately : Boolean = false ) : void
    {
    }
}

/**
 * @private
 * Viewport transform proxy.
 */
class ViewportTransformProxy implements IViewportTransform
{
    public function ViewportTransformProxy( viewport : IViewport )
    {
        this.viewport = viewport
    }
    
    private var viewport : IViewport
    
    public function get zoom() : Number
    {
        return viewport.zoom
    }
    
    public function set zoom( value : Number ) : void
    {
        viewport.zoom = value
    }
    
    public function get x() : Number
    {
        return viewport.x
    }
    
    public function set x( value : Number ) : void
    {
        viewport.x = value
    }
    
    public function get y() : Number
    {
        return viewport.y
    }
    
    public function set y( value : Number ) : void
    {
        viewport.y = value
    }
    
    public function get sceneWidth() : Number
    {
        return viewport.scene.sceneWidth
    }
    
    public function get sceneHeight() : Number
    {
        return viewport.scene.sceneHeight
    }
    
    public function get width() : Number
    {
        return viewport.width
    }
    
    public function set width( value : Number ) : void
    {
//        viewport.width = value
    }
    
    public function get height() : Number
    {
        return viewport.height
    }
    
    public function set height( value : Number ) : void
    {
//        viewport.height = value
    }
    
    public function get bottom() : Number
    {
        return viewport.bottom
    }
    
    public function get top() : Number
    {
        return viewport.top
    }
    
    public function get left() : Number
    {
        return viewport.left
    }
    
    public function get right() : Number
    {
        return viewport.right
    }
    
    public function get topLeft() : Point
    {
        return null
    }
    
    public function get bottomRight() : Point
    {
        return null
    }
    
    public function get scale() : Number
    {
        return viewport.scale
    }
    
    public function set scale( value : Number ) : void
    {
    	// Not implemented
    }
    
    public function clone() : IViewportTransform
    {
        return null
    }
    
    public function copy( other : IViewportTransform ) : void
    {
    }
    
    public function equals( other : IViewportTransform ) : Boolean
    {
        return true
    }
    
    public function get viewportWidth() : Number
    {
        return viewport.viewportWidth
    }
    
    public function get viewportHeight() : Number
    {
        return viewport.viewportHeight
    }
    
    public function moveBy( dx : Number, dy : Number ) : void
    {
    }
    
    public function moveTo( x : Number, y : Number ) : void
    {
    }
    
    public function moveCenterTo( x : Number, y : Number ) : void
    {
    }
    
    public function zoomTo( z : Number,
                            transformX : Number = 0.5,
                            transformY : Number = 0.5 ) : void
    {
    }
    
    public function zoomBy( factor : Number,
                            transformX : Number = 0.5,
                            transformY : Number = 0.5 ) : void
    {
    }
    
    public function showAll() : void
    {
    }
    
    public function showRect( rect : Rectangle, scaleTo : Number = 1.0 ) : void
    {
    }
}