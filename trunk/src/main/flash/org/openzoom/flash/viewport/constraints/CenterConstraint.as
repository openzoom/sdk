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
package org.openzoom.flash.viewport.constraints
{

import org.openzoom.flash.viewport.IViewportConstraint;
import org.openzoom.flash.viewport.IViewportTransform;

/**
 * Centers the scene once it is all visible.
 */
public class CenterConstraint implements IViewportConstraint
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function CenterConstraint()
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
    public function validate( transform:IViewportTransform,
                              target:IViewportTransform ):IViewportTransform
    {
        var x:Number = transform.x
        var y:Number = transform.y

        if( transform.width >= 1 )
        {
            // viewport is wider than scene,
            // center scene horizontally
            x = ( 1 - transform.width ) * 0.5
        }

        if( transform.height >= 1 )
        {
            // viewport is taller than scene,
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