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

import org.openzoom.flash.events.ViewportEvent;
import org.openzoom.flash.utils.IDisposable;
import org.openzoom.flash.viewport.INormalizedViewport;
import org.openzoom.flash.viewport.IViewportTransform;
import org.openzoom.flash.viewport.IViewportTransformer;

/**
 * 
 */
public class SmoothTransformer extends ViewportTransformerBase
                               implements IViewportTransformer,
                                          IDisposable
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------
    
    private static const DEFAULT_RHO:Number = Math.SQRT2
    private static const DEFAULT_V:Number = 0.0011
    
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
    }
    
    /**
     * Constructor.
     */
    public static function getInstance(viewport:INormalizedViewport):SmoothTransformer
    {
        var instance:SmoothTransformer = new SmoothTransformer()
        instance.viewport = viewport
        instance.external = true
        
        return instance
    }
    
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

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

    private var timer:Timer

    private var running:Boolean = false

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  rho
    //----------------------------------

    public var rho:Number = DEFAULT_RHO
    
    //----------------------------------
    //  speed
    //----------------------------------
    
    private var V:Number = DEFAULT_V

    public function get speed():Number
    {
        return V * 1000;
    }

    public function set speed(value:Number):void
    {
        V = value / 1000;
    }

    //----------------------------------
    //  external
    //----------------------------------
    
    private var _external:Boolean = false
    
    public function get external():Boolean
    {
        return _external
    }
    
    public function set external(value:Boolean):void
    {
        _external = value
        
        if (value)
        {
            viewport.addEventListener(ViewportEvent.TARGET_UPDATE,
                                      viewport_targetUpdateHandler,
                                      false, 0, true)
        }
        else
        {
            viewport.removeEventListener(ViewportEvent.TARGET_UPDATE,
                                         viewport_targetUpdateHandler)
        }
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods: IViewportTransformer
    //
    //--------------------------------------------------------------------------

    override public function transform(target:IViewportTransform,
                                       immediately:Boolean=false):void
    {
        super.transform(target, immediately)

        c0 = viewport.center
        c1 = target.center

        w0 = viewport.width
        w1 = target.width

        u0 = 0
        u1 = Point.distance(c0, c1)

        if (Math.abs(u0 - u1) < 0.0000001)
        {
            viewport.beginTransform()
            viewport.transform = target
            viewport.endTransform()
            return
        }

        b0 = b(0)
        b1 = b(1)
        r0 = r(b0)
        r1 = r(b1)
        S = (r1 - r0) / rho


        if (!timer)
            timer = new Timer(0)

        timer.reset()

        timer.addEventListener(TimerEvent.TIMER,
                               timer_timerHandler,
                               false, 0, true)

        startTime = getTimer()
        endTime = S / V

        running = true
        viewport.beginTransform()
        timer.start()
    }

    public function stop():void
    {
        if (!running)
            return

        timer.stop()
        timer.reset()

        timer = null

        viewport.transformer.target = viewport.transform
        viewport.endTransform()

        running = false
    }

    private var startTime:int = 0
    private var endTime:Number = 0

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

    private function timer_timerHandler(event:TimerEvent):void
    {
        var t:Number = Math.min(getTimer() - startTime, endTime)

        if (t == endTime)
        {
            timer.stop()
            timer.removeEventListener(TimerEvent.TIMER,
                                      timer_timerHandler)
            stop()
            return
        }

        var s:Number = V * t

        var transform:IViewportTransform = viewport.transform

        transform.width = w(s)
        var center:Point = c(s)
        transform.panCenterTo(center.x, center.y)

        viewport.transformer.target = transform
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
        var du:Number = u1 - u0
        var numerator:Number = w1*w1 - w0*w0 + sign * rho4 * du*du
        var denominator:Number = 2*w * rho2 * du
        
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

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

    public function viewport_targetUpdateHandler(event:ViewportEvent):void
    {
        stop()
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: IDisposable
    //
    //--------------------------------------------------------------------------
    
    public function dispose():void
    {
        if (viewport && external)
            viewport.removeEventListener(ViewportEvent.TARGET_UPDATE,
                                         viewport_targetUpdateHandler)
        
        viewport = null
    }
}

}
