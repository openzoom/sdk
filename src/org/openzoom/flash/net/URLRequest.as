////////////////////////////////////////////////////////////////////////////////
//
//  OpenZoom
//
//  Copyright (c) 2007-2010, Daniel Gasienica <daniel@gasienica.ch>
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

import org.openzoom.flash.core.openzoom_internal;
import org.openzoom.flash.events.NetworkRequestEvent;

use namespace openzoom_internal;

/**
 * @private
 *
 * Represents a single request to load from an URL.
 */
internal final class URLRequest extends EventDispatcher
                                implements INetworkRequest
{
	include "../core/Version.as"

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function URLRequest(url:String, context:*=null)
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
    private var loader:URLLoader

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

        disposeLoader()

        var requestEvent:NetworkRequestEvent =
                new NetworkRequestEvent(NetworkRequestEvent.COMPLETE)
            requestEvent.request = this
            requestEvent.data = data
            requestEvent.context = context

        dispatchEvent(requestEvent)
    }

    /**
     * @private
     */
    private function request_httpStatusHandler(event:HTTPStatusEvent):void
    {
        // TODO
    }

    /**
     * @private
     */
    private function request_ioErrorHandler(event:IOErrorEvent):void
    {
        trace("[URLRequest]", "IO error")

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
        trace("[URLRequest]", "Security error")

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
        // Forward event
        dispatchEvent(event)
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Internal
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

    private function disposeLoader():void
    {
        if (!loader)
           return

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
//       target.addEventListener(HTTPStatusEvent.HTTP_STATUS,
//                               request_httpStatusHandler,
//                               false, 0, true)
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
//        target.removeEventListener(HTTPStatusEvent.HTTP_STATUS,
//                                   request_httpStatusHandler)
        target.removeEventListener(IOErrorEvent.IO_ERROR,
                                   request_ioErrorHandler)
        target.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,
                                   request_securityErrorHandler)
        target.removeEventListener(ProgressEvent.PROGRESS,
                                   request_progressHandler)
    }
}

}
