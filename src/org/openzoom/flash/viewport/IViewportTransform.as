////////////////////////////////////////////////////////////////////////////////
//
//  OpenZoom SDK
//
//  Version: MPL 1.1/GPL 3/LGPL 3
//
//  The contents of this file are subject to the Mozilla Public License Version
//  1.1 (the "License"); you may not use this file except in compliance with
//  the License. You may obtain a copy of the License at
//  http://www.mozilla.org/MPL/
//
//  Software distributed under the License is distributed on an "AS IS" basis,
//  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
//  for the specific language governing rights and limitations under the
//  License.
//
//  The Original Code is the OpenZoom SDK.
//
//  The Initial Developer of the Original Code is Daniel Gasienica.
//  Portions created by the Initial Developer are Copyright (c) 2007-2010
//  the Initial Developer. All Rights Reserved.
//
//  Contributor(s):
//    Daniel Gasienica <daniel@gasienica.ch>
//
//  Alternatively, the contents of this file may be used under the terms of
//  either the GNU General Public License Version 3 or later (the "GPL"), or
//  the GNU Lesser General Public License Version 3 or later (the "LGPL"),
//  in which case the provisions of the GPL or the LGPL are applicable instead
//  of those above. If you wish to allow use of your version of this file only
//  under the terms of either the GPL or the LGPL, and not to allow others to
//  use your version of this file under the terms of the MPL, indicate your
//  decision by deleting the provisions above and replace them with the notice
//  and other provisions required by the GPL or the LGPL. If you do not delete
//  the provisions above, a recipient may use your version of this file under
//  the terms of any one of the MPL, the GPL or the LGPL.
//
////////////////////////////////////////////////////////////////////////////////
package org.openzoom.flash.viewport
{

import flash.geom.Point;
import flash.geom.Rectangle;

import org.openzoom.flash.utils.IDisposable;

/**
 * Interface for viewport transform implementations.
 */
public interface IViewportTransform extends IDisposable
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
     * @copy org.openzoom.flash.viewport.IViewport#x
     */
    function get x():Number
    function set x(value:Number):void

    //----------------------------------
    //  y
    //----------------------------------

    /**
     * @copy org.openzoom.flash.viewport.IViewport#y
     */
    function get y():Number
    function set y(value:Number):void

    //----------------------------------
    //  width
    //----------------------------------

    /**
     * @copy org.openzoom.flash.viewport.IViewport#width
     */
    function get width():Number
    function set width(value:Number):void

    //----------------------------------
    //  height
    //----------------------------------

    /**
     * @copy org.openzoom.flash.viewport.IViewport#height
     */
    function get height():Number
    function set height(value:Number):void

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  viewportWidth
    //----------------------------------

    /**
     * @copy org.openzoom.flash.viewport.IViewport#viewportWidth
     */
    function get viewportWidth():Number

    //----------------------------------
    //  viewportHeight
    //----------------------------------

    /**
     * @copy org.openzoom.flash.viewport.IViewport#viewportHeight
     */
    function get viewportHeight():Number

    //----------------------------------
    //  sceneWidth
    //----------------------------------

    /**
     * @copy org.openzoom.flash.scene.IMultiScaleScene#sceneWidth
     */
    function get sceneWidth():Number

    //----------------------------------
    //  sceneHeight
    //----------------------------------

    /**
     * @copy org.openzoom.flash.scene.IMultiScaleScene#sceneHeight
     */
    function get sceneHeight():Number

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

//    //----------------------------------
//    //  origin
//    //----------------------------------
//
//    /**
//     * Returns the origin of the transform.
//     */
//    function get origin():Point

    //----------------------------------
    //  center
    //----------------------------------

    /**
     * Returns the center of the transform.
     */
    function get center():Point

    //--------------------------------------------------------------------------
    //
    //  Methods: Zooming
    //
    //--------------------------------------------------------------------------

    /**
     * Zoom the viewport to the given zoom level.
     * @param zoom Zoom level
     * @param transformX Horizontal coordinate of the zooming center
     * @param transformY Vertical coordinate of the zooming center
     */
    function zoomTo(zoom:Number,
                    transformX:Number=0.5,
                    transformY:Number=0.5):void

    /**
     * Zoom the viewport by a factor.
     * @param factor Scale factor for the zoom.
     * @param transformX Horizontal coordinate of the zooming center
     * @param transformY Vertical coordinate of the zooming center
     */
    function zoomBy(factor:Number,
                    transformX:Number=0.5,
                    transformY:Number=0.5):void

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
    function panTo(x:Number, y:Number):void

    /**
     * Move the viewport.
     * @param dx Horizontal translation delta
     * @param dy Vertical translation delta
     */
    function panBy(deltaX:Number, deltaY:Number):void

    /**
     * Move the viewport center.
     * @param x Horizontal coordinate
     * @param y Vertical coordinate
     */
    function panCenterTo(centerX:Number, centerY:Number):void

    //--------------------------------------------------------------------------
    //
    //  Methods: Navigation
    //
    //--------------------------------------------------------------------------

    /**
     * Show an area of the scene inside the viewport.
     *
     * @param rect Rectangular area to be shown in the viewport.
     * @param scale Scale at which the area is beeing displayed.
     */
    function fitToBounds(bounds:Rectangle, scale:Number=1.0):void

    /**
     * Fit entire scene into the viewport.
     */
    function showAll():void

    /**
     * Returns a Rectangle object with the bounds of the viewport.
     */
    function getBounds():Rectangle

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     * Returns a new IViewportTransform object with the same values for the
     * x, y, width, height and zoom properties as the original IViewportTransform object.
     */
    function clone():IViewportTransform

    /**
     * Copy values from other to this instance of IViewportTransform.
     */
    function copy(other:IViewportTransform):void

    /**
     * Determines whether the object specified in the
     * other parameter is equal to this Rectangle object.
     */
    function equals(other:IViewportTransform):Boolean

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
     * Coordinate of the upper boundary of the viewport transform.
     */
    function get top():Number

    //----------------------------------
    //  right
    //----------------------------------

    /**
     * @copy org.openzoom.flash.viewport.IViewport#right
     */
    function get right():Number

    //----------------------------------
    //  bottom
    //----------------------------------

    /**
     * @copy org.openzoom.flash.viewport.IViewport#bottom
     */
    function get bottom():Number

    //----------------------------------
    //  left
    //----------------------------------

    /**
     * @copy org.openzoom.flash.viewport.IViewport#left
     */
    function get left():Number

    //----------------------------------
    //  topLeft
    //----------------------------------

    /**
     * @copy org.openzoom.flash.viewport.IViewport#topLeft
     */
    function get topLeft():Point

    //----------------------------------
    //  bottomRight
    //----------------------------------

    /**
     * @copy org.openzoom.flash.viewport.IViewport#bottomRight
     */
    function get bottomRight():Point
}

}
