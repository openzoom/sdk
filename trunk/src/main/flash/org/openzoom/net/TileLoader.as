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
package org.openzoom.net
{

import org.openzoom.events.TileRequestEvent;
	
public class TileLoader
{
	private static const MAX_CONNECTIONS : uint = 20
	
    private var stack : Array /* of TileRequests */ = []
    private var connections : Array /* of TileRequests */ = []
	
    public function TileLoader()
    {
    }
    
    public function add( url : String, context : * = null ) : TileRequest
    {
    	var request : TileRequest = new TileRequest( url, context )
            request.addEventListener( TileRequestEvent.COMPLETE, tileRequest_completeHandler )
            request.addEventListener( TileRequestEvent.ERROR, tileRequest_errorHandler )
            	
    	stack.unshift( request )
    	processQueue()
    	return request
    }
    
    private function processQueue() : void
    {
    	while( stack.length > 0 && connections.length < MAX_CONNECTIONS )
    	{
	    	var request : TileRequest = TileRequest( stack.shift() )
	    	connections.push( request )
	    	request.start()
    	}
    }
    
    private function tileRequest_completeHandler( event : TileRequestEvent ) : void
    {
        var index : int = connections.indexOf( event.request )

        if( index > 0 )
           connections.splice( index, 1 )   
        
        processQueue()
    }
    
    private function tileRequest_errorHandler( event : TileRequestEvent ) : void
    {
        tileRequest_completeHandler( event )
//        trace( "TileRequest Error: ", event.data )
    }
}

}