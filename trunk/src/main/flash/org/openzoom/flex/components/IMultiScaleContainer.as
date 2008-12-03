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
package org.openzoom.flex.components
{

import org.openzoom.flash.scene.IMultiScaleScene;
import org.openzoom.flash.viewport.INormalizedViewport;
import org.openzoom.flash.viewport.IViewportConstraint;
import org.openzoom.flash.viewport.IViewportTransformer;
	
public interface IMultiScaleContainer
{
    /**
     * Multi-scale scene belonging to this container.
     */
    function get scene() : IMultiScaleScene
    
    /**
     * Width of the scene belonging to this container.
     */
    function get sceneWidth() : Number	
    function set sceneWidth( value : Number ) : void
    	
    /**
     * Height of the scene belonging to this container.
     */
    function get sceneHeight() : Number	
    function set sceneHeight( value : Number ) : void
    
    /**
     * Viewport belonging to this container.
     */
    function get viewport() : INormalizedViewport
    
    /**
     * Viewport constraint.
     */ 
//    function get constraint() : IViewportConstraint
//    function set constraint( value : IViewportConstraint ) : void
    
    /**
     * Viewport transformer.
     */
    function get transformer() : IViewportTransformer
    function set transformer( value : IViewportTransformer ) : void
}

}