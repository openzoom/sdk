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

[DefaultProperty("constraints")]
/**
 * CompositeConstraint allows you to apply many different constraints
 * at the same time. This class is an implementation of the
 * Composite Design Pattern by the GoF.
 */
public class CompositeConstraint implements IViewportConstraint
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
	/**
	 * Constructor.
	 */
    public function CompositeConstraint()
    {
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  constraints
    //----------------------------------
    
    private var _constraints : Array /* of IViewportConstraint */ = []
    
   ;[ArrayElementType("org.openzoom.flash.viewport.IViewportConstraint")]
    /**
     * An array of constraints that are applied succe
     */
    public function get constraints() : Array
    {
    	return _constraints.slice( 0 )
    }
    
    public function set constraints( value : Array ) : void
    {
    	_constraints = value.slice( 0 )
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
    	for each( var constraint : IViewportConstraint in constraints )
    		transform = constraint.validate( transform )

        return transform
    }
}

}