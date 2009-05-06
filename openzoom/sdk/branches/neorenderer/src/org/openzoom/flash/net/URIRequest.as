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

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.HTTPStatusEvent;
import flash.events.IEventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;

import org.openzoom.flash.events.NetworkRequestEvent;

/**
 * @private
 *
 * Represents a single item to load from a URI.
 */
internal class URIRequest extends EventDispatcher
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
    public function URIRequest(url:String, context:*=null)
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
    private var loader:URLLoader
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
        return loader ? loader.bytesLoaded : 0
    }

    //----------------------------------
    //  bytesTotal
    //----------------------------------

    public function get bytesTotal():uint
    {
        return loader ? loader.bytesTotal : 0
    }

    //----------------------------------
    //  uri
    //----------------------------------

    public function get uri():String
    {
        return url
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
       loader = new URLLoader()
       addEventListeners(loader)
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
        var data:String = loader.data

        cleanUp()

        var requestEvent:NetworkRequestEvent =
                new NetworkRequestEvent(NetworkRequestEvent.COMPLETE)
            requestEvent.request = this
            requestEvent.data = data
            requestEvent.context = context
//            requestEvent.uri = uri

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
//        cleanUp()

        var requestEvent:NetworkRequestEvent =
                new NetworkRequestEvent(NetworkRequestEvent.ERROR)
            requestEvent.request = this
//            requestEvent.uri = uri

        dispatchEvent(requestEvent)
    }

    /**
     * @private
     */
    private function request_securityErrorHandler(event:SecurityErrorEvent):void
    {
        // FIXME
//        cleanUp()

        var requestEvent:NetworkRequestEvent =
                new NetworkRequestEvent(NetworkRequestEvent.ERROR)
            requestEvent.request = this
//            requestEvent.uri = uri

        dispatchEvent(requestEvent)
    }

    /**
     * @private
     */
    private function request_progressHandler(event:ProgressEvent):void
    {
        // Forward event
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
        removeEventListeners(loader)
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
        target.removeEventListener(ProgressEvent.PROGRESS,
                                   request_progressHandler)
    }
}

}
