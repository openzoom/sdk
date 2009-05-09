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

import flash.events.IEventDispatcher;
import flash.geom.Point;
import flash.geom.Rectangle;

import org.openzoom.flash.scene.IReadonlyMultiScaleScene;

//------------------------------------------------------------------------------
//
//  Events
//
//------------------------------------------------------------------------------

/**
 *  Dispatched when the viewport container is resized.
 *
 *  @eventType org.openzoom.flash.events.ViewportEvent.RESIZE
 */
[Event(name="resize", type="org.openzoom.events.ViewportEvent")]

/**
 *  Dispatched when a viewport transformation begins.
 *
 *  @eventType org.openzoom.flash.events.ViewportEvent.TRANSFORM_START
 */
[Event(name="transformStart", type="org.openzoom.events.ViewportEvent")]

/**
 *  Dispatched when the viewport transformation is updated.
 *
 *  @eventType org.openzoom.flash.events.ViewportEvent.TRANSFORM_UPDATE
 */
[Event(name="transformUpdate", type="org.openzoom.events.ViewportEvent")]

/**
 *  Dispatched when a viewport transformation ends.
 *
 *  @eventType org.openzoom.flash.events.ViewportEvent.TRANSFORM_END
 */
[Event(name="transformEnd", type="org.openzoom.events.ViewportEvent")]

///**
// *  Dispatched when the viewport transformation target is updated.
// *
// *  @eventType org.openzoom.flash.events.ViewportEvent.TARGET_UPDATE
// */
//[Event(name="targetUpdate", type="org.openzoom.events.ViewportEvent")]

/**
 * Interface a viewport implementation has to provide.
 */
public interface IViewport extends IEventDispatcher
{
    //--------------------------------------------------------------------------
    //
    //  Properties: Coordinates
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  x
    //----------------------------------

    /**
     * Horizontal coordinate of the viewport.
     */
    function get x():Number
    function set x(value:Number):void

    //----------------------------------
    //  y
    //----------------------------------

    /**
     * Vertical coordinate of the viewport.
     */
    function get y():Number
    function set y(value:Number):void

    //----------------------------------
    //  width
    //----------------------------------

    /**
     * Horizontal dimension of the viewport.
     */
    function get width():Number
    function set width(value:Number):void

    //----------------------------------
    //  height
    //----------------------------------

    /**
     * Vertical dimension of the viewport.
     */
    function get height():Number
    function set height(value:Number):void

    //----------------------------------
    //  viewportWidth
    //----------------------------------

    /**
     * Width of the viewport container.
     */
    function get viewportWidth():Number

    //----------------------------------
    //  viewportHeight
    //----------------------------------

    /**
     * Height of the viewport container.
     */
    function get viewportHeight():Number

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  transform
    //----------------------------------

    /**
     * Transformation that is currently applied to the viewport
     */
    function get transform():IViewportTransform
    function set transform(value:IViewportTransform):void

//    //----------------------------------
//    //  constraint
//    //----------------------------------
//
//    function get constraint():IViewportConstraint
//    function set constraint(value:IViewportConstraint):void

    //----------------------------------
    //  transformer
    //----------------------------------

    /**
     * Transforms the IViewport object after its state has been changed.
     */
    function get transformer():IViewportTransformer
    function set transformer(value:IViewportTransformer):void

    //----------------------------------
    //  scene
    //----------------------------------

    /**
     * Scene this viewport belongs to.
     */
    function get scene():IReadonlyMultiScaleScene

    //----------------------------------
    //  scale
    //----------------------------------

    /**
     * Scale of the scene.
     */
    function get scale():Number
    function set scale(value:Number):void

    //----------------------------------
    //  zoom
    //----------------------------------

    /**
     * Zoom level of the viewport.
     * Scene fits exactly into viewport at value 1.
     */
    function get zoom():Number
    function set zoom(value:Number):void

    //--------------------------------------------------------------------------
    //
    //  Methods: Zooming
    //
    //--------------------------------------------------------------------------

    /**
     * Zoom the viewport to a zoom level z.
     * @param zoom Target value for the viewport's zoom property
     * @param transformX Horizontal coordinate of the zooming center
     * @param transformY Vertical coordinate of the zooming center
     */
    function zoomTo(zoom:Number,
                    transformX:Number=0.5,
                    transformY:Number=0.5,
                    immediately:Boolean=false):void

    /**
     * Zoom the viewport by a factor.
     * @param factor Multiplier for the zoom.
     * @param transformX Horizontal coordinate of the zooming center
     * @param transformY Vertical coordinate of the zooming center
     */
    function zoomBy(factor:Number,
                    transformX:Number=0.5,
                    transformY:Number=0.5,
                    immediately:Boolean=false):void

