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
package org.openzoom.flash.components
{

import flash.display.Graphics;
import flash.display.LineScaleMode;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Rectangle;

import org.openzoom.flash.core.openzoom_internal;
import org.openzoom.flash.events.ViewportEvent;
import org.openzoom.flash.utils.math.clamp;
import org.openzoom.flash.viewport.INormalizedViewport;

use namespace openzoom_internal;

/**
 * Component for quickly navigating a multiscale scene.
 */
public final class SceneNavigator extends Sprite
{
	include "../core/Version.as"

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    private static const DEFAULT_DIMENSION:Number = 150
    private static const DEFAULT_WINDOW_COLOR:uint = 0x666666

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     */
    public function SceneNavigator():void
    {
        addEventListener(Event.ADDED_TO_STAGE,
                         addedToStageHandler,
                         false, 0, true)

        createBackground()
        createWindow()
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var background:Sprite
    private var backgroundWidth:Number
    private var backgroundHeight:Number

    private var window:Sprite

    private var oldMouseX:Number
    private var oldMouseY:Number

    private var panning:Boolean = false

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    private var _viewport:INormalizedViewport

    public function get viewport():INormalizedViewport
    {
        return _viewport
    }

    public function set viewport(value:INormalizedViewport):void
    {
        if (value === viewport)
            return

        _viewport = value

        if (viewport)
        {
            viewport.addEventListener(ViewportEvent.TRANSFORM_UPDATE,
                                      viewport_transformUpdateHandler,
                                      false, 0, true)
            viewport.addEventListener(ViewportEvent.RESIZE,
                                      viewport_resizeHandler,
                                      false, 0, true)
            viewport_transformUpdateHandler(null)

            // resize background
            var aspectRatio:Number =
                    viewport.scene.sceneWidth / viewport.scene.sceneHeight

            background.width = Math.min(DEFAULT_DIMENSION,
                                        DEFAULT_DIMENSION * aspectRatio)
            background.height = Math.min(DEFAULT_DIMENSION,
                                         DEFAULT_DIMENSION / aspectRatio)

            var backgroundBounds:Rectangle = background.getRect(this)
            backgroundWidth = backgroundBounds.width
            backgroundHeight = backgroundBounds.height

            transformWindow()
        }
        else
        {
            viewport.removeEventListener(ViewportEvent.TRANSFORM_UPDATE,
                                         viewport_transformUpdateHandler)
            viewport.removeEventListener(ViewportEvent.RESIZE,
                                         viewport_resizeHandler)
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Children
    //
    //--------------------------------------------------------------------------

    private function createBackground():void
    {
        background = new Sprite()

        var g:Graphics = background.graphics
            g.lineStyle(1.0, 0x000000, 0.8, false, LineScaleMode.NONE)
            g.beginFill(0xEFEFEF, 0.1)
            g.drawRect(0, 0, DEFAULT_DIMENSION, DEFAULT_DIMENSION)
            g.endFill()

            background.buttonMode = true
            background.addEventListener(MouseEvent.CLICK,
                                        background_clickHandler,
                                        false, 0, true)

        addChildAt(background, 0)
    }

    private function createWindow():void
    {
        window = new Sprite()

        var g:Graphics = window.graphics
            g.beginFill(DEFAULT_WINDOW_COLOR, 0.3)
            g.drawRect(0, 0, DEFAULT_DIMENSION, DEFAULT_DIMENSION)
            g.endFill()

            window.buttonMode = true
            window.addEventListener(MouseEvent.MOUSE_DOWN,
                                    window_mouseDownHandler,
                                    false, 0, true)

            addChild(window)
    }

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

    private function addedToStageHandler(event:Event):void
    {
        stage.addEventListener(Event.MOUSE_LEAVE,
                               stage_mouseLeaveHandler,
                               false, 0, true)
        stage.addEventListener(MouseEvent.MOUSE_UP,
                               stage_mouseLeaveHandler,
                               false, 0, true)
    }

    private function viewport_transformUpdateHandler(event:ViewportEvent):void
    {
        if (panning)
           return

        transformWindow()
    }

    private function viewport_resizeHandler(event:ViewportEvent):void
    {
        transformWindow()
    }

    private function window_mouseDownHandler(event:MouseEvent):void
    {
        oldMouseX = stage.mouseX
        oldMouseY = stage.mouseY

        stage.addEventListener(MouseEvent.MOUSE_MOVE,
                               stage_mouseMoveHandler,
                               false, 0, true)
        panning = true
    }

    private function stage_mouseMoveHandler(event:MouseEvent):void
    {
        var dx:Number = stage.mouseX - oldMouseX
        var dy:Number = stage.mouseY - oldMouseY

        var targetX:Number = window.x + dx
        var targetY:Number = window.y + dy

        var windowBounds:Rectangle = window.getBounds(this)
        var windowWidth:Number = windowBounds.width
        var windowHeight:Number = windowBounds.height

        if (targetX < 0)
            targetX = 0

        if (targetY < 0)
            targetY = 0

        if (windowBounds.right > backgroundWidth)
            targetX = backgroundWidth - windowWidth

        if (windowBounds.bottom > backgroundHeight)
            targetY = backgroundHeight - windowHeight

        window.x = targetX
        window.y = targetY

        oldMouseX = stage.mouseX
        oldMouseY = stage.mouseY

        viewport.panTo(clamp(window.x, 0, backgroundWidth) / backgroundWidth,
                       clamp(window.y, 0, backgroundHeight) / backgroundHeight)
    }

    private function stage_mouseUpHandler(event:MouseEvent):void
    {
        stage.removeEventListener(MouseEvent.MOUSE_MOVE,
                                  stage_mouseMoveHandler)
        panning = false
    }

    private function background_clickHandler(event:MouseEvent):void
    {
        var transformX:Number = (background.scaleX * background.mouseX)
                                    / backgroundWidth
        var transformY:Number = (background.scaleY * background.mouseY)
                                    / backgroundHeight

        viewport.panCenterTo(transformX, transformY)
    }

    private function stage_mouseLeaveHandler(event:Event):void
    {
        stage_mouseUpHandler(null)
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    private function transformWindow():void
    {
        // compute bounds
        var v:INormalizedViewport = viewport
        var targetX:Number = clamp(v.x, 0, 1 - v.width) * backgroundWidth
        var targetY:Number = clamp(v.y, 0, 1 - v.height) * backgroundHeight
        var targetWidth:Number = clamp(v.width, 0, 1) * backgroundWidth
        var targetHeight:Number = clamp(v.height, 0, 1) * backgroundHeight

        // enable / disable window dragging
        if (viewport.transformer.target.width >= 1 &&
            viewport.transformer.target.height >= 1)
            window.mouseEnabled = false
        else
            window.mouseEnabled = true

        // transform
        window.width = targetWidth
        window.height = targetHeight
        window.x = clamp(targetX, 0, background.width - window.width)
        window.y = clamp(targetY, 0, background.height - window.height)
  }
}

}
