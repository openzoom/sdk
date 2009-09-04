package org.openzoom.flash.components
{

import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.TimerEvent;
import flash.utils.Timer;

import org.openzoom.flash.core.openzoom_internal;

use namespace openzoom_internal;

/**
 * Component for indicating activity, such as loading over the network.<br/>
 *
 * License: Unknown<br/>
 * 
 * Adapted from code by Steven Sacks
 * @see http://www.stevensacks.net/2008/10/01/as3-apple-style-preloader/
 */
public final class Spinner extends Sprite
{
	include "../core/Version.as"

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    private static const DEFAULT_ANIMATION_DURATION:Number = 65

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    /**
     * Constructor
     */
    public function Spinner(numSlices:int=12, radius:int=4, color:uint=0x999999)
    {
        this.numSlices = numSlices
        this.radius = radius
        this.color = color

        draw()

        addEventListener(Event.ADDED_TO_STAGE,
                         addedToStageHandler,
                         false, 0, true)
        addEventListener(Event.REMOVED_FROM_STAGE,
                         removedFromStageHandler,
                         false, 0, true)
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var timer:Timer
    private var numSlices:int
    private var radius:int
    private var color:uint

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

    private function addedToStageHandler(event:Event):void
    {
        timer = new Timer(DEFAULT_ANIMATION_DURATION)
        timer.addEventListener(TimerEvent.TIMER,
                               timer_timerHandler,
                               false, 0, true)
        timer.start()
    }

    private function removedFromStageHandler(event:Event):void
    {
        timer.reset()
        timer.removeEventListener(TimerEvent.TIMER,
                                  timer_timerHandler)
        timer = null
    }

    private function timer_timerHandler(event:TimerEvent):void
    {
        rotation = (rotation + (360 / numSlices)) % 360
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Display list
    //
    //--------------------------------------------------------------------------

    private function draw():void
    {
        var i:int = numSlices
        var degrees:int = 360 / numSlices

        while (i--)
        {
            var slice:Shape = getSlice()
            slice.alpha = Math.max(0.2, 1 - (0.1 * i))
            var radianAngle:Number = (degrees * i) * Math.PI / 180
            slice.rotation = -degrees * i
            slice.x = Math.sin(radianAngle) * radius
            slice.y = Math.cos(radianAngle) * radius
            addChild(slice)
        }
    }

    private function getSlice():Shape
    {
        var slice:Shape = new Shape()
        var g:Graphics = slice.graphics
        g.beginFill(color)
        g.drawRoundRect(-1, 0, 2, 6, 12, 12)
        g.endFill()

        return slice
    }
}

}
