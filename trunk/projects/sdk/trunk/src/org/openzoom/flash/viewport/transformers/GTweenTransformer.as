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

//import com.gskinner.motion.GTween;

import flash.events.Event;

import org.openzoom.flash.viewport.INormalizedViewport;
import org.openzoom.flash.viewport.IViewportTransformer;
import org.openzoom.flash.viewport.IViewportTransform;

/**
 * @private
 */
public class GTweenTransformer// implements IViewportTransformer
{
//    //--------------------------------------------------------------------------
//    //
//    //  Class constants
//    //
//    //--------------------------------------------------------------------------
//
//    private static const DEFAULT_DURATION:Number = 2.0
//    private static const DEFAULT_EASING:String = "easeOutExpo"
//
//    private var tween:GTween
//
//    private static function easeOutExpo(t:Number, b:Number, c:Number, d:Number):Number
//    {
//        return (t==d) ? b+c : c * 1.001 * (-Math.pow(2, -10 * t/d) + 1) + b;
//    }
//
//
//    //--------------------------------------------------------------------------
//    //
//    //  Constructor
//    //
//    //--------------------------------------------------------------------------
//
//    /**
//     * Constructor.
//     */
//    public function GTweenViewportTransformer(viewport:INormalizedViewport)
//    {
//        _viewport = viewport
//        tween = new GTween(viewport.transform, DEFAULT_DURATION)
//        tween.ease = easeOutExpo
//        tween.useSetSize = false
//        tween.setAssignment(viewport, "transform")
//        tween.addEventListener(Event.INIT, function():void { viewport.beginTransform(); })
//        tween.addEventListener(Event.COMPLETE, function():void { viewport.endTransform(); })
//    }
//
//    //--------------------------------------------------------------------------
//    //
//    //  Properties: IViewportAnimator
//    //
//    //--------------------------------------------------------------------------
//
//    private var _viewport:INormalizedViewport
//
//    public function get viewport():INormalizedViewport
//    {
//        return _viewport
//    }
//
//    public function set viewport(value:INormalizedViewport):void
//    {
//        _viewport = value
//    }
//
//    //--------------------------------------------------------------------------
//    //
//    //  Methods: IViewportAnimator
//    //
//    //--------------------------------------------------------------------------
//
//    public function transform(viewport:INormalizedViewport,
//                             targetTransform:IViewportTransform):void
//    {
//        var duration:Number = DEFAULT_DURATION
//        var transition:String = DEFAULT_EASING
//
//        tween.proxy.x = targetTransform.x
//        tween.proxy.y = targetTransform.y
//        tween.proxy.width = targetTransform.width
//        tween.proxy.height = targetTransform.height
//
////        if (tween)
////            tween.reset()
////        tween = new GTween(
////                            viewport.transform,
////                            duration,
////                            {
////                                x: targetTransform.x,
////                                y: targetTransform.y,
////                                width: targetTransform.width,
////                                height: targetTransform.height
////                            }
////                        )
////        tween.addEventListener(Event.INIT, function():void { viewport.beginTransform(); })
////        tween.addEventListener(Event.COMPLETE, function():void { viewport.endTransform(); })
////        tween.setAssignment(viewport, "transform")
//
////        tween.target = t
////        tween.setProperties({ x: targetTransform.x,
////                               y: targetTransform.y,
////                               width: targetTransform.width,
////                               height: targetTransform.height })
////        tween.duration = duration
////        tween.setAssignment(viewport, "transform")
//
////        trace(targetTransform.x - t.x, targetTransform.y - t.y,
////               targetTransform.width - t.width, targetTransform.height - t.height)
//
////        trace("@pre:", t.zoom)
////        trace("@post:", targetTransform.zoom)
//
////        viewport.beginTransform()
////        viewport.transform = targetTransform
////        viewport.endTransform()
//
////        Tweener.removeTweens(t)
////        Tweener.addTween(
////                            t,
////                            {
////                                x: targetTransform.x,
////                                y: targetTransform.y,
////                                width: targetTransform.width,
////                                height: targetTransform.height,
////                                time: duration,
////                                transition: transition,
////                                onStart: viewport.beginTransform,
////                                onUpdate: function():void { viewport.transform = t; },
////                                onComplete: viewport.endTransform
////                            }
////                      )
//    }
}

}
