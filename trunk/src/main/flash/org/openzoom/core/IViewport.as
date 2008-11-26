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
[Event(name="transformStart", type="org.openzoom.events.ViewportEvent")]
[Event(name="transformUpdate", type="org.openzoom.events.ViewportEvent")]
[Event(name="transformEnd", type="org.openzoom.events.ViewportEvent")]

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
    function get x() : Number
    function set x( value : Number ) : void
    
    //----------------------------------
    //  y
    //----------------------------------
    
    /**
     * Vertical coordinate of the viewport.
     */
    function get y() : Number
    function set y( value : Number ) : void
    
    //----------------------------------
    //  width
    //----------------------------------
    
    /**
     * Horizontal dimension of the viewport.
     */
    function get width() : Number
//  function set width( value : Number )
    
    //----------------------------------
    //  height
    //----------------------------------
    
    /**
     * Vertical dimension of the viewport.
     */
    function get height() : Number
//  function set height( value : Number )
    
    //----------------------------------
    //  top
    //----------------------------------
    
    /**
     * Coordinate of the upper boundary of the viewport.
     */
    function get top() : Number
    
    //----------------------------------
    //  right
    //----------------------------------
    
    /**
     * Coordinate of the right boundary of the viewport.
     */    
    function get right() : Number
    
    //----------------------------------
    //  bottom
    //----------------------------------
    
    /**
     * Coordinate of the lower boundary of the viewport.
     */ 
    function get bottom() : Number
    
    //----------------------------------
    //  left
    //----------------------------------
    
    /**
     * Coordinate of the left boundary of the viewport.
     */ 
    function get left() : Number
    
    //----------------------------------
    //  viewportWidth
    //----------------------------------
    
    /**
     * Width of the viewport container.
     */ 
    function get viewportWidth() : Number
    
    //----------------------------------
    //  viewportHeight
    //----------------------------------
    
    /**
     * Height of the viewport container.
     */ 
    function get viewportHeight() : Number
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
     
    //----------------------------------
    //  constraint
    //----------------------------------
    
    function get constraint() : IViewportConstraint
    function set constraint( value : IViewportConstraint ) : void
     
    //----------------------------------
    //  animator
    //----------------------------------
    
//    function get animator() : IViewportAnimator
//    function set animator( value : IViewportAnimator ) : void

    //----------------------------------
    //  transform
    //----------------------------------
    
    function get transform() : IViewportTransform
    function set transform( value : IViewportTransform ) : void
        
    //----------------------------------
    //  scene
    //----------------------------------
    
    /**
     * Size of the content in content coordinates.
     */ 
    function get scene() : IMultiScaleScene

    //----------------------------------
    //  scale
    //----------------------------------
    
    /**
     * Scale of the scene.
     */ 
    function get scale() : Number
//  function set scale( value : Number )
      
    //----------------------------------
    //  zoom
    //----------------------------------
    
    /**
     * Zoom level of the viewport.
     * Scene fits exactly into viewport at value 1.
     */
    function get zoom() : Number
    function set zoom( value : Number ) : void
    
    //----------------------------------
    //  minZoom
    //----------------------------------
    
    /**
     * Minimum zoom level.
     */
    function get minZoom() : Number
    function set minZoom( value : Number ) : void
    
    //----------------------------------
    //  maxZoom
    //----------------------------------
    
    /**
     * Maximum zoom level.
     */
    function get maxZoom() : Number
    function set maxZoom( value : Number ) : void

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
    function zoomTo( zoom : Number,
                     transformX : Number = 0.5, transformY : Number = 0.5,
                     dispatchChangeEvent : Boolean = true ) : void
    
    /**
     * Zoom the viewport by a factor.
     * @param factor Multiplier for the zoom.
     * @param transformX Horizontal coordinate of the zooming center
     * @param transformY Vertical coordinate of the zooming center
     */
    function zoomBy( factor : Number,
                     transformX : Number = 0.5, transformY : Number = 0.5,
                     dispatchChangeEvent : Boolean = true ) : void
    
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
    function moveTo( x : Number, y : Number,
                     dispatchChangeEvent : Boolean = true ) : void
    
    /**
     * Move the viewport.
     * @param dx Horizontal translation delta
     * @param dy Vertical translation delta
     */
    function moveBy( dx : Number, dy : Number,
                     dispatchChangeEvent : Boolean = true ) : void
    
    /**
     * Move the viewport center.
     * @param x Horizontal coordinate
     * @param y Vertical coordinate
     */                 
    function moveCenterTo( x : Number, y : Number,
                           dispatchChangeEvent : Boolean = true ) : void
    
    //--------------------------------------------------------------------------
    //
    //  Methods: Navigation
    //
    //--------------------------------------------------------------------------
    
    /**
     * Show a rectangular area of the scene inside the viewport.
     * 
     * @param rect Rectangle to be shown in the viewport.
     * @param scale Scale at which the area is beeing displayed.
     */             
    function showRect( rect : Rectangle, scale : Number = 1.0,
                       dispatchChangeEvent : Boolean = true ) : void
                     
    /**
     * Fit entire scene into the viewport.
     */ 
    function showAll() : void
    
    //--------------------------------------------------------------------------
    //
    //  Methods: Coordinate transformations
    //
    //--------------------------------------------------------------------------

    function localToScene( point : Point ) : Point
    function sceneToLocal( point : Point ) : Point
    
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
    function beginTransform() : void
    	
    /**
     * Dispatch changeComplete event to let all listeners
     * know that a Viewport transition has completed.
     */
    function endTransform() : void	
}

}