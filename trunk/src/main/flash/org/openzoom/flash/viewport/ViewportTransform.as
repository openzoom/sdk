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
package org.openzoom.flash.viewport
{

import flash.geom.Point;
import flash.geom.Rectangle;

public class ViewportTransform implements IViewportTransform,
                                           IViewportTransformContainer
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function ViewportTransform( x : Number, y : Number,
                                        width : Number, height : Number,
                                        zoom : Number,
                                        viewportWidth : Number, viewportHeight : Number,
                                        sceneWidth : Number, sceneHeight : Number)
    {
        _x = x
        _y = y
        _width = width
        _height = height
        _zoom = zoom
    	
        _sceneWidth = sceneWidth    
        _sceneHeight = sceneHeight
        
        _viewportWidth = viewportWidth
        _viewportHeight = viewportHeight
    }
    
    public static function fromValues(  x : Number, y : Number,
                                        width : Number, height : Number, zoom : Number,
                                        viewportWidth : Number, viewportHeight : Number,
                                        sceneWidth : Number, sceneHeight : Number ) : ViewportTransform
    {
    	var instance : ViewportTransform = new ViewportTransform( x, y, width, height, zoom,
    	                                                            viewportWidth, viewportHeight,
    	                                                            sceneWidth, sceneHeight )
        // initialize
        instance.zoomTo( zoom )
            
        return instance
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  zoom
    //----------------------------------

    private var _zoom : Number

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
        return viewportWidth / ( _sceneWidth * width ) 
    }
    
    public function set scale( value : Number ) : void
    {
    	width = viewportWidth / ( value * _sceneWidth ) 
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
        _zoom = zoom

        // remember old origin
        var oldOrigin : Point = getViewportOrigin( transformX, transformY )
        
        var bounds : Point = getWidthAndHeightForZoom( zoom )
        _width  = bounds.x
        _height = bounds.y

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
    
        var center : Point = new Point( centerX / _sceneWidth,
                                        centerY / _sceneHeight )
                                                 
        var scaledWidth : Number = area.width / scale
        var scaledHeight : Number = area.height / scale
    
        var ratio : Number = sceneAspectRatio / aspectRatio
     
        // We have be careful here, the way the zoom factor is
        // interpreted depends on the relative ratio of scene and viewport
        if( scaledWidth > ( aspectRatio * scaledHeight ) )
        {
            // Area must fit horizontally in the viewport
            ratio = ( ratio < 1 ) ? ( _sceneWidth / ratio ) : _sceneWidth
            ratio = ratio / scaledWidth
        }
        else
        {
            // Area must fit vertically in the viewport  
            ratio = ( ratio > 1 ) ? ( _sceneHeight * ratio ) : _sceneHeight
            ratio = ratio / scaledHeight
        }
    
        var oldZoom : Number = zoom
    
        zoomTo( ratio )
        moveCenterTo( center.x, center.y )
    }
    
    public function showAll() : void
    {
        showRect( new Rectangle( 0, 0, 1, 1 ))
    }


    //--------------------------------------------------------------------------
    //
    //  Methods: Internal
    //
    //--------------------------------------------------------------------------

    private function moveOriginTo( x : Number, y : Number,
                                   transformX : Number, transformY : Number ) : void
    {
        var newX : Number = x - width  * transformX
        var newY : Number = y - height * transformY

        moveTo( newX, newY )
    }

    private function getViewportOrigin( transformX : Number,
                                        transformY : Number ) : Point
    {
        var viewportOriginX : Number = x + width  * transformX
        var viewportOriginY : Number = y + height * transformY
 
        return new Point( viewportOriginX, viewportOriginY )
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
    
    public function set width( value : Number ) : void
    {
        zoomTo( getZoomForWidth( value ), 0, 0 )
    }
    
    //----------------------------------
    //  height
    //----------------------------------
    
    private var _height : Number = 1
    
    public function get height() : Number
    {
        return _height
    }
    
    public function set height( value : Number ) : void
    {
    	zoomTo( getZoomForHeight( value ), 0, 0 )
    }

    //----------------------------------
    //  viewportWidth
    //----------------------------------
    
    private var _viewportWidth : Number
    
    public function get viewportWidth() : Number
    {
        return _viewportWidth
    }
    
    //----------------------------------
    //  viewportHeight
    //----------------------------------
    
    private var _viewportHeight : Number
    
    public function get viewportHeight() : Number
    {
        return _viewportHeight
    }

    //--------------------------------------------------------------------------
    //
    //  Properties: Scene
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  sceneWidth
    //----------------------------------
    
    private var _sceneWidth : Number
    
    public function get sceneWidth() : Number
    {
        return _sceneWidth
    }
    
    //----------------------------------
    //  sceneHeight
    //----------------------------------
    
    private var _sceneHeight : Number
    
    public function get sceneHeight() : Number
    {
        return _sceneHeight
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
        return value / _sceneWidth
    }

    /**
     * @private
     */
    private function normalizeY( value : Number ) : Number
    {
        return value / _sceneHeight
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
        return value * _sceneWidth
    }

    /**
     * @private
     */
    private function denormalizeY( value : Number ) : Number
    {
        return value * _sceneHeight
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
    //  Methods: Internal
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private
     */
    private function getWidthAndHeightForZoom( zoom : Number ) : Point
    {
        var ratio : Number = sceneAspectRatio / aspectRatio
        var width : Number  
        var height : Number  
    
        if( ratio >= 1 )
        {
            // scene is wider than viewport
            width = 1 / _zoom
            height  = width * ratio
        }
        else
        {
            // scene is taller than viewport
            height = 1 / _zoom
            width = height / ratio
        }
        
        var bounds : Point = new Point( width, height )
        return bounds
    }
    
    /**
     * @private
     */
    private function getZoomForWidth( width : Number ) : Number
    {
        var zoom : Number
        var ratio : Number = sceneAspectRatio / aspectRatio

        if( ratio >= 1 )
            zoom = 1 / width
        else
            zoom = 1 / ( width * ratio )
            
        return zoom
    }
    
    /**
     * @private
     */
    private function getZoomForHeight( height : Number ) : Number
    {
        var ratio : Number = sceneAspectRatio / aspectRatio
        return getZoomForWidth( height / ratio )
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods: Debug
    //
    //--------------------------------------------------------------------------
    
    /**
     * @inheritDoc
     */ 
    public function toString() : String
    {
        return "[ViewportTransform2]" + "("
               + "x=" + x + ", " 
               + "y=" + y  + ", "
               + "z=" + zoom + ", "
               + "w=" + width + ", "
               + "h=" + height + ")"
    }
    
    /**
     * @inheritDoc
     */
    public function copy( other : IViewportTransform ) : void
    {
    	_x = other.x
    	_y = other.y
    	_width = other.width
    	_height = other.height
    	_zoom = other.zoom
    	
    	_sceneWidth = other.sceneWidth
    	_sceneHeight = other.sceneHeight
    }
    
    public function clone() : IViewportTransform
    {
        var copy : ViewportTransform =
		                new ViewportTransform( _x, _y, _width, _height, _zoom,
		                                        _viewportWidth, _viewportHeight,
		                                        _sceneWidth, _sceneHeight )
            
        return copy	
    }
    
    public function equals( other : IViewportTransform ) : Boolean
    {
    	return x == other.x
    	       && y == other.y
    	       && width == other.width
    	       && height == other.height
    	       && zoom == other.zoom
    	       && viewportWidth == other.viewportWidth
    	       && viewportHeight == other.viewportHeight
    	       && sceneWidth == other.sceneWidth
    	       && sceneHeight == other.sceneHeight
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: IViewportTransformContainer
    //
    //--------------------------------------------------------------------------
    
    /**
     * @inheritDoc
     */ 
    public function setSize( width : Number, height : Number ) : void
    {
    	_viewportWidth  = width
    	_viewportHeight = height
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
        return _sceneWidth / _sceneHeight
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties: flash.geom.Rectangle
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  left
    //----------------------------------
    
    /**
     * @inheritDoc
     */ 
    public function get left() : Number
    {
        return x
    }
    
    //----------------------------------
    //  right
    //----------------------------------
    
    /**
     * @inheritDoc
     */
    public function get right() : Number
    {
        return x + width
    }
    
    //----------------------------------
    //  top
    //----------------------------------
    
    /**
     * @inheritDoc
     */
    public function get top() : Number
    {
        return y
    }
    
    //----------------------------------
    //  bottom
    //----------------------------------
    
    /**
     * @inheritDoc
     */
    public function get bottom() : Number
    {
        return y + height
    }
    
    //----------------------------------
    //  topLeft
    //----------------------------------
    
    /**
     * @inheritDoc
     */
    public function get topLeft() : Point
    {
        return new Point( left, top )
    }
    
    //----------------------------------
    //  bottomRight
    //----------------------------------
    
    /**
     * @inheritDoc
     */
    public function get bottomRight() : Point
    {
        return new Point( right, bottom )
    }
}

}