    //--------------------------------------------------------------------------
    //
    //  Methods: Panning
    //
    //--------------------------------------------------------------------------

    /**
     * Move the viewport.
     * @param x Horizontal coordinate
     * @param y Vertical coordinate
     */
    function panTo(x:Number, y:Number,
                   immediately:Boolean=false):void

    /**
     * Move the viewport.
     * @param deltaX Horizontal translation delta
     * @param deltaY Vertical translation delta
     */
    function panBy(deltaX:Number, deltaY:Number,
                   immediately:Boolean=false):void

    /**
     * Move the viewport center.
     * @param centerX Horizontal coordinate of the new center
     * @param centerY Vertical coordinate of the new center
     */
    function panCenterTo(centerX:Number, centerY:Number,
                         immediately:Boolean=false):void

    //--------------------------------------------------------------------------
    //
    //  Methods: Navigation
    //
    //--------------------------------------------------------------------------

    /**
     * Fit entire scene into the viewport.
     */
    function showAll(immediately:Boolean=false):void

    /**
     * Show a rectangular area of the scene inside the viewport.
     *
     * @param bounds Rectangle to be shown in the viewport.
     * @param scale Scale at which the rectangle is beeing displayed, e.g. useful
     *              for displaying some space around the rectangle.
     */
    function fitToBounds(bounds:Rectangle,
                         scale:Number=1.0,
                         immediately:Boolean=false):void

    /**
     * Returns a Rectangle object with the bounds of the viewport.
     */
    function getBounds():Rectangle

    //--------------------------------------------------------------------------
    //
    //  Methods: Coordinate transformations
    //
    //--------------------------------------------------------------------------

    /**
     * Converts the point object from the viewport's
     * container (local) coordinates to scene coordinates.
     */
    function localToScene(point:Point):Point

    /**
     * Converts the point object from scene coordinates
     * to the viewport's container (local) coordinates.
     */
    function sceneToLocal(point:Point):Point

    //--------------------------------------------------------------------------
    //
    //  Methods: flash.geom.Rectangle
    //
    //--------------------------------------------------------------------------

    /**
     * Determines whether the specified point is contained within this Viewport object.
     *
     * @param x The x coordinate (horizontal position) of the point.
     * @param y The y coordinate (vertical position) of the point.
     *
     * @return true if this Viewport object contains the specified
     * point; otherwise false.
     */
    function contains(x:Number, y:Number):Boolean

    /**
     * Determines whether the object specified in the toIntersect parameter
     * intersects with this Viewport object. This method checks the x, y, width,
     * and height properties of the specified Rectangle object to see if it
     * intersects with this Viewport object.
     *
     * @param toIntersect The Rectangle object to compare against this Viewport object.
     *
     * @return true if the specified object intersects with this Viewport
     * object; otherwise false.
     */
    function intersects(toIntersect:Rectangle):Boolean

    /**
     * If the Rectangle object specified in the toIntersect parameter intersects
     * with this Viewport object, returns the area of intersection as a Rectangle
     * object. If the objects do not intersect, this method returns an empty
     * Rectangle object with its properties set to 0.
     *
     * @param toIntersect The Rectangle object to compare against to see if it
     * intersects with this Viewport object.
     *
     * @return A Rectangle object that equals the area of intersection.
     * If the rectangles do not intersect, this method returns an empty Rectangle
     * object; that is, a rectangle with its x, y, width, and height properties set to 0.
     */
    function intersection(toIntersect:Rectangle):Rectangle

    //--------------------------------------------------------------------------
    //
    //  Properties: flash.geom.Rectangle
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  top
    //----------------------------------

    /**
     * The y coordinate of the top-left corner of the viewport.
     */
    function get top():Number

    //----------------------------------
    //  right
    //----------------------------------

    /**
     * The sum of the x and width properties.
     */
    function get right():Number

    //----------------------------------
    //  bottom
    //----------------------------------

    /**
     * The sum of the y and height properties.
     */
    function get bottom():Number

    //----------------------------------
    //  left
    //----------------------------------

    /**
     * The x coordinate of the top-left corner of the viewport.
     */
    function get left():Number

    //----------------------------------
    //  topLeft
    //----------------------------------

    /**
     * The location of the IViewport object's top-left corner,
     * determined by the x and y coordinates of the point.
     */
    function get topLeft():Point

    //----------------------------------
    //  bottomRight
    //----------------------------------

    /**
     * The location of the IViewport object's bottom-right corner,
     * determined by the values of the right and bottom properties.
     */
    function get bottomRight():Point
}

}
