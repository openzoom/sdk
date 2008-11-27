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

import flash.geom.Rectangle;

import org.openzoom.flash.viewport.INormalizedViewport;
import org.openzoom.flash.viewport.IViewportTransformationTarget;
import org.openzoom.flash.viewport.IViewportTransformer;

public class TweenerViewportTransformer implements IViewportTransformer
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
    public function TweenerViewportTransformer()
    {
    } 
    
    //--------------------------------------------------------------------------
    //
    //  Methods: IViewportTransformer
    //
    //--------------------------------------------------------------------------
    
    private var target : IViewportTransformationTarget
    
    public function stop() : void
    {
    	if( target )
            Tweener.removeTweens( target )
    }
    
    public function transform( viewport : INormalizedViewport,
                               target : IViewportTransformationTarget,
                               bounds : Rectangle,
                               immediately : Boolean = false ) : void
    {
    	this.target = target
    	
        if( immediately )
        {
        	Tweener.removeTweens( target )
	        viewport.beginTransform()
	        target.x = bounds.x
	        target.y = bounds.y
	        target.width = bounds.width
	        target.height = bounds.height
	        viewport.endTransform()
	        this.target = null
        }
        else
        {
	        Tweener.addTween( 
	                          target,
	                          {
                                  x: bounds.x,
	                              y: bounds.y,
	                              width: bounds.width,
	                              height: bounds.height,
	                              time: DEFAULT_DURATION,
	                              transition: DEFAULT_EASING,
	                              onStart: viewport.beginTransform,
	                              onComplete:
	                              function() : void
	                              {
                                      viewport.endTransform()
                                      this.target = null
                                  }
	                          }
	                        )
        }
        
    }
}

}