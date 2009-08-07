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
package org.openzoom.flash.utils
{

import flash.display.Stage;
import flash.display.StageDisplayState;
import flash.system.Capabilities;
	
/**
 * Helper for toggling fullscreen mode.
 */
public final class FullScreenUtil
{
    public static function toggleFullScreen(stage:Stage):void
    {
        try
        {
            if (stage.displayState == StageDisplayState.NORMAL)
            {
                var mode:String = StageDisplayState.FULL_SCREEN
                
                if (Capabilities.playerType == "Desktop")
                    mode = "fullScreenInteractive"
                    
                stage.displayState = mode
            }
            else
            {
                stage.displayState = StageDisplayState.NORMAL
            }
        }
        catch(error:Error)
        {
            // Nothing we can do...
        }
    }
}

}
