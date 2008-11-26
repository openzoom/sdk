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

import flash.display.DisplayObject;
import flash.events.IEventDispatcher;

[Event(name="resize", type="flash.events.Event")]

/**
 * Interface for the viewport content.
 */
public interface IMultiScaleScene extends IEventDispatcher
{
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
  
    //----------------------------------
    //  sceneWidth
    //----------------------------------
    
    /**
     * Indicates the width of the scene, in pixels.
     */
    function get sceneWidth() : Number
    function set sceneWidth( value : Number ) : void
  
    //----------------------------------
    //  sceneHeight
    //----------------------------------
    
    /**
     * Indicates the height of the scene, in pixels.
     */
    function get sceneHeight() : Number
    function set sceneHeight( value : Number ) : void
    
    //----------------------------------
    //  targetCoordinateSpace
    //----------------------------------
    
    /**
     * The display object that defines the coordinate system to use.
     * This is mainly used for renderers that want to compute their
     * bounds with DisplayObject::getBounds relative to the scene
     * they are contained in.
     */ 
    function get targetCoordinateSpace() : DisplayObject
}

}