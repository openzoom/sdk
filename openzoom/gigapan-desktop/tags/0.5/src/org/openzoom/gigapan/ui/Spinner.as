package org.openzoom.gigapan.ui
{

import flash.display.Shape
import flash.display.Sprite
import flash.display.Graphics
import flash.events.Event
import flash.events.TimerEvent
import flash.utils.Timer

import mx.core.UIComponent

/**
 * @private
 *
 * Original code by Steven Sacks
 * http://www.stevensacks.net/2008/10/01/as3-apple-style-preloader/
 *
 */
public class Spinner extends UIComponent
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    /**
     * Constructor
     */
    public function Spinner()
    {
        addEventListener(Event.ADDED_TO_STAGE,
                         addedToStageHandler,
                         true, 0, false)
    }
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var timer:Timer
    public var numSlices:int = 12
    public var radius:int = 10
    private var canvas:Sprite

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

    private function addedToStageHandler(event:Event):void
    {
        removeEventListener(Event.ADDED_TO_STAGE,
                            addedToStageHandler)
        addEventListener(Event.REMOVED_FROM_STAGE,
                         removedFromStageHandler,
                         false, 0, true)
        
        timer = new Timer(65)
        timer.addEventListener(TimerEvent.TIMER,
                               timer_timerHandler,
                               false, 0, true)
        timer.start()
    }

    private function removedFromStageHandler(event:Event):void
    {
        removeEventListener(Event.REMOVED_FROM_STAGE,
                            removedFromStageHandler)
        addEventListener(Event.ADDED_TO_STAGE,
                         addedToStageHandler,
                         false, 0, true)
                         
        timer.reset()
        timer.removeEventListener(TimerEvent.TIMER,
                                  timer_timerHandler)
        timer = null
    }

    private function timer_timerHandler(event:TimerEvent):void
    {
    	invalidateDisplayList()
    }

    override protected function createChildren():void
    {
    	super.createChildren()
    	
    	canvas = new Sprite()
    	addChild(canvas)
    	
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
            canvas.addChild(slice)
        }
    }

    override protected function updateDisplayList(unscaledWidth:Number,
                                                  unscaledHeight:Number):void
    {
        canvas.rotation = (canvas.rotation + (360 / numSlices)) % 360
    }

    private function getSlice():Shape
    {
        var slice:Shape = new Shape()
        var g:Graphics = slice.graphics
        g.beginFill(0xFFFFFF)
        g.drawRoundRect(-1, 0, radius/3, radius, radius*2, radius*2)
        g.endFill()
        
        return slice
    }
}

}
