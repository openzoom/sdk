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

/**
 * Interface for viewport transformers.
 */
public interface IViewportTransformer
{
    /**
     * Target viewport to transform.
     */
    function get viewport() : ITransformerViewport
    function set viewport( value : ITransformerViewport ) : void
    
	/**
	 * Target viewport transform.
	 */
	function get target() : IViewportTransform
	
	/**
	 * Constraint for target transform.
	 */
	function get constraint() : IViewportConstraint
	function set constraint( value : IViewportConstraint ) : void
	
    /**
     * Transform viewport to target transform.
     */ 	
    function transform( target : IViewportTransform,
                        immediately : Boolean = false ) : void
                        
    /**
     * Stop viewport transformation.
     */ 
	function stop() : void
}

}