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

import org.openzoom.flash.viewport.IViewportConstraint;
import org.openzoom.flash.viewport.IViewportTransform;
import org.openzoom.flash.viewport.IViewportTransformer;
import org.openzoom.flash.viewport.constraints.NullConstraint;

/**
 * TweenerTransformer is an implementation of IViewportTransformer based on the
 * fantastic animation library <a href="http://tweener.googlecode.com/">Tweener</a>.
 * It let's you specify the duration and easing of the animation.
 */
public class TweenerTransformer extends ViewportTransformerBase
                                implements IViewportTransformer
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

    public function set duration(value:Number):void
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

    public function set easing(value:String):void
    {
        _easing = value
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: IViewportTransformer
    //
    //--------------------------------------------------------------------------

    /**
     * @inheritDoc
     */
    override public function transform(target:IViewportTransform,
                                       immediately:Boolean=false):void
    {
    	// apply constrain
    	super.transform(target, immediately)

        if (immediately)
        {
            stop()
            viewport.beginTransform()
            viewport.transform = _target
            viewport.endTransform()
        }
        else
        {
            if (!Tweener.isTweening(viewport))
                viewport.beginTransform()

            Tweener.addTween(
                              viewport,
                              {
                                  _transform_x: _target.x,
                                  _transform_y: _target.y,
                                  _transform_width: _target.width,
                                  time: duration,
                                  transition: easing,
                                  onComplete: viewport.endTransform
                              }
                         )
        }
    }

    /**
     * @inheritDoc
     */
    public function stop():void
    {
        if (Tweener.isTweening(viewport))
        {
            Tweener.removeTweens(viewport)
            viewport.endTransform()
        }
//        if (Tweener.isTweening(tweenTransform))
//        {
//            Tweener.removeTweens(tweenTransform)
//            viewport.endTransform()
//        }
    }
}

}
