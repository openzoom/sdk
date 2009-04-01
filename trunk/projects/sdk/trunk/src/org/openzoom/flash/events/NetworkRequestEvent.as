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
package org.openzoom.flash.events
{

import flash.events.Event;

import org.openzoom.flash.net.INetworkRequest;

/**
 * @private
 */
public class NetworkRequestEvent extends Event
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    public static const COMPLETE : String = "complete"   
    public static const ERROR:String = "error"

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

	/**
	 * Constructor.
	 */
    public function NetworkRequestEvent(type:String,
                                        bubbles:Boolean = false,
                                        cancelable:Boolean = false)   
    {
        super(type, bubbles, cancelable)
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    public var data:* = null
    public var context : * = null
    public var item:INetworkRequest

    //--------------------------------------------------------------------------
    //
    //  Methods: Event
    //
    //--------------------------------------------------------------------------

    /**
     * @inheritDoc
     */
    override public function clone():Event
    {
        return new NetworkRequestEvent(type, bubbles, cancelable)
    }
}

}