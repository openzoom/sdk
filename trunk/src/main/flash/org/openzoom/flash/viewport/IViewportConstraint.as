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

/**
 * Interface for IViewportTransform constraints, e.g. use constraints to
 * limit maximum and minimum zoom of the viewport or ensure it moves within
 * certain bounds.
 */
public interface IViewportConstraint
{
    /**
     * Validate the viewport transform by performing transformations until
     * it validates all constraints.
     *
     * @param transform IViewportTransform object to be validated.
     * @param target IViewportTransform object that represents the last validated transform.
     *
     * @return Validated IViewportTransform object.
     */
    function validate( transform : IViewportTransform,
                       target : IViewportTransform ) : IViewportTransform
}

}