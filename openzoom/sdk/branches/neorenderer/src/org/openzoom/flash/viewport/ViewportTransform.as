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
package org.openzoom.flash.viewport
{

import flash.geom.Point;
import flash.geom.Rectangle;

/**
 * The ViewportTransform stores the position and bounds of a viewport.
 */
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
    public function ViewportTransform(x:Number,
                                      y:Number,
                                      width:Number,
                                      height:Number,
                                      zoom:Number,
                                      viewportWidth:Number,
                                      viewportHeight:Number,
                                      sceneWidth:Number,
                                      sceneHeight:Number)
    {
        bounds.x = x
        bounds.y = y
        bounds.width = width
        bounds.height = height
        _zoom = zoom

        _sceneWidth = sceneWidth
        _sceneHeight = sceneHeight

        _viewportWidth = viewportWidth
        _viewportHeight = viewportHeight
    }

    /**
     * Constructs and initializes a ViewportTransform object
     * from the given parameter values.
     */
    public static function fromValues(x:Number,
                                      y:Number,
                                      width:Number,
                                      height:Number,
                                      zoom:Number,
                                      viewportWidth:Number,
                                      viewportHeight:Number,
                                      sceneWidth:Number,
                                      sceneHeight:Number):ViewportTransform
    {
        var instance:ViewportTransform = new ViewportTransform(x,
                                                               y,
                                                               width,
                                                               height,
                                                               zoom,
                                                               viewportWidth,
                                                               viewportHeight,
                                                               sceneWidth,
                                                               sceneHeight)
        // initialize
        instance.zoomTo(zoom)

        return instance
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    private var bounds:Rectangle = new Rectangle(0, 0, 1, 1)

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  zoom
    //----------------------------------

    private var _zoom:Number

    /**
     * @inheritDoc
     */
    public function get zoom():Number
    {
        return _zoom
    }

    public function set zoom(value:Number):void
    {
        zoomTo(value)
    }

    //----------------------------------
    //  scale
    //----------------------------------

    /**
     * @inheritDoc
     */
    public function get scale():Number
    {
        return viewportWidth / (_sceneWidth * width)
    }

    public function set scale(value:Number):void
    {
//        width = viewportWidth / (value * _sceneWidth)
        var targetWidth:Number = viewportWidth / (value * _sceneWidth)
        zoomTo(getZoomForWidth(targetWidth))
    }


    //--------------------------------------------------------------------------
    //
    //  Methods: Zooming
    //
    //--------------------------------------------------------------------------

    /**
     * @inheritDoc
     */
    public function zoomTo(zoom:Number,
                           transformX:Number=0.5,
                           transformY:Number=0.5):void
    {
        _zoom = zoom

        // remember old origin
        var oldOrigin:Point = getViewportOrigin(transformX, transformY)

        var bounds:Point = getBoundsForZoom(zoom)
        this.bounds.width  = bounds.x
        this.bounds.height = bounds.y

        // move new origin to old origin
        panOriginTo(oldOrigin.x, oldOrigin.y, transformX, transformY)
        
    	origin.x = oldOrigin.x
    	origin.y = oldOrigin.y
    }

    /**
     * @inheritDoc
     */
    public function zoomBy(factor:Number,
                           transformX:Number=0.5,
                           transformY:Number=0.5):void
    {
    	if (factor == 1)
    	   return
    	   
        zoomTo(zoom * factor, transformX, transformY)
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Panning
    //
    //--------------------------------------------------------------------------

    /**
     * @inheritDoc
     */
    public function panTo(x:Number, y:Number):void
    {
        bounds.x = x
        bounds.y = y
    }

    /**
     * @inheritDoc
     */
    public function panBy(dx:Number, dy:Number):void
    {
        panTo(x + dx, y + dy)
    }

    /**
     * @inheritDoc
     */
    public function panCenterTo(x:Number, y:Number):void
    {
        panOriginTo(x, y, 0.5, 0.5)
    }

    /**
     * @inheritDoc
     */
    public function fitToBounds(bounds:Rectangle, scale:Number=1.0):void
    {
        var center:Point = new Point(bounds.x + bounds.width / 2,
                                     bounds.y + bounds.height / 2)

        var scaledBounds:Rectangle = bounds.clone()
            scaledBounds.width /= scale
            scaledBounds.height /= scale

        // Fit viewport width to width of bounds
        width = scaledBounds.width

        // If entire bounds are not visible,
        // simply switch the fitting
        if (height < scaledBounds.height)
            height = scaledBounds.height

        panCenterTo(center.x, center.y)
    }

    /**
     * @inheritDoc
     */
    public function showAll():void
    {
        fitToBounds(new Rectangle(0, 0, 1, 1))
    }
    
    /**
     * @inheritDoc
     */
    public function getBounds():Rectangle
    {
        return new Rectangle(x, y, width, height)
    }
    
    /**
     * @inheritDoc
     */
    public function getCenter():Point
    {
        return new Point(bounds.x + bounds.width / 2,
                         bounds.y + bounds.height / 2)
    }

    /**
     * @inheritDoc
     */
    private var origin:Point = new Point()
     
    public function getOrigin():Point
    {
    	return origin.clone()
    }

    /**
     * @inheritDoc
     */
    public function contains(x:Number, y:Number):Boolean
    {
        return bounds.contains(x, y)
    }

    /**
     * @inheritDoc
     */
    public function intersects(toIntersect:Rectangle):Boolean
    {
    	return bounds.intersects(toIntersect)
    }

    /**
     * @inheritDoc
     */
    public function intersection(toIntersect:Rectangle):Rectangle
    {
    	return bounds.intersection(toIntersect)
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Internal
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    private function panOriginTo(x:Number,
                                 y:Number,
                                 transformX:Number,
                                 transformY:Number):void
    {
        var newX:Number = x - width * transformX
        var newY:Number = y - height * transformY

        panTo(newX, newY)
    }

    /**
     * @private
     */
    private function getViewportOrigin(transformX:Number,
                                       transformY:Number):Point
    {
        var viewportOriginX:Number = x + width * transformX
        var viewportOriginY:Number = y + height * transformY

        return new Point(viewportOriginX, viewportOriginY)
    }

    //--------------------------------------------------------------------------
    //
    //  Properties: IViewport
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  x
    //----------------------------------

    /**
     * @inheritDoc
     */
    public function get x():Number
    {
        return bounds.x
    }

    public function set x(value:Number):void
    {
        panTo(value, y)
    }

    //----------------------------------
    //  y
    //----------------------------------

    /**
     * @inheritDoc
     */
    public function get y():Number
    {
       return bounds.y
    }

    public function set y(value:Number):void
    {
        panTo(x, value)
    }

    //----------------------------------
    //  width
    //----------------------------------

    /**
     * @inheritDoc
     */
    public function get width():Number
    {
        return bounds.width
    }

    public function set width(value:Number):void
    {
        zoomTo(getZoomForWidth(value), 0, 0)
    }

    //----------------------------------
    //  height
    //----------------------------------

    /**
     * @inheritDoc
     */
    public function get height():Number
    {
        return bounds.height
    }

    public function set height(value:Number):void
    {
        zoomTo(getZoomForHeight(value), 0, 0)
    }

    //----------------------------------
    //  viewportWidth
    //----------------------------------

    private var _viewportWidth:Number

    /**
     * @inheritDoc
     */
    public function get viewportWidth():Number
    {
        return _viewportWidth
    }
    //----------------------------------
    //  viewportHeight
    //----------------------------------

    private var _viewportHeight:Number

    /**
     * @inheritDoc
     */
    public function get viewportHeight():Number
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

    private var _sceneWidth:Number

    /**
     * @copy org.openzoom.flash.scene.IMultiScaleScene#sceneWidth
     */
    public function get sceneWidth():Number
    {
        return _sceneWidth
    }

    //----------------------------------
    //  sceneHeight
    //----------------------------------

    private var _sceneHeight:Number

    /**
     * @copy org.openzoom.flash.scene.IMultiScaleScene#sceneHeight
     */
    public function get sceneHeight():Number
    {
        return _sceneHeight
    }


    //--------------------------------------------------------------------------
    //
    //  Methods: Internal
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    private function getBoundsForZoom(zoom:Number):Point
    {
        var ratio:Number = sceneAspectRatio / aspectRatio
        var width:Number
        var height:Number

        // sceneAspectRatio > aspectRatio
        if (ratio >= 1)
        {
            // scene is wider than viewport
            width  = 1 / _zoom
            height = width * ratio
        }
        else
        {
            // scene is taller than viewport
            height = 1 / _zoom
            width  = height / ratio
        }

        var bounds:Point = new Point(width, height)
        return bounds
    }

    /**
     * @private
     */
    private function getZoomForWidth(width:Number):Number
    {
        var zoom:Number
        var ratio:Number = sceneAspectRatio / aspectRatio

        if (ratio >= 1)
            zoom = 1 / width
        else
            zoom = 1 / (width * ratio)

        return zoom
    }

    /**
     * @private
     */
    private function getZoomForHeight(height:Number):Number
    {
        var ratio:Number = sceneAspectRatio / aspectRatio
        return getZoomForWidth(height / ratio)
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Debug
    //
    //--------------------------------------------------------------------------

    /**
     * @inheritDoc
     */
    public function toString():String
    {
        return "[ViewportTransform] (" +
               "x=" + x + ", " +
               "y=" + y  + ", " +
               "z=" + zoom + ", " +
               "w=" + width + ", " +
               "h=" + height + ")"
    }

    /**
     * @inheritDoc
     */
    public function copy(other:IViewportTransform):void
    {
        bounds.x = other.x
        bounds.y = other.y
        bounds.width = other.width
        bounds.height = other.height
        _zoom = other.zoom

        _sceneWidth = other.sceneWidth
        _sceneHeight = other.sceneHeight
    }

    /**
     * @inheritDoc
     */
    public function clone():IViewportTransform
    {
        var copy:ViewportTransform =
                        new ViewportTransform(bounds.x, bounds.y,
                                              bounds.width, bounds.height, _zoom,
                                              _viewportWidth, _viewportHeight,
                                              _sceneWidth, _sceneHeight)

        return copy
    }

    /**
     * @inheritDoc
     */
    public function equals(other:IViewportTransform):Boolean
    {
        return x == other.x &&
               y == other.y &&
               width == other.width &&
               height == other.height &&
               zoom == other.zoom &&
               viewportWidth == other.viewportWidth &&
               viewportHeight == other.viewportHeight &&
               sceneWidth == other.sceneWidth &&
               sceneHeight == other.sceneHeight
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: IViewportTransformContainer
    //
    //--------------------------------------------------------------------------

    /**
     * @inheritDoc
     */
    public function setSize(width:Number, height:Number):void
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
     *
     * Returns the aspect ratio of this Viewport object.
     */
    private function get aspectRatio():Number
    {
        return viewportWidth / viewportHeight
    }

    //----------------------------------
    //  sceneAspectRatio
    //----------------------------------

    /**
     * @private
     *
     * Returns the aspect ratio of scene.
     */
    private function get sceneAspectRatio():Number
    {
        return sceneWidth / sceneHeight
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
    public function get left():Number
    {
        return x
    }

    //----------------------------------
    //  right
    //----------------------------------

    /**
     * @inheritDoc
     */
    public function get right():Number
    {
        return x + width
    }

    //----------------------------------
    //  top
    //----------------------------------

    /**
     * @inheritDoc
     */
    public function get top():Number
    {
        return y
    }

    //----------------------------------
    //  bottom
    //----------------------------------

    /**
     * @inheritDoc
     */
    public function get bottom():Number
    {
        return y + height
    }

    //----------------------------------
    //  topLeft
    //----------------------------------

    /**
     * @inheritDoc
     */
    public function get topLeft():Point
    {
        return new Point(left, top)
    }

    //----------------------------------
    //  bottomRight
    //----------------------------------

    /**
     * @inheritDoc
     */
    public function get bottomRight():Point
    {
        return new Point(right, bottom)
    }
}

}
