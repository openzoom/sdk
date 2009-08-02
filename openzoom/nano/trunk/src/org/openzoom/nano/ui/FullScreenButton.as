////////////////////////////////////////////////////////////////////////////////
//
//  OpenZoom Nano
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
package org.openzoom.nano.ui
{

import flash.display.Sprite;
import flash.events.Event;
import flash.events.FullScreenEvent;
import flash.events.MouseEvent;

import org.openzoom.flash.utils.FullScreenUtil;

/**
 * Fullscreen button
 */
public class FullScreenButton extends Sprite
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
	public function FullScreenButton()
	{
        addEventListener(Event.ADDED_TO_STAGE,
                         addedToStageHandler,
                         false, 0, true)
        createChildren()
	}
	
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    private var enterButton:FullScreenEnterButton
    private var exitButton:FullScreenExitButton
	
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    private function createChildren():void
    {
    	if (!enterButton)
    	{
    		enterButton = new FullScreenEnterButton()
    		enterButton.addEventListener(MouseEvent.CLICK,
    		                             enterButton_clickHandler,
    		                             false, 0, true)
            addChild(enterButton)
    		
    		exitButton = new FullScreenExitButton()
    		exitButton.visible = false
            exitButton.addEventListener(MouseEvent.CLICK,
                                        exitButton_clickHandler,
                                        false, 0, true)
            addChild(exitButton)
    	}
    }
    
    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

    private function enterButton_clickHandler(event:MouseEvent):void
    {
        FullScreenUtil.toggleFullScreen(stage)
    }
    
    private function exitButton_clickHandler(event:MouseEvent):void
    {
        FullScreenUtil.toggleFullScreen(stage)
    }
    
    private function addedToStageHandler(event:Event):void
    {
        stage.addEventListener(FullScreenEvent.FULL_SCREEN,
                               stage_fullScreenHandler,
                               false, 0, true)
    }
    
    private function stage_fullScreenHandler(event:FullScreenEvent):void
    {
    	if (event.fullScreen)
    	{
            enterButton.visible = false
            exitButton.visible = true   		
    	}
    	else
    	{
            enterButton.visible = true
            exitButton.visible = false  		
    	}
    }
}

}
