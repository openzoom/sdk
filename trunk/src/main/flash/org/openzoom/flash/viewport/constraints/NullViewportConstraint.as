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

import org.openzoom.flash.viewport.IReadonlyViewport;
import org.openzoom.flash.viewport.IViewportConstraint;

/**
 * Null Object Pattern applied to IViewportConstraint.
 */
public class NullViewportConstraint implements IViewportConstraint
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------
    
    private static const DEFAULT_MIN_ZOOM : Number = 0.001
    private static const DEFAULT_MAX_ZOOM : Number = Number.MAX_VALUE
	
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
    public function NullViewportConstraint()
    {
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties: IViewportConstraint
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  minZoom
    //----------------------------------

    public function get minZoom() : Number
    {
        return DEFAULT_MIN_ZOOM
    }

    public function set minZoom( value : Number ) : void
    {
    	// Do nothing
    }

    //----------------------------------
    //  maxZoom
    //----------------------------------
    
    public function get maxZoom() : Number
    {
        return DEFAULT_MAX_ZOOM
    }
    
    public function set maxZoom( value : Number ) : void
    {
    	// Do nothing
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods: IViewportConstraint
    //
    //--------------------------------------------------------------------------
    
    public function computePosition( viewport : IReadonlyViewport ) : Point
    {
        return new Point( viewport.x, viewport.y )
    }
}

}