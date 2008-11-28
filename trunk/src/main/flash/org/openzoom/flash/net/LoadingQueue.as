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
 * Basic queue loader for image tiles.
 */
public class LoadingQueue
{
	private static const MAX_CONNECTIONS : uint = 20
	
    private var queue : Array /* of TileRequests */ = []
    private var connections : Array /* of TileRequests */ = []
	
    public function LoadingQueue()
    {
    }
    
    public function addItem( url : String, context : * = null ) : LoadingItem
    {
    	var request : LoadingItem = new LoadingItem( url, context )
            request.addEventListener( LoadingItemEvent.COMPLETE, request_completeHandler )
            request.addEventListener( LoadingItemEvent.ERROR, request_errorHandler )
            	
    	queue.unshift( request )
    	processQueue()
    	return request
    }
    
    private function processQueue() : void
    {
    	while( queue.length > 0 && connections.length < MAX_CONNECTIONS )
    	{
	    	var request : LoadingItem = LoadingItem( queue.shift() )
	    	connections.push( request )
	    	request.start()
    	}
    }
    
    private function request_completeHandler( event : LoadingItemEvent ) : void
    {
        var index : int = connections.indexOf( event.item )

        if( index > 0 )
           connections.splice( index, 1 )   
        
        processQueue()
    }
    
    private function request_errorHandler( event : LoadingItemEvent ) : void
    {
        request_completeHandler( event )
//        trace( "TileRequest Error: ", event.data )
    }
}

}