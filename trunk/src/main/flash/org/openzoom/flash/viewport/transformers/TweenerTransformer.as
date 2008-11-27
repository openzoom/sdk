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

import caurina.transitions.Tweener;

import org.openzoom.flash.viewport.INormalizedViewport;
import org.openzoom.flash.viewport.ITransformationTarget;
import org.openzoom.flash.viewport.IViewportTransform;
import org.openzoom.flash.viewport.IViewportTransformer;
    
public class TweenerTransformer implements IViewportTransformer
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------
    
    private static const DEFAULT_DURATION : Number = 2.0
    private static const DEFAULT_EASING : String = "easeOutExpo"
    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     * Constructor.
     */
    public function TweenerTransformer()
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
    
    private var _viewport : INormalizedViewport
    
    public function get viewport() : INormalizedViewport
    {
    	return _viewport
    }
    
    public function set viewport( value : INormalizedViewport ) : void
    {
        _viewport = value	
    }
     
    //----------------------------------
    //  target
    //----------------------------------
    
    private var _target : ITransformationTarget
    
    public function get target() : ITransformationTarget
    {
    	return _target
    }
    
    public function set target( value : ITransformationTarget ) : void
    {
        _target = value	
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods: IViewportTransformer
    //
    //--------------------------------------------------------------------------
    
    public function transform( targetTransform : IViewportTransform,
                               immediately : Boolean = false ) : void
    {
        var newWidth   : Number = viewport.viewportWidth / viewport.width
        var newHeight  : Number = viewport.viewportHeight / viewport.height
        var newX       : Number = -viewport.x * newWidth
        var newY       : Number = -viewport.y * newHeight
        
        if( immediately )
        {
	        viewport.beginTransform()
	        view.x = newX
	        view.y = newY
	        view.width = newWidth
	        view.height = newHeight
	        viewport.endTransform()
        }
        else
        {
	        Tweener.addTween( 
	                          target,
	                          {
                                  x: newX,
	                              y: newY,
	                              width: newWidth,
	                              height: newHeight,
	                              time: DEFAULT_DURATION,
	                              transition: DEFAULT_EASING,
	                              onStart: viewport.beginTransform,   
	                              onComplete: viewport.endTransform
	                          }
	                        )
        }
        
    }
}

}