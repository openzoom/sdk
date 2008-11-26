////////////////////////////////////////////////////////////////////////////////
//
//  OpenZoom
//  Copyright (c) 2008, Daniel Gasienica <daniel@gasienica.ch>
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

import flash.geom.Rectangle;	

/**
 * Interface for enabling more expressive animation of the viewport.
 */
public interface IViewportTransform
{  
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    function get scene() : IReadonlyMultiScaleScene
    
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
//    function set width( value : Number ) : void
    
    //----------------------------------
    //  height
    //----------------------------------
    
    /**
     * Vertical dimension of the viewport.
     */
    function get height() : Number
//    function set height( value : Number ) : void
    
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
    function get scale() : Number
//  function set scale( value : Number ) : void
      
    //----------------------------------
    //  zoom
    //----------------------------------
    
    /**
     * Zoom level of the viewport.
     * Scene fits exactly into viewport at value 1.
     */
    function get zoom() : Number
    function set zoom( value : Number ) : void

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
    function zoomTo( zoom : Number,
                     transformX : Number = 0.5,
                     transformY : Number = 0.5 ) : void
    
    /**
     * Zoom the viewport by a factor.
     * @param factor Scale factor for the zoom.
     * @param transformX Horizontal coordinate of the zooming center
     * @param transformY Vertical coordinate of the zooming center
     */
    function zoomBy( factor : Number,
                     transformX : Number = 0.5,
                     transformY : Number = 0.5 ) : void
    
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
    function moveTo( x : Number, y : Number ) : void
    
    /**
     * Move the viewport.
     * @param dx Horizontal translation delta
     * @param dy Vertical translation delta
     */
    function moveBy( dx : Number, dy : Number ) : void
    
    /**
     * Move the viewport center.
     * @param x Horizontal coordinate
     * @param y Vertical coordinate
     */                 
    function moveCenterTo( x : Number, y : Number ) : void
    
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
    function showRect( rect : Rectangle, scale : Number = 1.0 ) : void
                     
    /**
     * Fit entire scene into the viewport.
     */ 
    function showAll() : void
    
    //--------------------------------------------------------------------------
    //
    //  Methods: Coordinate transformations
    //
    //--------------------------------------------------------------------------

//    function localToScene( point : Point ) : Point
//    function sceneToLocal( point : Point ) : Point

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    function clone() : IViewportTransform
}

}