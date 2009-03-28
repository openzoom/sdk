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
import flash.display.Loader;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.HTTPStatusEvent;
import flash.events.IEventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLRequest;

import org.openzoom.flash.events.NetworkRequestEvent;
import org.openzoom.flash.renderers.images.Tile;

/**
 * @private
 *
 * Represents a single DisplayObject item to load.
 */
internal class DisplayObjectRequest extends EventDispatcher
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
    public function DisplayObjectRequest(url:String, context:* = null)
    {
        this.url = url
        this.context = context
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var context:*
    private var loader:Loader
    private var url:String
    
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
       var request:URLRequest = new URLRequest(url)
       loader = new Loader()
       addEventListeners(loader.contentLoaderInfo)
       loader.load(request)
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
        var bitmap:Bitmap = loader.content as Bitmap

        cleanUp()

        var requestEvent:NetworkRequestEvent =
                new NetworkRequestEvent(NetworkRequestEvent.COMPLETE)
            requestEvent.item = this
            requestEvent.data = bitmap
            requestEvent.context = context

        dispatchEvent(requestEvent)
    }

    /**
     * @private
     */
    private function request_httpStatusHandler(event:HTTPStatusEvent):void
    {
        // FIXME
//        cleanUp()

//        var requestEvent:NetworkRequestEvent =
//                new NetworkRequestEvent(NetworkRequestEvent.ERROR)
//            requestEvent.item = this
//
//        dispatchEvent(requestEvent)
    }

    /**
     * @private
     */
    private function request_ioErrorHandler(event:IOErrorEvent):void
    {
        // FIXME
//      cleanUp()

        trace("[DisplayObjectRequest]", "request_ioErrorHandler")
        var requestEvent:NetworkRequestEvent =
                new NetworkRequestEvent(NetworkRequestEvent.ERROR)
            requestEvent.item = this

        dispatchEvent(requestEvent)
    }

    /**
     * @private
     */
    private function request_securityErrorHandler(event:SecurityErrorEvent):void
    {
        // FIXME
//      cleanUp()

        trace("[DisplayObjectRequest]", "request_securityErrorHandler")
        var requestEvent:NetworkRequestEvent =
                new NetworkRequestEvent(NetworkRequestEvent.ERROR)
            requestEvent.item = this

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
    //  Methods: Internal
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    private function cleanUp():void
    {
        // Use Flash Player 10 API for unloading
        // @see mx.controls.SWFLoader#load() (1315)
        var useUnloadAndStop:Boolean = true
        var unloadAndStopGC:Boolean = true

        if(useUnloadAndStop && "unloadAndStop" in loader)
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
       target.addEventListener(HTTPStatusEvent.HTTP_STATUS,
                               request_httpStatusHandler,
                               false, 0, true)
       target.addEventListener(IOErrorEvent.IO_ERROR,
                               request_ioErrorHandler,
                               false, 0, true)
       target.addEventListener(SecurityErrorEvent.SECURITY_ERROR,
                               request_securityErrorHandler,
                               false, 0, true)
       target.addEventListener(ProgressEvent.PROGRESS,
                               request_progressHandler,
                               false, 0, true)
    }

    /**
     * @private
     */
    private function removeEventListeners(target:IEventDispatcher):void
    {
        target.removeEventListener(Event.COMPLETE,
                                   request_completeHandler)
        target.removeEventListener(HTTPStatusEvent.HTTP_STATUS,
                                   request_httpStatusHandler)
        target.removeEventListener(IOErrorEvent.IO_ERROR,
                                   request_ioErrorHandler)
        target.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,
                                   request_securityErrorHandler)
        target.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,
                                   request_progressHandler)
    }
}

}