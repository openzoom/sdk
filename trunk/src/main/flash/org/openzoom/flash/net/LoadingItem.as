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

import flash.display.Bitmap;
import flash.display.Loader;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.HTTPStatusEvent;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLRequest;

import org.openzoom.flash.events.LoadingItemEvent;
    

public class LoadingItem extends EventDispatcher
{
    public function LoadingItem( url : String, context : * = null )
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
       loader.contentLoaderInfo.addEventListener( Event.COMPLETE, contentLoaderInfo_completeHandler, false, 0, true )           
       loader.contentLoaderInfo.addEventListener( HTTPStatusEvent.HTTP_STATUS, contentLoaderInfo_httpStatusHandler, false, 0, true )
       loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, contentLoaderInfo_ioErrorHandler, false, 0, true )
       loader.contentLoaderInfo.addEventListener( SecurityErrorEvent.SECURITY_ERROR, contentLoaderInfo_securityErrorHandler, false, 0, true )
       loader.load( request )
    }
    
    private function contentLoaderInfo_completeHandler( event : Event ) : void
    {
        var bitmap : Bitmap = loader.content as Bitmap
        
        // TODO: FP10 (Loader::unloadAndStop)
        loader.unload()
        removeEventListeners()
        loader = null
        
        var loadingItemEvent : LoadingItemEvent =
                new LoadingItemEvent( LoadingItemEvent.COMPLETE )
            loadingItemEvent.item = this
            loadingItemEvent.data = bitmap
            loadingItemEvent.context = context
            
        dispatchEvent( loadingItemEvent )
    }
    
    private function contentLoaderInfo_httpStatusHandler( event : HTTPStatusEvent ) : void
    {
        var loadingItemEvent : LoadingItemEvent =
                new LoadingItemEvent( LoadingItemEvent.ERROR )
            loadingItemEvent.item = this
            
        dispatchEvent( loadingItemEvent )
    }
    
    private function contentLoaderInfo_ioErrorHandler( event : IOErrorEvent ) : void
    {
        var loadingItemEvent : LoadingItemEvent =
                new LoadingItemEvent( LoadingItemEvent.ERROR )
            loadingItemEvent.item = this
            
        dispatchEvent( loadingItemEvent )
    }
    
    private function contentLoaderInfo_securityErrorHandler( event : SecurityErrorEvent ) : void
    {
        var tileEvent : LoadingItemEvent = new LoadingItemEvent( LoadingItemEvent.ERROR )
            tileEvent.item = this
            
        dispatchEvent( tileEvent )
    }
    
    private function removeEventListeners() : void
    {
        loader.contentLoaderInfo.removeEventListener( Event.COMPLETE, contentLoaderInfo_completeHandler )           
        loader.contentLoaderInfo.removeEventListener( HTTPStatusEvent.HTTP_STATUS, contentLoaderInfo_httpStatusHandler )
        loader.contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR, contentLoaderInfo_ioErrorHandler )
        loader.contentLoaderInfo.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, contentLoaderInfo_securityErrorHandler )
    }
}

}