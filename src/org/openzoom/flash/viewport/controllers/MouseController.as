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
package org.openzoom.flash.viewport.controllers
{

import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.utils.Timer;

import org.openzoom.flash.core.openzoom_internal;
import org.openzoom.flash.utils.math.clamp;
import org.openzoom.flash.viewport.IViewportController;

use namespace openzoom_internal;

/**
 * Mouse controller for viewports.
 */
public final class MouseController extends ViewportControllerBase
                                   implements IViewportController
{
	include "../../core/Version.as"

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    private static const CLICK_THRESHOLD_DURATION:Number = 500 // milliseconds
    private static const CLICK_THRESHOLD_DISTANCE:Number = 8 // pixels

    private static const DEFAULT_CLICK_ZOOM_IN_FACTOR:Number = 2.0
    private static const DEFAULT_CLICK_ZOOM_OUT_FACTOR:Number = 0.3

    private static const DEFAULT_MOUSE_WHEEL_ZOOM_FACTOR:Number = 1.11

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     */
    public function MouseController()
    {
        createClickTimer()
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var clickTimer:Timer
    private var click:Boolean = false
    private var mouseDownPosition:Point

    private var viewDragVector:Rectangle = new Rectangle()
    private var viewportDragVector:Rectangle = new Rectangle()
    private var panning:Boolean = false

    //----------------------------------
    //  minMouseWheelZoomInFactor
    //----------------------------------

    public var minMouseWheelZoomInFactor:Number = 1

    //----------------------------------
    //  minMouseWheelZoomOutFactor
    //----------------------------------

    public var minMouseWheelZoomOutFactor:Number = 1

    //----------------------------------
    //  smoothPanning
    //----------------------------------

    public var smoothPanning:Boolean = true

    //----------------------------------
    //  clickEnabled
    //----------------------------------

    public var clickEnabled:Boolean = true

    //----------------------------------
    //  clickZoomInFactor
    //----------------------------------

    private var _clickZoomInFactor:Number = DEFAULT_CLICK_ZOOM_IN_FACTOR

    /**
     * Factor for zooming into the scene through clicking.
     *
     * @default 2.0
     */
    public function get clickZoomInFactor():Number
    {
        return _clickZoomInFactor
    }

    public function set clickZoomInFactor(value:Number):void
    {
        _clickZoomInFactor = value
    }

    //----------------------------------
    //  clickZoomOutFactor
    //----------------------------------

    private var _clickZoomOutFactor:Number = DEFAULT_CLICK_ZOOM_OUT_FACTOR

    /**
     * Factor for zooming out of the scene through Shift-/Ctrl-clicking.
     *
     * @default 0.3
     */
    public function get clickZoomOutFactor():Number
    {
        return _clickZoomOutFactor
    }

    public function set clickZoomOutFactor(value:Number):void
    {
        _clickZoomOutFactor = value
    }

    //----------------------------------
    //  mouseWheelZoomFactor
    //----------------------------------

    private var _mouseWheelZoomFactor:Number = DEFAULT_MOUSE_WHEEL_ZOOM_FACTOR

    /**
     * Factor for zooming the scene through the mouse wheel.
     *
     * @default 0.05
     */
    public function get mouseWheelZoomFactor():Number
    {
        return _mouseWheelZoomFactor
    }

    public function set mouseWheelZoomFactor(value:Number):void
    {
        _mouseWheelZoomFactor = value
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Internal
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    private function createClickTimer():void
    {
        clickTimer = new Timer(CLICK_THRESHOLD_DURATION, 1)
        clickTimer.addEventListener(TimerEvent.TIMER_COMPLETE,
                                    clickTimer_completeHandler,
                                    false, 0, true)
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods: ViewportControllerBase
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    override protected function view_addedToStageHandler(event:Event):void
    {
        // panning listeners
        view.addEventListener(MouseEvent.MOUSE_DOWN,
                              view_mouseDownHandler,
                              false, 0, true)
        view.addEventListener(MouseEvent.ROLL_OUT,
                              view_rollOutHandler,
                              false, 0, true)
        view.stage.addEventListener(Event.MOUSE_LEAVE,
                                    stage_mouseLeaveHandler,
                                    false, 0, true)

        // zooming listeners
        view.addEventListener(MouseEvent.MOUSE_WHEEL,
                              view_mouseWheelHandler,
                              false, 0, true)
    }

    /**
     * @private
     */
    override protected function view_removedFromStageHandler(event:Event):void
    {
    	if (view)
    	{
	        // panning listeners
	        view.removeEventListener(MouseEvent.MOUSE_DOWN,
	                                 view_mouseDownHandler)
	        view.removeEventListener(MouseEvent.ROLL_OUT,
	                                 view_rollOutHandler)
	                                 
            if (view.stage) 
		        view.stage.removeEventListener(Event.MOUSE_LEAVE,
		                                       stage_mouseLeaveHandler)
	
	        // zooming listeners
	        view.removeEventListener(MouseEvent.MOUSE_WHEEL,
	                                 view_mouseWheelHandler)
    	}
    }

    //--------------------------------------------------------------------------
    //
    //  Event Handlers: Zooming
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    private function view_mouseWheelHandler(event:MouseEvent):void
    {
        // prevent zooming when panning
        if (panning)
            return

        // FIXME: Supposedly prevents unwanted scrolling in browsers
        event.stopPropagation()

        // TODO: React appropriately to different platforms and/or browsers,
        // as they at times report completely different mouse wheel deltas.
        var factor:Number = clamp(Math.pow(mouseWheelZoomFactor, event.delta), 0.5, 3)

        // TODO: Refactor
        if (factor < 1)
            factor = Math.min(factor, minMouseWheelZoomOutFactor)
        else
            factor = Math.max(factor, minMouseWheelZoomInFactor)

        // compute normalized origin of mouse relative to viewport.
        var originX:Number = view.mouseX / view.width
        var originY:Number = view.mouseY / view.height

        // transform viewport
        viewport.zoomBy(factor, originX, originY)

        // TODO
        event.updateAfterEvent()
    }

    //--------------------------------------------------------------------------
    //
    //  Event Handlers: Panning
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    private function clickTimer_completeHandler(event:TimerEvent):void
    {
        click = false
        clickTimer.reset()
    }

    /**
     * @private
     */
    private function view_mouseDownHandler(event:MouseEvent):void
    {
        view.addEventListener(MouseEvent.MOUSE_UP,
                              view_mouseUpHandler,
                              false, 0, true)

        // remember mouse position
        mouseDownPosition = new Point(view.mouseX, view.mouseY)

        // assume mouse down is a click
        click = true

        // start click timer
        clickTimer.reset()
        clickTimer.start()

        // register where we are in the view as well as in the viewport
        viewDragVector.topLeft = new Point(view.mouseX, view.mouseY)
        viewportDragVector.topLeft = new Point(viewport.transformer.target.x,
                                               viewport.transformer.target.y)

        beginPanning()
    }

    /**
     * @private
     */
    private function view_mouseMoveHandler(event:MouseEvent):void
    {
        if (!panning)
            return

        // update view drag vector
        viewDragVector.bottomRight = new Point(view.mouseX, view.mouseY)

        var distanceX:Number
        var distanceY:Number
        var targetX:Number
        var targetY:Number

        distanceX = viewDragVector.width / viewport.viewportWidth
        distanceY = viewDragVector.height / viewport.viewportHeight

        targetX = viewportDragVector.x - (distanceX * viewport.width)
        targetY = viewportDragVector.y - (distanceY * viewport.height)

        // FIXME: Zoom skipping when smoothPanning = false
        viewport.panTo(targetX, targetY, !smoothPanning)
    }

    /**
     * @private
     */
    private function view_mouseUpHandler(event:MouseEvent):void
    {
        view.removeEventListener(MouseEvent.MOUSE_UP, view_mouseUpHandler)

        var mouseUpPosition:Point = new Point(view.mouseX, view.mouseY)
        var dx:Number = mouseUpPosition.x - mouseDownPosition.x
        var dy:Number = mouseUpPosition.y - mouseDownPosition.y

        var distance:Number = Math.sqrt(dx * dx + dy * dy)

        if (clickEnabled && click && distance < CLICK_THRESHOLD_DISTANCE)
        {
            var factor:Number

            if (event.shiftKey || event.ctrlKey)
                factor = clickZoomOutFactor
            else
                factor = clickZoomInFactor

            viewport.zoomBy(factor,
                            view.mouseX / view.width,
                            view.mouseY / view.height)
        }

        click = false
        clickTimer.reset()

        stopPanning()
    }

    /**
     * @private
     */
    private function beginPanning():void
    {
        // begin panning
        panning = true

        // register for mouse move events
        view.addEventListener(MouseEvent.MOUSE_MOVE,
                              view_mouseMoveHandler,
                              false, 0, true)
    }

    /**
     * @private
     */
    private function stopPanning():void
    {
        // unregister from mouse move events
        // FIXME
        if (view)
            view.removeEventListener(MouseEvent.MOUSE_MOVE,
                                     view_mouseMoveHandler)

        panning = false
    }

    /**
     * @private
     */
    private function stage_mouseLeaveHandler(event:Event):void
    {
        stopPanning()
    }

    /**
     * @private
     */
    private function view_rollOutHandler(event:MouseEvent):void
    {
        stopPanning()
    }
}

}
