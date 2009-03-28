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
package org.openzoom.flash.viewport.transformers
{

import caurina.transitions.Tweener;

import org.openzoom.flash.viewport.ITransformerViewport;
import org.openzoom.flash.viewport.IViewportConstraint;
import org.openzoom.flash.viewport.IViewportTransform;
import org.openzoom.flash.viewport.IViewportTransformer;
import org.openzoom.flash.viewport.constraints.NullConstraint;

/**
 * TweenerTransformer is an implementation of IViewportTransformer based on the
 * fantastic animation library <a href="http://tweener.googlecode.com/">Tweener</a>.
 * It let's you specify the duration and easing of the animation.
 */
public class TweenerTransformer implements IViewportTransformer
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    private static const DEFAULT_DURATION:Number = 1.5
    private static const DEFAULT_EASING:String = "easeOutExpo"
    private static const NULL_CONSTRAINT:IViewportConstraint = new NullConstraint()

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
        TweenerTransformShortcuts.init()
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

//    private var tweenTransform:IViewportTransform

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  duration
    //----------------------------------

    private var _duration:Number = DEFAULT_DURATION

//   ;[Bindable]
    /**
     * Duration of the transformation in seconds
     *
     * @default 1.5
     */
    public function get duration():Number
    {
        return _duration
    }

    public function set duration( value:Number ):void
    {
        _duration = value
    }

    //----------------------------------
    //  easing
    //----------------------------------

    private var _easing:String = DEFAULT_EASING

//   ;[Inspectable(defaultValue="easeOutExpo",
//                 type="String",
//                 enumeration="linear,easeInSine,easeOutSine,easeInOutSine,easeInCubic,easeOutCubic,easeInOutCubic,easeInQuint,easeOutQuint,easeInOutQuint,easeInCirc,easeOutCirc,easeInOutCirc,easeInBack,easeOutBack,easeInOutBack,easeInQuad,easeOutQuad,easeInOutQuad,easeInQuart,easeOutQuart,easeInOutQuart,easeInExpo,easeOutExpo,easeInOutExpo,easeInElastic,easeOutElastic,easeInOutElastic,easeInBounce,easeOutBounce,easeInOutBounce")]
//   ;[Bindable]
    /**
     * Easing for the transformation.
     *
     * @default easeOutExpo
     * @see http://hosted.zeh.com.br/tweener/docs/en-us/misc/transitions.html
     */
    public function get easing():String
    {
        return _easing
    }

    public function set easing( value:String ):void
    {
        _easing = value
    }

    //--------------------------------------------------------------------------
    //
    //  Properties: IViewportTransformer
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  viewport
    //----------------------------------

    private var _viewport:ITransformerViewport

    /**
     * @inheritDoc
     */
    public function get viewport():ITransformerViewport
    {
        return _viewport
    }

    public function set viewport( value:ITransformerViewport ):void
    {
        _viewport = value

        if( value )
            _target = viewport.transform
        else
            _target = null
//        tweenTransform   = viewport.transform
    }

    //----------------------------------
    //  constraint
    //----------------------------------

    private var _constraint:IViewportConstraint = NULL_CONSTRAINT

    /**
     * @inheritDoc
     */
    public function get constraint():IViewportConstraint
    {
        return _constraint
    }

    public function set constraint( value:IViewportConstraint ):void
    {
        if( value )
            _constraint = value
        else
            _constraint = NULL_CONSTRAINT
    }

    //----------------------------------
    //  target
    //----------------------------------

    private var _target:IViewportTransform

    /**
     * @inheritDoc
     */
    public function get target():IViewportTransform
    {
        return _target.clone()
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: IViewportTransformer
    //
    //--------------------------------------------------------------------------

    /**
     * @inheritDoc
     */
    public function stop():void
    {
        if( Tweener.isTweening( viewport ))
        {
            Tweener.removeTweens( viewport )
            viewport.endTransform()
        }
//        if( Tweener.isTweening( tweenTransform ))
//        {
//            Tweener.removeTweens( tweenTransform )
//            viewport.endTransform()
//        }
    }

    /**
     * @inheritDoc
     */
    public function transform( target:IViewportTransform,
                               immediately:Boolean = false ):void
    {
        // Copy target and validate to know where to tween to...
        var previousTarget:IViewportTransform = this.target
        _target = constraint.validate( target.clone(), previousTarget )

        if( immediately )
        {
            stop()
            viewport.beginTransform()
            viewport.transform = _target
            viewport.endTransform()

            // update tween transform
//            tweenTransform.copy( ViewportTransform2( viewport.transform ))
        }
        else
        {
            // BEGIN: TRANSFORMSHORTCUTS

            if( !Tweener.isTweening( viewport ))
                viewport.beginTransform()

            Tweener.addTween(
                              viewport,
                              {
                                  _transform_x: _target.x,
                                  _transform_y: _target.y,
                                  _transform_width: _target.width,
//                                  _transform_height: _targetTransform.height,
                                  time: duration,
                                  transition: easing,
                                  onComplete: viewport.endTransform
                              }
                            )

            // END: TRANSFORMSHORTCUTS


            // BEGIN: THE GOOD WAY.
//
//            if( !Tweener.isTweening( tweenTransform ))
//                viewport.beginTransform()
//
//            // update tween transform
//            tweenTransform.copy( ViewportTransform2( viewport.transform ))
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
//                                    function():void
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