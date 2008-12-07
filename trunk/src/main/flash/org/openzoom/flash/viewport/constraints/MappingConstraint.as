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
package org.openzoom.flash.viewport.constraints
{

import org.openzoom.flash.viewport.IViewportConstraint;
import org.openzoom.flash.viewport.IViewportTransform;

/**
 * Viewport constraint that ensures that the viewport only reaches zoom
 * values that are powers of two. Very useful for mapping application where
 * map tiles contain text labels and best look at scales that are power of two.
 */
public class MappingConstraint implements IViewportConstraint
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------
    
    private static const DEFAULT_CONSTRAINT : IViewportConstraint = new DefaultConstraint()
   
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
    public function MappingConstraint()
    {
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods: IViewportConstraint
    //
    //--------------------------------------------------------------------------
    
    /**
     * @inheritDoc
     */ 
    public function validate( transform : IViewportTransform ) : IViewportTransform
    {
        var validatedTransform : IViewportTransform = DEFAULT_CONSTRAINT.validate( transform )        
        
        // snap to scale that are powers of two
        // most map tiles look best that way
        var exp : Number = Math.round( Math.log( validatedTransform.scale ) / Math.LN2 )
        var scale : Number = Math.pow( 2, exp )
        validatedTransform.scale = scale
        
        return validatedTransform
    }
}

}