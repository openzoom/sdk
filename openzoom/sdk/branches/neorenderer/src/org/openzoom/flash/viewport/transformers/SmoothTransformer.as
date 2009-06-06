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

import flash.events.TimerEvent;
import flash.geom.Point;
import flash.utils.Timer;
import flash.utils.getTimer;

import org.openzoom.flash.viewport.IViewportTransform;
import org.openzoom.flash.viewport.IViewportTransformer;

public class SmoothTransformer extends ViewportTransformerBase
                               implements IViewportTransformer
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function SmoothTransformer()
    {
        timer = new Timer(0)
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    private var rho:Number = Math.SQRT2
    
    private var S:Number
    
    private var b0:Number
    private var b1:Number
    
    private var r0:Number
    private var r1:Number
    
    private var w0:Number
    private var w1:Number
    
    private var u0:Number
    private var u1:Number
    
    private var c0:Point
    private var c1:Point
    
    // animation speed
    private const V:Number = 0.0012
    
    private var timer:Timer
    
    //--------------------------------------------------------------------------
    //
    //  Methods: IViewportTransformer
    //
    //--------------------------------------------------------------------------

    override public function transform(target:IViewportTransform,
                                       immediately:Boolean=false):void
    {
        super.transform(target, immediately)
        
        c0 = viewport.getCenter()
        c1 = target.getCenter()
    
        w0 = viewport.width
        w1 = target.width
        
        u0 = 0
        u1 = Point.distance(c0, c1)
    
        b0 = b(0)
        b1 = b(1)
        r0 = r(b0)
        r1 = r(b1)
        S = (r1 - r0) / rho
        
        timer.reset()
        
        viewport.beginTransform()
        
//        trace("c0:", c0,
//              "c1:", c1,
//              "w0:", w0,
//              "w1:", w1,
//              "b0:", b0,
//              "b1:", b1,
//              "r0:", r0,
//              "r1:", r1,
//              "S:", S,
//              "u0:", u0,
//              "u1:", u1)
        
        timer.addEventListener(TimerEvent.TIMER,
                               timer_timerHandler,
                               false, 0, true)
        timer.start()
        startTime = getTimer()
    }

    public function stop():void
    {
        timer.stop()
        timer.reset()
        viewport.endTransform()
    }
    
    private var startTime:int = 0
    
    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------
    
    private function timer_timerHandler(event:TimerEvent):void
    {
        var endTime:Number = S / V
        var t:Number = Math.min(getTimer() - startTime, endTime)
        
        if (t == endTime)
        {
            timer.stop()
            timer.removeEventListener(TimerEvent.TIMER,
                                      timer_timerHandler)
            viewport.endTransform()
        }
        
        var s:Number = V * t
        
        var transform:IViewportTransform = viewport.transform
        
        transform.width = w(s)
        var center:Point = c(s)
        transform.panCenterTo(center.x, center.y)
        
        viewport.transform = transform
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    private function c(s:Number):Point
    {
        var center:Point = new Point()
        var us:Number = u(s)
        center.x = c0.x + (c1.x - c0.x) / u1 * us 
        center.y = c0.y + (c1.y - c0.y) / u1 * us
        return center
    }
    
    private function u(s:Number):Number
    {
        var a:Number = w0 / (rho * rho)
        return a * cosh(r0) * tanh(rho * s + r0) - a * sinh(r0) + u0
    }
    
    private function w(s:Number):Number
    {
        return w0 * cosh(r0) / cosh(rho * s + r0)
    }
    
    private function r(b:Number):Number
    {
        return Math.log(-b + Math.sqrt(b*b + 1))
    }
    
    private function b(i:int):Number
    {
        var sign:int = i == 0 ? 1 : -1
        var w:Number = i == 0 ? w0 : w1
        var rho2:Number = rho*rho
        var rho4:Number = rho2*rho2
        var numerator:Number = (w1*w1 - w0*w0 + sign * rho4 * (u1 - u0)*(u1 - u0))
        var denominator:Number = 2*w * rho2 * (u1 - u0)
        return numerator / denominator 
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods: Math Utilities
    //
    //--------------------------------------------------------------------------
    
    private function cosh(x:Number):Number
    {
        return (Math.exp(x) + Math.exp(-x)) / 2
    }
    
    private function sinh(x:Number):Number
    {
        return (Math.exp(x) - Math.exp(-x)) / 2
    }
    
    private function tanh(x:Number):Number
    {
        return sinh(x) / cosh(x)
    }
}

}