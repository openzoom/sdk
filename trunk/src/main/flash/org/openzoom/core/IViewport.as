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

import flash.events.IEventDispatcher;
import flash.geom.Point;
import flash.geom.Rectangle;

//------------------------------------------------------------------------------
//
//  Events
//
//------------------------------------------------------------------------------

[Event(name="resize", type="org.openzoom.events.ViewportEvent")]
[Event(name="change", type="org.openzoom.events.ViewportEvent")]
[Event(name="changeComplete", type="org.openzoom.events.ViewportEvent")]

/**
 * Interface a viewport implementation has to provide.
 */
public interface IViewport extends IEventDispatcher
{
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  scale
    //----------------------------------
    
    /**
     * Scale of the scene.
     */ 
    function get scale() : Number;
      
    //----------------------------------
    //  z
    //----------------------------------
    
    /**
     * Zoom level of the viewport.
     * Scene fits exactly into viewport at value 1.
     */
    function get z() : Number
    function set z( value : Number ) : void
    
    //----------------------------------
    //  minZ
    //----------------------------------
    
    /**
     * Minimum zoom level.
     */
    function get minZ() : Number
    function set minZ( value : Number ) : void
    
    //----------------------------------
    //  maxZ
    //----------------------------------
    
    /**
     * Maximum zoom level.
     */
    function get maxZ() : Number
    function set maxZ( value : Number ) : void

    //--------------------------------------------------------------------------
    //
    //  Methods: Zooming
    //
    //--------------------------------------------------------------------------
    
    /**
     * Zoom the viewport to a zoom level z.
     * @param originX Horizontal coordinate of the zooming center in scene coordinates
     * @param originY Vertical coordinate of the zooming center in scene coordinates
     */
    function zoomTo( z : Number, originX : Number = NaN, originY : Number = NaN,
                     dispatchChangeEvent : Boolean = true ) : void
    
    /**
     * Zoom the viewport by a factor.
     * @param factor The factor by which the z coordinate will be multiplied.
     * @param originX Horizontal coordinate of the zooming center in scene coordinates
     * @param originY Vertical coordinate of the zooming center in scene coordinates
     */
    function zoomBy( factor : Number, originX : Number = NaN, originY : Number = NaN,
                     dispatchChangeEvent : Boolean = true ) : void
    
    //--------------------------------------------------------------------------
    //
    //  Methods: Zooming (normalized)
    //
    //--------------------------------------------------------------------------
    
    /**
     * Zoom the viewport to a zoom level z.
     * @param originX Normalized horizontal coordinate of the zooming center
     * @param originY Normalized vertical coordinate of the zooming center
     */
    function normalizedZoomTo( z : Number, originX : Number = 0.5, originY : Number = 0.5,
                               dispatchChangeEvent : Boolean = true ) : void
    
    /**
     * Zoom the viewport by a factor.
     * @param factor The scale factor for the zoom.
     * @param originX Normalized horizontal coordinate of the zooming center
     * @param originY Normalized vertical coordinate of the zooming center
     */
    function normalizedZoomBy( factor : Number, originX : Number = 0.5, originY : Number = 0.5,
                               dispatchChangeEvent : Boolean = true ) : void
    
    //--------------------------------------------------------------------------
    //
    //  Methods: Panning
    //
    //--------------------------------------------------------------------------
    
    /**
     * Move the viewport.
     * @param x Horizontal coordinate in the scene coordinate system.
     * @param y Vertical coordinate in the scene coordinate system.
     */
    function moveTo( x : Number, y : Number,
                     dispatchChangeEvent : Boolean = true ) : void
    
    /**
     * Move the viewport.
     * @param dx Horizontal translation in the scene coordinate system.
     * @param dy Vertical translation in the scene coordinate system.
     */
    function moveBy( dx : Number, dy : Number,
                     dispatchChangeEvent : Boolean = true ) : void
    
    /**
     * Move the viewport center.
     * @param x Horizontal coordinate in the scene coordinate system.
     * @param y Vertical coordinate in the scene coordinate system.
     */                 
    function moveCenterTo( x : Number, y : Number,
                           dispatchChangeEvent : Boolean = true ) : void
    
    //--------------------------------------------------------------------------
    //
    //  Methods: Panning (normalized)
    //
    //--------------------------------------------------------------------------
    
    /**
     * Move the viewport.
     * @param x Normalized horizontal coordinate
     * @param y Normalized vertical coordinate
     */
    function normalizedMoveTo( x : Number, y : Number,
                               dispatchChangeEvent : Boolean = true ) : void
    
    /**
     * Move the viewport.
     * @param dx Normalized horizontal delta translation
     * @param dy Normalized vertical delta translation
     */
    function normalizedMoveBy( dx : Number, dy : Number,
                               dispatchChangeEvent : Boolean = true ) : void
    
