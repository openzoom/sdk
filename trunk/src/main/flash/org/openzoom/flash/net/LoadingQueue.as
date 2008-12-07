////////////////////////////////////////////////////////////////////////////////
//
//  OpenZoom
//
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
package org.openzoom.flash.net
{

import org.openzoom.flash.events.LoadingItemEvent;

/**
 * @private
 * 
 * Basic loading queue for image tiles.
 */
public class LoadingQueue
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
    
    public function addItem( url : String, context : * = null ) : LoadingItem
    {
        var item : LoadingItem = new LoadingItem( url, context )
            item.addEventListener( LoadingItemEvent.COMPLETE, item_completeHandler )
            item.addEventListener( LoadingItemEvent.ERROR, item_errorHandler )
                
        // add item to front (LIFO)
        queue.unshift( item )
        processQueue()
        return item
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods: Internal
    //
    //--------------------------------------------------------------------------
    
    private function processQueue() : void
    {
        while( queue.length > 0 && connections.length < MAX_CONNECTIONS )
        {
            var item : LoadingItem = LoadingItem( queue.shift() )
            connections.push( item )
            item.load()
        }
    }
    
    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------
    
    private function item_completeHandler( event : LoadingItemEvent ) : void
    {
        var index : int = connections.indexOf( event.item )

        if( index > 0 )
           connections.splice( index, 1 )   
        
        processQueue()
    }
    
    private function item_errorHandler( event : LoadingItemEvent ) : void
    {
        item_completeHandler( event )
    }
}

}