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

import org.openzoom.flash.viewport.INormalizedViewport;
import org.openzoom.flash.viewport.ITransformerViewport;
import org.openzoom.flash.viewport.IViewportTransform;
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
    //  Properties: IViewportTransformer
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  viewport
    //----------------------------------
    
    private var _viewport : ITransformerViewport
    
    public function get viewport() : ITransformerViewport
    {
    	return _viewport
    }
    
    public function set viewport( value : ITransformerViewport ) : void
    {
    	_viewport = value
    }
    
    //----------------------------------
    //  transformTarget
    //----------------------------------
    
    public function get transformTarget() : IViewportTransform
    {
        return viewport.transform
    }
    
    public function set transformTarget( value : IViewportTransform ) : void
    {
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods: IViewportTransformer
    //
    //--------------------------------------------------------------------------
    
    public function stop() : void
    {
    	// Do nothing
    }
    
    public function transform( sourceTransform : IViewportTransform,
                               targetTransform : IViewportTransform ) : void
    {
    	viewport.beginTransform()
    	viewport.transform = targetTransform
    	viewport.endTransform()
    }
}

}