    /**
     * Move the viewport center.
     * @param x Normalized x (horizontal) coordinate
     * @param y Normalized y (vertical) coordinate
     */                 
    function normalizedMoveCenterTo( x : Number, y : Number,
                                     dispatchChangeEvent : Boolean = true ) : void
    
    //--------------------------------------------------------------------------
    //
    //  Methods: Navigation
    //
    //--------------------------------------------------------------------------
    
    /**
     * Go to a point in the scene.
     * @param x Horizontal coordinate in the scene coordinate system.
     * @param y Vertical coordinate in the scene coordinate system.
     * @param z Zoom level
     */
    function goto( x : Number, y : Number, z : Number,
                   dispatchChangeEvent : Boolean = true ) : void
    
    /**
     * Show an area of the scene inside the viewport.
     * 
     * @param area Box that describes the area in sceen coordinates
     *             to be shown in the viewport.
     * @param scale scale a which the area is beeing displayed.
     */             
    function showArea( area : Rectangle, scale : Number = 1.0,
                       dispatchChangeEvent : Boolean = true ) : void

    
    //--------------------------------------------------------------------------
    //
    //  Methods: Navigation (normalized)
    //
    //--------------------------------------------------------------------------
    
    /**
     * Go to a point in the scene.
     * @param x Normalized horizontal coordinate
     * @param y Normalized vertical coordinate
     * @param z Zoom level
     */
    function normalizedGoto( x : Number, y : Number, z : Number,
                             dispatchChangeEvent : Boolean = true ) : void
                             
    //--------------------------------------------------------------------------
    //
    //  Properties: Content
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  content
    //----------------------------------
    
    /**
     * Size of the content in content coordinates.
     */ 
    function get content() : Rectangle
    function set content( value : Rectangle ) : void
    
    //--------------------------------------------------------------------------
    //
    //  Properties: Normalized coordinates
    //
    //--------------------------------------------------------------------------
     
    //----------------------------------
    //  normalizedX
    //----------------------------------
    
    /**
     * Normalized horizontal coordinate of the viewport.
     * If z > 1 and the value is 0 the viewport is at
     * the left boundary of the content.
     */
    function get normalizedX() : Number
    function set normalizedX( value : Number ) : void
    
    //----------------------------------
    //  normalizedY
    //----------------------------------
    
    /**
     * Normalized vertical coordinate of the viewport.
     * If z > 1 and the value is 0 the viewport is at
     * the top boundary of the content.
     */
    function get normalizedY() : Number
    function set normalizedY( value : Number ) : void
    
    //----------------------------------
    //  normalizedWidth
    //----------------------------------
    
    /**
     * Normalized horizontal dimension of the viewport.
     * The viewport has the width of the content at value 1
     * if aspectRatio > 1.
     */
    function get normalizedWidth() : Number
    
    //----------------------------------
    //  normalizedHeight
    //----------------------------------
    
    /**
     * Normalized vertical dimension of the viewport.
     * The viewport has the height of the content at value 1
     * if aspectRatio < 1.
     */
    function get normalizedHeight() : Number
    
    
    //--------------------------------------------------------------------------
    //
    //  Properties: Coordinates in content coordinate system
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  x
    //----------------------------------
    
    function get x() : Number
    
    //----------------------------------
    //  y
    //----------------------------------
    
    function get y() : Number
    
    //----------------------------------
    //  width
    //----------------------------------
    
    function get width() : Number
    
    //----------------------------------
    //  height
    //----------------------------------
     
    function get height() : Number
    
    //----------------------------------
    //  top
    //----------------------------------
    
    function get top() : Number
    
    //----------------------------------
    //  right
    //----------------------------------
    
    function get right() : Number
    
    //----------------------------------
    //  bottom
    //----------------------------------
    
    function get bottom() : Number
    
    //----------------------------------
    //  left
    //----------------------------------
    
    function get left() : Number
     
    //----------------------------------
    //  bounds
    //----------------------------------
    
    /**
     * Bounds of the viewport in viewport coordinates.
     */
    function get bounds() : Rectangle
    function set bounds( value : Rectangle ) : void
    
    //--------------------------------------------------------------------------
    //
    //  Methods: Coordinate transformations
    //
    //--------------------------------------------------------------------------

    function viewportToLocal( point : Point ) : Point
    function localToViewport( point : Point ) : Point
    
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
    function contains( x : Number, y : Number ) : Boolean
        
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
    function intersects( toIntersect : Rectangle ) : Boolean
    
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
    function intersection( toIntersect : Rectangle ) : Rectangle
    
    //--------------------------------------------------------------------------
    //
    //  Methods: Events
    //
    //--------------------------------------------------------------------------
  
    /**
     * Dispatch changeComplete event to let all listeners
     * know that a Viewport transition has completed.
     */
    function dispatchChangeCompleteEvent() : void
}

}