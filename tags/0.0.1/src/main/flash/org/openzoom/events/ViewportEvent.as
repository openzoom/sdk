////////////////////////////////////////////////////////////////////////////////
//
//  OpenZoom
//  Copyright (c) 2008, Daniel Gasienica <daniel@gasienica.ch>
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
package org.openzoom.events
{

import flash.events.Event;

public class ViewportEvent extends Event
{
    //--------------------------------------------------------------------------
    //
    //  Class Constants
    //
    //--------------------------------------------------------------------------

    public static const RESIZE : String = "resize"
    public static const CHANGE : String = "change"
    public static const CHANGE_COMPLETE : String = "changeComplete"

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
  
    /**
     * Constructor.
     */
    public function ViewportEvent( type : String, bubbles : Boolean = false,
                                   cancelable : Boolean = false, oldZ : Number = NaN )
    {
        super( type, bubbles, cancelable )
    
        _oldZ = oldZ
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
  
    //----------------------------------
    //  oldZ
    //----------------------------------
  
    private var _oldZ : Number = NaN
  
    public function get oldZ() : Number
    {
        return _oldZ
    }
    
    //--------------------------------------------------------------------------
    //
    //  Overriden methods: Event
    //
    //--------------------------------------------------------------------------
  
    override public function clone() : Event
    {
        return new ViewportEvent( type, bubbles, cancelable, oldZ )
    }
}

}