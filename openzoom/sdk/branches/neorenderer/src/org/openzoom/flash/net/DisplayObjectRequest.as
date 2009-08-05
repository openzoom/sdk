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

import flash.display.DisplayObject;
import flash.display.Loader;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.HTTPStatusEvent;
import flash.events.IEventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLRequest;
import flash.system.LoaderContext;

import org.openzoom.flash.events.NetworkRequestEvent;

/**
 * @private
 *
 * Represents a single DisplayObject item to load.
 */
internal final class DisplayObjectRequest extends EventDispatcher
                                          implements INetworkRequest
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function DisplayObjectRequest(url:String, context:*=null)
    {
        _url = url
        this.context = context
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var context:*
    private var loader:Loader

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  bytesLoaded
    //----------------------------------

    public function get bytesLoaded():uint
    {
        return loader ? loader.contentLoaderInfo.bytesLoaded : 0
    }

    //----------------------------------
    //  bytesTotal
    //----------------------------------

    public function get bytesTotal():uint
    {
        return loader ? loader.contentLoaderInfo.bytesTotal : 0
    }

    //----------------------------------
    //  url
    //----------------------------------
    
    private var _url:String

    public function get url():String
    {
        return _url
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     * @inheritDoc
     */
    public function start():void
    {
       var request:flash.net.URLRequest = new flash.net.URLRequest(url)
       loader = new Loader()
       addEventListeners(loader.contentLoaderInfo)
       
       // TODO: Does this incur an overhead?
       var loaderContext:LoaderContext = new LoaderContext(true)
       loader.load(request, loaderContext)
    }

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    private function request_completeHandler(event:Event):void
    {
        var displayObject:DisplayObject = loader.content as DisplayObject

        disposeLoader()

        var requestEvent:NetworkRequestEvent =
                new NetworkRequestEvent(NetworkRequestEvent.COMPLETE)
            requestEvent.request = this
            requestEvent.data = displayObject
            requestEvent.context = context

        dispatchEvent(requestEvent)
    }

//    /**
//     * @private
//     */
//    private function request_httpStatusHandler(event:HTTPStatusEvent):void
//    {
//    	// TODO
//    }

    /**
     * @private
     */
    private function request_ioErrorHandler(event:IOErrorEvent):void
    {
        trace("[DisplayObjectRequest]", "IO error")
        
    	// TODO: Test
    	disposeLoader()    	
        var requestEvent:NetworkRequestEvent =
                new NetworkRequestEvent(NetworkRequestEvent.ERROR)
            requestEvent.request = this

        dispatchEvent(requestEvent)
    }

    /**
     * @private
     */
    private function request_securityErrorHandler(event:SecurityErrorEvent):void
    {
        trace("[DisplayObjectRequest]", "Security error")
        
    	// TODO: Test
        disposeLoader()
        
        var requestEvent:NetworkRequestEvent =
                new NetworkRequestEvent(NetworkRequestEvent.ERROR)
            requestEvent.request = this

        dispatchEvent(requestEvent)
    }

    /**
     * @private
     */
    private function request_progressHandler(event:ProgressEvent):void
    {
        dispatchEvent(event)
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: IDisposable
    //
    //--------------------------------------------------------------------------

    /**
     * @inheritDoc
     */
    public function dispose():void
    {
    	disposeLoader()
    	context = null
    	_url = null
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Internal
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    private function disposeLoader():void
    {
        if (!loader)
           return
        
        // Use Flash Player 10 API for unloading
        // @see mx.controls.SWFLoader#load() (1315)
        var useUnloadAndStop:Boolean = true
        var unloadAndStopGC:Boolean = true

        if (useUnloadAndStop && "unloadAndStop" in loader)
            loader["unloadAndStop"](unloadAndStopGC)
        else
            loader.unload()

        removeEventListeners(loader.contentLoaderInfo)
        loader = null
    } 

    /**
     * @private
     */
    private function addEventListeners(target:IEventDispatcher):void
    {
       target.addEventListener(Event.COMPLETE,
                               request_completeHandler,
                               false, 0, true)
       target.addEventListener(ProgressEvent.PROGRESS,
                               request_progressHandler,
                               false, 0, true)
//       target.addEventListener(HTTPStatusEvent.HTTP_STATUS,
//                               request_httpStatusHandler,
//                               false, 0, true)
       target.addEventListener(IOErrorEvent.IO_ERROR,
                               request_ioErrorHandler,
                               false, 0, true)
       target.addEventListener(SecurityErrorEvent.SECURITY_ERROR,
                               request_securityErrorHandler,
                               false, 0, true)
    }

    /**
     * @private
     */
    private function removeEventListeners(target:IEventDispatcher):void
    {
        target.removeEventListener(Event.COMPLETE,
                                   request_completeHandler)
        target.removeEventListener(ProgressEvent.PROGRESS,
                                   request_progressHandler)
//        target.removeEventListener(HTTPStatusEvent.HTTP_STATUS,
//                                   request_httpStatusHandler)
        target.removeEventListener(IOErrorEvent.IO_ERROR,
                                   request_ioErrorHandler)
        target.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,
                                   request_securityErrorHandler)
    }
}

}
