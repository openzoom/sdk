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
 * Provides basic bounds checking by ensuring that a certain ratio of the scene
 * is always visible.
 */
public class VisibilityConstraint implements IViewportConstraint
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------
    
	private static const DEFAULT_VISIBILITY_RATIO : Number = 0.2
	
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
    public function VisibilityConstraint()
    {
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  visibilityRatio
    //----------------------------------
    
    private var _visibilityRatio : Number = 1 - DEFAULT_VISIBILITY_RATIO
    

    /**
     * Indicates the minimal ratio that has to visible of the scene.
     */
    public function get visibilityRatio() : Number
    {
        return _visibilityRatio
    }
    
    public function set visibilityRatio( value : Number ) : void
    {
       _visibilityRatio = 1 - value
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
    	var x : Number = transform.x
    	var y : Number = transform.y
    	
    	// content is wider than viewport
        if( transform.width < 1 )
        {
            // horizontal bounds checking:
            // the viewport sticks out on the left:
            // align it with the left margin
            if( transform.x + transform.width * ( 1 - visibilityRatio ) < 0 )
                x = -transform.width * ( 1 - visibilityRatio )
    
           // the viewport sticks out on the right:
           // align it with the right margin
           if( transform.x + transform.width * visibilityRatio > 1 )
               x = 1 - transform.width * visibilityRatio      
        }
        else
        {
            // viewport is wider than content:
            // center scene horizontally
            x = ( 1 - transform.width ) * 0.5
        }
    
        // scene is taller than viewport
        if( transform.height < 1 )
        {
            // vertical bounds checking:
            // the viewport sticks out at the top:
            // align it with the top margin
            if( transform.y + transform.height * ( 1 - visibilityRatio ) < 0 )
                y = -transform.height * ( 1 - visibilityRatio )
        
            // the viewport sticks out at the bottom:
            // align it with the bottom margin
            if( transform.y + transform.height * visibilityRatio > 1 )
                y = 1 - transform.height * visibilityRatio
        }
        else
        {
            // viewport is taller than scene
            // center scene vertically
            y = ( 1 - transform.height ) * 0.5
        }
        
        // validate bounds
        transform.panTo( x, y )

        // return validated transform
        return transform
    }
}

}