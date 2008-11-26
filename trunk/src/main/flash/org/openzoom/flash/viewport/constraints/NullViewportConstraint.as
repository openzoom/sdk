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
    
    private static const DEFAULT_MIN_Z : Number = 0.0
    private static const DEFAULT_MAX_Z : Number = Infinity
	
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
    //  minZ
    //----------------------------------

    protected var _minZ : Number = DEFAULT_MIN_Z

    public function get minZoom() : Number
    {
        return _minZ
    }

    public function set minZoom( value : Number ) : void
    {
        _minZ = value
    }

    //----------------------------------
    //  maxZ
    //----------------------------------
    
    protected var _maxZ : Number = DEFAULT_MAX_Z
    
    public function get maxZoom() : Number
    {
        return _maxZ
    }
    
    public function set maxZoom( value : Number ) : void
    {
       _maxZ = value
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