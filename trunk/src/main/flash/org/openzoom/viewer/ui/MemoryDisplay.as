////////////////////////////////////////////////////////////////////////////////
//
//  OpenZoom
//  Copyright (c) 2007–2008, Daniel Gasienica <daniel@gasienica.ch>
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
package org.openzoom.viewer.ui
{

import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.system.System;
import flash.text.AntiAliasType;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

/**
 * Displays the total memory consumption of all running Flash Player instances.
 */
public class MemoryDisplay extends Sprite
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
  
    /**
     *  Constructor.
     */
    public function MemoryDisplay() : void
    {
        createBackground()
        createLabel()
        layout()
    
        addEventListener( Event.ENTER_FRAME, enterFrameHandler, false, 0, true )
    }
  
    //--------------------------------------------------------------------------
    //
    //  Children
    //
    //--------------------------------------------------------------------------        
      
    private var label : TextField
    private var background : Shape

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
  
    private function createBackground() : void
    {
        background = new Shape()
    
        var g : Graphics = background.graphics
        g.beginFill( 0x000000 )
        g.drawRoundRect( 0, 0, 70, 24, 0 )
        g.endFill()
    
        addChildAt( background, 0 )
    }
  
    private function createLabel() : void
    {
        label = new TextField()
    
        var textFormat : TextFormat = new TextFormat()
        textFormat.size = 11
        textFormat.font = "Arial"
        textFormat.bold = true
        textFormat.align = TextFormatAlign.CENTER
        textFormat.color = 0xFFFFFF
    
        label.defaultTextFormat = textFormat
        label.antiAliasType = AntiAliasType.ADVANCED
        label.autoSize = TextFieldAutoSize.LEFT
        label.selectable = false
        
        addChild( label )
    }
  
    private function layout() : void
    {
        // center label
        label.x = ( background.width - label.width ) / 2
        label.y = ( background.height - label.height ) / 2
    }
  
    //--------------------------------------------------------------------------
    //
    //  Event Handlers
    //
    //--------------------------------------------------------------------------
      
    private function enterFrameHandler( event : Event ) : void
    {
        var memoryConsumption : Number = System.totalMemory / 1024 / 1024
    
        label.text = memoryConsumption.toFixed( 2 ).toString() + "MiB"
        layout()
    }
}

}