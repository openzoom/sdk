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

import flash.display.Bitmap;
import flash.display.Loader;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.HTTPStatusEvent;
import flash.events.IOErrorEvent;
import flash.net.URLRequest;

import org.openzoom.events.TileRequestEvent;
    

public class TileRequest extends EventDispatcher
{
    public static const COMPLETE : String = "complete"
    
    public function TileRequest( url : String, context : * = null )
    {
        this.url = url
        this.context = context
    }
    
    private var context : *
    private var loader : Loader
    private var url : String
    
    public function start() : void
    {
       var request : URLRequest = new URLRequest( url )
       loader = new Loader()
       loader.contentLoaderInfo.addEventListener( Event.COMPLETE, contentLoaderInfo_completeHandler )           
       loader.contentLoaderInfo.addEventListener( HTTPStatusEvent.HTTP_STATUS, contentLoaderInfo_httpStatusHandler )
       loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, contentLoaderInfo_ioErrorHandler )
       loader.load( request )
    }
    
    private function contentLoaderInfo_completeHandler( event : Event ) : void
    {
        var bitmap : Bitmap = loader.content as Bitmap
        
        // TODO: FP10 (Loader::unloadAndStop)
        loader.unload()
        removeEventListeners()
        loader = null
        
        var tileEvent : TileRequestEvent = new TileRequestEvent( TileRequestEvent.COMPLETE )
            tileEvent.request = this
            tileEvent.data = bitmap
            tileEvent.context = context
            
        dispatchEvent( tileEvent )
    }
    
    private function contentLoaderInfo_httpStatusHandler( event : HTTPStatusEvent ) : void
    {
    }
    
    private function contentLoaderInfo_ioErrorHandler( event : IOErrorEvent ) : void
    {
    }
    
    private function removeEventListeners() : void
    {
        loader.contentLoaderInfo.removeEventListener( Event.COMPLETE, contentLoaderInfo_completeHandler )           
        loader.contentLoaderInfo.removeEventListener( HTTPStatusEvent.HTTP_STATUS, contentLoaderInfo_httpStatusHandler )
        loader.contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR, contentLoaderInfo_ioErrorHandler )
    }
}

}