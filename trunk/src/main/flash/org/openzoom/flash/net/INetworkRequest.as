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
package org.openzoom.flash.net
{

import flash.events.IEventDispatcher;

/**
 *  Dispatched when an item successfully finished loading.
 *
 *  @eventType org.openzoom.events.LoadingItemEvent.COMPLETE
 */
[Event(name="complete", type="org.openzoom.events.LoadingItemEvent")]

/**
 *  Dispatched when an item caused an error during loading.
 *
 *  @eventType org.openzoom.events.LoadingItemEvent.ERROR
 */
[Event(name="error", type="org.openzoom.events.LoadingItemEvent")]

/**
 * Interface for loading items.
 */
public interface INetworkRequest extends IEventDispatcher
{
    function start() : void
//  function stop() : void

    function get bytesLoaded():uint
    function get bytesTotal():uint
}

}