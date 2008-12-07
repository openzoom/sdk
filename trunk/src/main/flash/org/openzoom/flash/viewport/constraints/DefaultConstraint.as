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

import flash.geom.Point;

import org.openzoom.flash.viewport.IViewportConstraint;
import org.openzoom.flash.viewport.IViewportTransform;

/**
 * Default implementation of the IViewportConstraint interface.
 * Provides basic bounds checking and imposes limits on the zoom property
 * of the viewport.
 */
public class DefaultConstraint implements IViewportConstraint
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------
    
    private static const DEFAULT_MIN_ZOOM : Number = 0.25
    private static const DEFAULT_MAX_ZOOM : Number = 10000
	private static const BOUNDS_TOLERANCE : Number = 0.5
	
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
    public function DefaultConstraint()
    {
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  minZoom
    //----------------------------------

    private var _minZoom : Number = DEFAULT_MIN_ZOOM

    /**
     * Minimum zoom the viewport can reach.
     */ 
    public function get minZoom() : Number
    {
        return _minZoom
    }

    public function set minZoom( value : Number ) : void
    {
        _minZoom = value
    }

    //----------------------------------
    //  maxZoom
    //----------------------------------
    
    private var _maxZoom : Number = DEFAULT_MAX_ZOOM
    

    /**
     * Maximum zoom the viewport can reach.
     */
    public function get maxZoom() : Number
    {
        return _maxZoom
    }
    
    public function set maxZoom( value : Number ) : void
    {
       _maxZoom = value
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
            if( transform.x + transform.width * BOUNDS_TOLERANCE < 0 )
                x = -transform.width * BOUNDS_TOLERANCE
    
           // the viewport sticks out on the right:
           // align it with the right margin
           if(( transform.x + transform.width * ( 1 - BOUNDS_TOLERANCE )) > 1 )
               x = 1 - transform.width * ( 1 - BOUNDS_TOLERANCE )      
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
            if( transform.y + transform.height * BOUNDS_TOLERANCE < 0 )
                y = -transform.height * BOUNDS_TOLERANCE
        
            // the viewport sticks out at the bottom:
            // align it with the bottom margin
            if( transform.y + transform.height * (1 - BOUNDS_TOLERANCE) > 1 )
                y = 1 - transform.height * ( 1 - BOUNDS_TOLERANCE )
        }
        else
        {
            // viewport is taller than scene
            // center scene vertically
            y = ( 1 - transform.height ) * 0.5
        }
        
        // validate bounds
        transform.panTo( x, y )
        
        // validate zoom
        if( transform.zoom > maxZoom )
            transform.zoomTo( maxZoom )
            
        if( transform.zoom < minZoom )
            transform.zoomTo( minZoom )
        
        // return validated transform
        return transform
    }
}

}