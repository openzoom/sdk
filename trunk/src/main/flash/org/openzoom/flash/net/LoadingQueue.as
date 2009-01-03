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

import flash.display.Bitmap;
import flash.display.DisplayObject;
import flash.events.EventDispatcher;

import org.openzoom.flash.events.LoadingItemEvent;

/**
 * @private
 *
 * Basic loading queue for image tiles.
 */
public class LoadingQueue extends EventDispatcher
                          implements ILoadingQueue
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    private static const MAX_CONNECTIONS : uint = 8

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function LoadingQueue()
    {
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var queue : Array /* of LoadingItem */ = []
    private var connections : Array /* of LoadingItem */ = []

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    public function addItem( url : String,
                             type : Class,
                             context : * = null ) : ILoadingItem
    {
        var item : ILoadingItem

        // TODO
//        if( type == URLVariables )

        // TODO
//      if( type == Sound )

        // TODO
//      if( type == Video || type == NetStream )

        if( type == DisplayObject || type == Bitmap )
            item = new DisplayObjectLoadingItem( url, context )

        if( type == String || type == XML )
            item = new URLLoadingItem( url, context )

        if( !item )
            throw new ArgumentError( "Type " + type.toString() + " not supported." )

        item.addEventListener( LoadingItemEvent.COMPLETE,
                               item_completeHandler )
        item.addEventListener( LoadingItemEvent.ERROR,
                               item_errorHandler )

        // Add item to front (LIFO)
        queue.unshift( item )
        processQueue()
        return item
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Internal
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    private function processQueue() : void
    {
        while( queue.length > 0 && connections.length < MAX_CONNECTIONS )
        {
            var item : ILoadingItem = ILoadingItem( queue.shift() )
            connections.push( item )
            item.load()
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    private function item_completeHandler( event : LoadingItemEvent ) : void
    {
        var index : int = connections.indexOf( event.item )

        if( index > 0 )
           connections.splice( index, 1 )

        processQueue()
    }

    /**
     * @private
     */
    private function item_errorHandler( event : LoadingItemEvent ) : void
    {
        item_completeHandler( event )
    }
}

}