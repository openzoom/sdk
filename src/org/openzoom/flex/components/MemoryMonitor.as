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
package org.openzoom.flex.components
{

import flash.display.Graphics;
import flash.display.Shape;
import flash.events.Event;
import flash.system.System;
import flash.text.AntiAliasType;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

import mx.core.UIComponent;

import org.openzoom.flash.core.openzoom_internal;

use namespace openzoom_internal;

/**
 * Displays the total memory consumption of all running Flash Player instances.
 */
public final class MemoryMonitor extends UIComponent
{
	include "../../flash/core/Version.as"

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    private static const DEFAULT_WIDTH:Number = 70
    private static const DEFAULT_HEIGHT:Number = 24

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function MemoryMonitor()
    {
        addEventListener(Event.ADDED_TO_STAGE,
                         addedToStageHandler,
                         false, 0, true)

        addEventListener(Event.REMOVED_FROM_STAGE,
                         removedFromStageHandler,
                         false, 0, true)
    }

    //--------------------------------------------------------------------------
    //
    //  Children
    //
    //--------------------------------------------------------------------------

    private var label:TextField
    private var background:Shape

    //--------------------------------------------------------------------------
    //
    //  Overridden methods: UIComponent
    //
    //--------------------------------------------------------------------------

    override protected function createChildren():void
    {
        super.createChildren()

        if (!background)
            createBackground()

        if (!label)
            createLabel()
    }

    override protected function measure():void
    {
        measuredWidth = DEFAULT_WIDTH
        measuredHeight = DEFAULT_HEIGHT

        explicitWidth = DEFAULT_WIDTH
        explicitHeight = DEFAULT_HEIGHT
    }

    override protected function updateDisplayList(unscaledWidth:Number,
                                                  unscaledHeight:Number):void
    {
        // center label
        label.x = (background.width - label.width) / 2
        label.y = (background.height - label.height) / 2
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    private function createBackground():void
    {
        background = new Shape()

        var g:Graphics = background.graphics
        g.beginFill(0x000000)
        g.drawRect(0, 0, DEFAULT_WIDTH, DEFAULT_MEASURED_HEIGHT)
        g.endFill()

        addChildAt(background, 0)
    }

    private function createLabel():void
    {
        label = new TextField()

        var textFormat:TextFormat = new TextFormat()
        textFormat.size = 11
        textFormat.font = "Arial"
        textFormat.bold = true
        textFormat.align = TextFormatAlign.CENTER
        textFormat.color = 0xFFFFFF

        label.defaultTextFormat = textFormat
        label.antiAliasType = AntiAliasType.ADVANCED
        label.autoSize = TextFieldAutoSize.LEFT
        label.selectable = false

        addChild(label)
    }

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

    private function addedToStageHandler(event:Event):void
    {
        addEventListener(Event.ENTER_FRAME,
                         enterFrameHandler,
                         false, 0, true)
    }

    private function removedFromStageHandler(event:Event):void
    {
        removeEventListener(Event.ENTER_FRAME,
                            enterFrameHandler)
    }

    private function enterFrameHandler(event:Event):void
    {
        var memoryConsumption:Number = System.totalMemory / 1024 / 1024

        label.text = memoryConsumption.toFixed(2).toString() + "MiB"
        invalidateDisplayList()
    }
}

}
