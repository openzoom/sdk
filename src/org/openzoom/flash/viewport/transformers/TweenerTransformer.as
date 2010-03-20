////////////////////////////////////////////////////////////////////////////////
//
//  OpenZoom SDK
//
//  Version: MPL 1.1/GPL 3/LGPL 3
//
//  The contents of this file are subject to the Mozilla Public License Version
//  1.1 (the "License"); you may not use this file except in compliance with
//  the License. You may obtain a copy of the License at
//  http://www.mozilla.org/MPL/
//
//  Software distributed under the License is distributed on an "AS IS" basis,
//  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
//  for the specific language governing rights and limitations under the
//  License.
//
//  The Original Code is the OpenZoom SDK.
//
//  The Initial Developer of the Original Code is Daniel Gasienica.
//  Portions created by the Initial Developer are Copyright (c) 2007-2010
//  the Initial Developer. All Rights Reserved.
//
//  Contributor(s):
//    Daniel Gasienica <daniel@gasienica.ch>
//
//  Alternatively, the contents of this file may be used under the terms of
//  either the GNU General Public License Version 3 or later (the "GPL"), or
//  the GNU Lesser General Public License Version 3 or later (the "LGPL"),
//  in which case the provisions of the GPL or the LGPL are applicable instead
//  of those above. If you wish to allow use of your version of this file only
//  under the terms of either the GPL or the LGPL, and not to allow others to
//  use your version of this file under the terms of the MPL, indicate your
//  decision by deleting the provisions above and replace them with the notice
//  and other provisions required by the GPL or the LGPL. If you do not delete
//  the provisions above, a recipient may use your version of this file under
//  the terms of any one of the MPL, the GPL or the LGPL.
//
////////////////////////////////////////////////////////////////////////////////
package org.openzoom.flash.viewport.transformers
{

import caurina.transitions.Tweener;

import org.openzoom.flash.core.openzoom_internal;
import org.openzoom.flash.viewport.IViewportConstraint;
import org.openzoom.flash.viewport.IViewportTransform;
import org.openzoom.flash.viewport.IViewportTransformer;
import org.openzoom.flash.viewport.constraints.NullConstraint;

use namespace openzoom_internal;

/**
 * TweenerTransformer is an implementation of IViewportTransformer based on the
 * fantastic animation library <a href="http://tweener.googlecode.com/">Tweener</a>.
 * It let's you specify the duration and easing of the animation.
 */
public final class TweenerTransformer extends ViewportTransformerBase
                                      implements IViewportTransformer
{
	include "../../core/Version.as"

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
    }
}

}
