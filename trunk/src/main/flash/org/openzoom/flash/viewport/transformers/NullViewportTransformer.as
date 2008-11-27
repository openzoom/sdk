////////////////////////////////////////////////////////////////////////////////
//
//  OpenZoom
//
//  Copyright (c) 2008, Daniel Gasienica <daniel@gasienica.ch>
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
package org.openzoom.flash.viewport.transformers
{

import flash.geom.Rectangle;

import org.openzoom.flash.viewport.INormalizedViewport;
import org.openzoom.flash.viewport.IViewportTransformationTarget;
import org.openzoom.flash.viewport.IViewportTransformer;   

public class NullViewportTransformer implements IViewportTransformer
{    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     * Constructor.
     */
    public function NullViewportTransformer()
    {
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods: IViewportTransformer
    //
    //--------------------------------------------------------------------------
    
    public function stop() : void
    {
    }
    
    public function transform( viewport : INormalizedViewport,
                               target : IViewportTransformationTarget,
                               bounds : Rectangle,
                               immediately : Boolean = false ) : void
    {
        target.x      = bounds.x
        target.y      = bounds.y
        target.width  = bounds.width
        target.height = bounds.height
    }
}

}