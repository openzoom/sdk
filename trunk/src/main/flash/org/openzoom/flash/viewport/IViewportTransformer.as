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

import flash.geom.Rectangle;
	
public interface IViewportTransformer
{
//    function setTargetTransform( value : IViewportTransform ) : void

	function get targetTransform() : IViewportTransform
	function set targetTransform( value : IViewportTransform ) : void
	
	function get viewport() : ITransformerViewport
	function set viewport( value : ITransformerViewport ) : void
	
//	function get target() : IViewportTransformationTarget
//	function set target( value : IViewportTransformationTarget ) : void
	
	function stop() : void
	
    function transform( sourceTransform : IViewportTransform,
                        targetTransform : IViewportTransform ) : void		
}

}