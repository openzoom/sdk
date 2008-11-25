////////////////////////////////////////////////////////////////////////////////
//
//  OpenZoom
//
//  Copyright (c) 2007–2008, Daniel Gasienica <daniel@gasienica.ch>
//  Copyright (c) 2008,      Zoomorama
//                           Olivier Gambier <viapanda@gmail.com>
//                           Daniel Gasienica <daniel@gasienica.ch>
//                           Eric Hubscher <erich@zoomorama.com>
//                           David Marteau <dhmarteau@gmail.com>
//  Copyright (c) 2007,      Rick Companje <rick@companje.nl>
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
package org.openzoom.core
{

public class DefaultBoundsStrategy implements IViewportBoundsStrategy
{
	private static const BOUNDS_TOLERANCE : Number = 0.5
	
    public function DefaultBoundsStrategy()
    {
    }
    
    private var _x : Number = 0
    
    public function get x() : Number
    {
    	return _x
    }
    
    private var _y : Number = 0
    
    public function get y() : Number
    {
    	return _y
    }
    
    public function computeBounds( viewport : IReadonlyViewport ) : void
    {
    	_x = viewport.x
    	_y = viewport.y
    	
    	// content is wider than viewport
        if( viewport.width < 1 )
        {
            // horizontal bounds checking:
            // the viewport sticks out on the left:
            // align it with the left margin
            if( viewport.x + viewport.width * BOUNDS_TOLERANCE < 0 )
                _x = -viewport.width * BOUNDS_TOLERANCE
    
           // the viewport sticks out on the right:
           // align it with the right margin
           if(( viewport.x + viewport.width * ( 1 - BOUNDS_TOLERANCE )) > 1 )
               _x = 1 - viewport.width * ( 1 - BOUNDS_TOLERANCE )      
        }
        else
        {
            // viewport is wider than content:
            // center scene horizontally
            _x = ( 1 - viewport.width ) * 0.5
        }
    
        // scene is taller than viewport
        if( viewport.height < 1 )
        {
            // vertical bounds checking:
            // the viewport sticks out at the top:
            // align it with the top margin
            if( viewport.y + viewport.height * BOUNDS_TOLERANCE < 0 )
             _y = -viewport.height * BOUNDS_TOLERANCE
        
            // the viewport sticks out at the bottom:
            // align it with the bottom margin
            if( viewport.y + viewport.height * (1 - BOUNDS_TOLERANCE) > 1 )
              _y = 1 - viewport.height * ( 1 - BOUNDS_TOLERANCE )
        }
        else
        {
            // viewport is taller than scene
            // center scene vertically
            _y = ( 1 - viewport.height ) * 0.5
        } 
    }
}

}