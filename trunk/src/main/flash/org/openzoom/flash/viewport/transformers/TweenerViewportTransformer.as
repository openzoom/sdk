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

import org.openzoom.flash.viewport.ITransformerViewport;
import org.openzoom.flash.viewport.IViewportTransform;
import org.openzoom.flash.viewport.IViewportTransformer;

public class TweenerViewportTransformer implements IViewportTransformer
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------
    
    private static const DEFAULT_DURATION : Number = 1.5
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
    
//    //----------------------------------
//    //  target
//    //----------------------------------
//    
//    private var _target : IViewportTransformationTarget
//    
//    public function get target() : IViewportTransformationTarget
//    {
//        return _target
//    }
//    
//    public function set target( value : IViewportTransformationTarget ) : void
//    {
//        _target = value
//    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods: IViewportTransformer
    //
    //--------------------------------------------------------------------------
    
    private var target : IViewportTransform
    
    public function stop() : void
    {
    	if( target)
    	    Tweener.removeTweens( target )
//	        viewport.endTransform()
    }
    
    public function transform( sourceTransform : IViewportTransform,
                               targetTransform : IViewportTransform ) : void
    {
    	target = sourceTransform
        Tweener.addTween( 
                          target,
                          {
                              x: targetTransform.x,
                              y: targetTransform.y,
                              width: targetTransform.width,
                              height: targetTransform.height,
                              time: DEFAULT_DURATION,
                              transition: DEFAULT_EASING,
//                              onStart: viewport.beginTransform,
                              onUpdate:
                              function() : void
                              {
                                  viewport.transform = target     
                              },
                              onComplete: viewport.endTransform
                          }
                        )
    }
}

}