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
import org.openzoom.flash.viewport.IViewportConstraint;
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
    private static const DEFAULT_EASING   : String = "easeOutExpo"
//    private static const NULL_CONSTRAINT : IViewportConstraint = new NullViewportConstraint()
    
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
    	TransformShortcuts.init()
    }
    
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
//    private var tweenTransform : IViewportTransform
    
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
        _targetTransform = viewport.transform
//        tweenTransform   = viewport.transform
    }
    
    //----------------------------------
    //  constraint
    //----------------------------------
    
    private var _constraint : IViewportConstraint
    
    public function get constraint() : IViewportConstraint
    {
        return _constraint
    }
    
    public function set constraint( value : IViewportConstraint ) : void
    {
        _constraint = value
    }
    
    //----------------------------------
    //  target
    //----------------------------------
    
    private var _targetTransform : IViewportTransform
    
    public function get targetTransform() : IViewportTransform
    {
        return _targetTransform.clone()
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods: IViewportTransformer
    //
    //--------------------------------------------------------------------------
    
    public function stop() : void
    {
    	if( Tweener.isTweening( viewport ))
    	{
    	    Tweener.removeTweens( viewport )
	        viewport.endTransform()
    	}
//    	if( Tweener.isTweening( tweenTransform ))
//    	{
//    	    Tweener.removeTweens( tweenTransform )
//	        viewport.endTransform()
//    	}
    }
    
    public function transform( targetTransform : IViewportTransform,
                               immediately : Boolean = false ) : void
    {
        // copy targetTransform to know where to tween to…
        _targetTransform = targetTransform.clone()
        
        if( immediately )
        {
        	stop()
        	viewport.beginTransform()
        	viewport.transform = _targetTransform
        	viewport.endTransform()
        	
        	// update tween transform
//        	tweenTransform.copy( ViewportTransform2( viewport.transform ))
        }
    	else
        {                
            // BEGIN: TRANSFORMSHORTCUTS
            
	        if( !Tweener.isTweening( viewport ))
                viewport.beginTransform()
	            
	        Tweener.addTween( 
	                          viewport,
	                          {
	                              _transform_x: targetTransform.x,
	                              _transform_y: targetTransform.y,
	                              _transform_width: targetTransform.width,
//                                  _transform_height: targetTransform.height,
	                              time: DEFAULT_DURATION,
	                              transition: DEFAULT_EASING,
	                              onComplete: viewport.endTransform
	                          }
	                        )
	                        
            // END: TRANSFORMSHORTCUTS
            
                            
            // BEGIN: THE GOOD WAY.	                        
//
//            if( !Tweener.isTweening( tweenTransform ))
//                viewport.beginTransform()
//                
//        	// update tween transform
//        	tweenTransform.copy( ViewportTransform2( viewport.transform ))
//            
//            Tweener.addTween(
//                                tweenTransform,
//                                {
//                                    x: targetTransform.x,
//                                    y: targetTransform.y,
//                                    width: targetTransform.width,
////                                    height: targetTransform.height,
//                                    time: DEFAULT_DURATION,
//                                    transition: DEFAULT_EASING,
//                                    onUpdate:
//                                    function() : void
//                                    {
//                                        viewport.transform = tweenTransform
//                                    },
//                                    onComplete: viewport.endTransform
//                                }
//                            )
            // END: THE GOOD WAY.	                        
        }
    }
}

}