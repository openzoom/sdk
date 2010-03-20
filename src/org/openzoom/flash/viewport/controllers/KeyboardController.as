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
import flash.events.KeyboardEvent;
import flash.events.TimerEvent;
import flash.ui.Keyboard;
import flash.utils.Timer;

import org.openzoom.flash.core.openzoom_internal;
import org.openzoom.flash.utils.FullScreenUtil;
import org.openzoom.flash.viewport.IViewportController;

use namespace openzoom_internal;

/**
 * Keyboard controller for viewports.
 */
public final class KeyboardController extends ViewportControllerBase
                                      implements IViewportController
{
	include "../../core/Version.as"

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    private static const KEYBOARD_REFRESH_DELAY:Number = 80 // milliseconds

    private static const DEFAULT_ZOOM_IN_FACTOR:Number = 2.0
    private static const DEFAULT_ZOOM_OUT_FACTOR:Number = 0.7
    private static const DEFAULT_PAN_FACTOR:Number = 0.1
    private static const DEFAULT_BOOST_FACTOR:Number = 12

    private static const DEFAULT_FULL_SCREEN_KEY_CODE:uint = 70 // F
    private static const DEFAULT_UP_KEY_CODE:uint = 87          // W
    private static const DEFAULT_RIGHT_KEY_CODE:uint = 68       // D
    private static const DEFAULT_DOWN_KEY_CODE:uint = 83        // S
    private static const DEFAULT_LEFT_KEY_CODE:uint = 65        // A

    private static const DEFAULT_ZOOM_IN_KEY_CODE:uint = 73     // I
    private static const DEFAULT_ZOOM_OUT_KEY_CODE:uint = 79    // 0

    private static const DEFAULT_SHOW_ALL_KEY_CODE:uint = 72    // H

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function KeyboardController()
    {
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var keyboardTimer:Timer

    private var boosterActivated:Boolean

    private var upActivated:Boolean
    private var downActivated:Boolean
    private var leftActivated:Boolean
    private var rightActivated:Boolean

    private var pageUpActivated:Boolean
    private var pageDownActivated:Boolean
    private var homeActivated:Boolean
    private var endActivated:Boolean

    private var zoomInActivated:Boolean
    private var zoomOutActivated:Boolean
    private var showAllActivated:Boolean

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
        if (!keyboardTimer)
            keyboardTimer = new Timer(KEYBOARD_REFRESH_DELAY)

        keyboardTimer.start()
        keyboardTimer.addEventListener(TimerEvent.TIMER,
                                       keyboardTimerHandler,
                                       false, 0, true)

        view.stage.addEventListener(KeyboardEvent.KEY_DOWN,
                                    keyDownHandler,
                                    false, 0, true)
        view.stage.addEventListener(KeyboardEvent.KEY_UP,
                                    keyUpHandler,
                                    false, 0, true)
    }

    /**
     * @private
     */
    override protected function view_removedFromStageHandler(event:Event):void
    {
        keyboardTimer.removeEventListener(TimerEvent.TIMER, keyboardTimerHandler)
        keyboardTimer.stop()
        keyboardTimer = null

        view.stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler)
        view.stage.removeEventListener(KeyboardEvent.KEY_UP, keyUpHandler)
    }

    //--------------------------------------------------------------------------
    //
    //  Properties: Settings
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  acceleration
    //----------------------------------

    public var booster:Boolean = true

    //----------------------------------
    //  fullScreen
    //----------------------------------

    public var fullScreen:Boolean = true

    //----------------------------------
    //  showAll
    //----------------------------------

    public var showAll:Boolean = true

    //----------------------------------
    //  zoomIn
    //----------------------------------

    public var zoomIn:Boolean = true

    //----------------------------------
    //  zoomOut
    //----------------------------------

    public var zoomOut:Boolean = true

    //----------------------------------
    //  panUp
    //----------------------------------

    public var panUp:Boolean = true

    //----------------------------------
    //  panRight
    //----------------------------------

    public var panRight:Boolean = true

    //----------------------------------
    //  panDown
    //----------------------------------

    public var panDown:Boolean = true

    //----------------------------------
    //  panLeft
    //----------------------------------

    public var panLeft:Boolean = true

    //----------------------------------
    //  home
    //----------------------------------

    public var home:Boolean = true

    //----------------------------------
    //  end
    //----------------------------------

    public var end:Boolean = true

    //----------------------------------
    //  pageUp
    //----------------------------------

    public var pageUp:Boolean = true

    //----------------------------------
    //  pageDown
    //----------------------------------

    public var pageDown:Boolean = true

    //--------------------------------------------------------------------------
    //
    //  Properties: Key settings
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  fullScreenKey
    //----------------------------------

    private var fullScreenKeyCode:uint = DEFAULT_FULL_SCREEN_KEY_CODE

    /**
     * Key for panning the viewport up.
     *
     * @default W
     */
    public function get fullScreenKey():String
    {
        return String.fromCharCode(fullScreenKeyCode)
    }

    public function set fullScreenKey(value:String):void
    {
        fullScreenKeyCode = value.toUpperCase().charCodeAt(0)
    }

    //----------------------------------
    //  showAllKey
    //----------------------------------

    private var showAllKeyCode:uint = DEFAULT_SHOW_ALL_KEY_CODE

    /**
     * Key for fitting the entire scene into the viewport.
     *
     * @default H
     */
    public function get showAllKey():String
    {
        return String.fromCharCode(showAllKeyCode)
    }

    public function set showAllKey(value:String):void
    {
        showAllKeyCode = value.toUpperCase().charCodeAt(0)
    }

    //----------------------------------
    //  zoomInKey
    //----------------------------------

    private var zoomInKeyCode:uint = DEFAULT_ZOOM_IN_KEY_CODE

    /**
     * Key for zooming into the scene.
     *
     * @default I
     */
    public function get zoomInKey():String
    {
        return String.fromCharCode(zoomInKeyCode)
    }

    public function set zoomInKey(value:String):void
    {
        zoomInKeyCode = value.toUpperCase().charCodeAt(0)
    }

    //----------------------------------
    //  zoomOutKey
    //----------------------------------

    private var zoomOutKeyCode:uint = DEFAULT_ZOOM_OUT_KEY_CODE

    /**
     * Key for zooming out of the scene.
     *
     * @default 0
     */
    public function get zoomOutKey():String
    {
        return String.fromCharCode(zoomOutKeyCode)
    }

    public function set zoomOutKey(value:String):void
    {
        zoomOutKeyCode = value.toUpperCase().charCodeAt(0)
    }

    //----------------------------------
    //  upKey
    //----------------------------------

    private var upKeyCode:uint = DEFAULT_UP_KEY_CODE

    /**
     * Key for panning the viewport up.
     *
     * @default W
     */
    public function get upKey():String
    {
        return String.fromCharCode(upKeyCode)
    }

    public function set upKey(value:String):void
    {
        upKeyCode = value.toUpperCase().charCodeAt(0)
    }

    //----------------------------------
    //  rightKey
    //----------------------------------

    private var rightKeyCode:uint = DEFAULT_RIGHT_KEY_CODE

    /**
     * Key for panning the viewport to the right.
     *
     * @default D
     */
    public function get rightKey():String
    {
        return String.fromCharCode(rightKeyCode)
    }

    public function set rightKey(value:String):void
    {
        rightKeyCode = value.toUpperCase().charCodeAt(0)
    }

    //----------------------------------
    //  downKey
    //----------------------------------

    private var downKeyCode:uint = DEFAULT_DOWN_KEY_CODE

    /**
     * Key for panning the viewport down.
     *
     * @default S
     */
    public function get downKey():String
    {
        return String.fromCharCode(downKeyCode)
    }

    public function set downKey(value:String):void
    {
        downKeyCode = value.toUpperCase().charCodeAt(0)
    }

    //----------------------------------
    //  leftKey
    //----------------------------------

    private var leftKeyCode:uint = DEFAULT_LEFT_KEY_CODE

    /**
     * Key for panning the viewport to the left.
     *
     * @default A
     */
    public function get leftKey():String
    {
        return String.fromCharCode(leftKeyCode)
    }

    public function set leftKey(value:String):void
    {
        leftKeyCode = value.toUpperCase().charCodeAt(0)
    }

    //----------------------------------
    //  zoomInFactor
    //----------------------------------

    private var _zoomInFactor:Number = DEFAULT_ZOOM_IN_FACTOR

    /**
     * Factor for zooming into the scene.
     *
     * @default 2.0
     */
    public function get zoomInFactor():Number
    {
        return _zoomInFactor
    }

    public function set zoomInFactor(value:Number):void
    {
        _zoomInFactor = value
    }

    //----------------------------------
    //  zoomOutFactor
    //----------------------------------

    private var _zoomOutFactor:Number = DEFAULT_ZOOM_OUT_FACTOR

    /**
     * Factor for zooming out of the scene.
     *
     * @default 0.7
     */
    public function get zoomOutFactor():Number
    {
        return _zoomOutFactor
    }

    public function set zoomOutFactor(value:Number):void
    {
        _zoomOutFactor = value
    }

    //----------------------------------
    //  panFactor
    //----------------------------------

    private var _panFactor:Number = DEFAULT_PAN_FACTOR

    /**
     * Factor for panning within the scene, e.g. a factor of 0.15 means the
     * viewport is panned by 15 percent upon each key stroke.
     *
     * @default 0.1
     */
    public function get panFactor():Number
    {
        return _panFactor
    }

    public function set panFactor(value:Number):void
    {
        _panFactor = value
    }

    //----------------------------------
    //  boostFactor
    //----------------------------------

    public var boostFactor:Number = DEFAULT_BOOST_FACTOR

    //--------------------------------------------------------------------------
    //
    //  Event handlers: Keyboard
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    private function keyDownHandler(event:KeyboardEvent):void
    {
        updateFlags(event, true)

        if (fullScreen && event.keyCode == fullScreenKeyCode)
            FullScreenUtil.toggleFullScreen(view.stage)
    }

    /**
     * @private
     */
    private function keyUpHandler(event:KeyboardEvent):void
    {
        updateFlags(event, false)
    }

    /**
     * @private
     */
    private function updateFlags(event:KeyboardEvent,
                                 value:Boolean):void
    {
        switch (event.keyCode)
        {
            // booster
            case Keyboard.SHIFT:
                boosterActivated = value
                break

            // panning
            case Keyboard.UP:
            case upKeyCode:
                upActivated = value
                break

            case Keyboard.DOWN:
            case downKeyCode:
                downActivated = value
                break

            case Keyboard.LEFT:
            case leftKeyCode:
                leftActivated = value
                break

            case Keyboard.RIGHT:
            case rightKeyCode:
                rightActivated = value
                break

            // quick navigation
            case Keyboard.PAGE_UP:
                pageUpActivated = value
                break

            case Keyboard.PAGE_DOWN:
                pageDownActivated = value
                break

            case Keyboard.HOME:
                homeActivated = value
                break

            case Keyboard.END:
                endActivated = value
                break

            case showAllKeyCode:
                showAllActivated = value
                break

            // zooming
            case Keyboard.NUMPAD_ADD:
            case zoomInKeyCode:
                zoomInActivated = value
                break

            case Keyboard.NUMPAD_SUBTRACT:
            case zoomOutKeyCode:
                zoomOutActivated = value
                break
        }
    }

    /**
     * @private
     */
    private function keyboardTimerHandler(event:TimerEvent):void
    {
        var deltaX:Number = viewport.width * panFactor
        var deltaY:Number = viewport.height * panFactor

        if (booster && boosterActivated)
        {
            deltaX *= boostFactor
            deltaY *= boostFactor
        }

        // panning
        if (panUp && upActivated)
            viewport.panBy(0, -deltaY)

        if (panDown && downActivated)
            viewport.panBy(0,  deltaY)

        if (panLeft && leftActivated)
            viewport.panBy(-deltaX, 0)

        if (panRight && rightActivated)
            viewport.panBy(deltaX, 0)

        // quick navigation
        if (pageUp && pageUpActivated)
            viewport.panTo(viewport.x, 0)

        if (pageDown && pageDownActivated)
            viewport.panTo(viewport.x, 1)

        if (home && homeActivated)
            viewport.panTo(0, viewport.y)

        if (end && endActivated)
            viewport.panTo(1, viewport.y)

        if (showAll && showAllActivated)
            viewport.showAll()

        // zooming
        if (zoomIn && zoomInActivated)
            viewport.zoomBy(zoomInFactor)

        if (zoomOut && zoomOutActivated)
            viewport.zoomBy(zoomOutFactor)
    }
}

}
