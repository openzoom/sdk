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
import flash.events.ProgressEvent;

import org.openzoom.flash.events.NetworkRequestEvent;

/**
 * @private
 *
 * Basic loading queue for image tiles.
 */
public class NetworkQueue extends EventDispatcher
                          implements INetworkQueue
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    private static const MAX_CONNECTIONS:uint = 8

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function NetworkQueue()
    {
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var queue:Array /* of LoadingItem */ = []
    private var connections:Array /* of LoadingItem */ = []

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    public function addRequest(url:String,
                               type:Class,
                               context:*=null):INetworkRequest
    {
        var request:INetworkRequest

        // TODO
//        if (type == URLVariables)

        // TODO
//      if (type == Sound)

        // TODO
//      if (type == Video || type == NetStream)

        if (type == DisplayObject || type == Bitmap)
            request = new DisplayObjectRequest(url, context)

        if (type == String || type == XML)
            request = new URIRequest(url, context)

        if (!request)
            throw new ArgumentError("Type " + type.toString() + " not supported.")

        request.addEventListener(ProgressEvent.PROGRESS, request_progressHandler)
        request.addEventListener(NetworkRequestEvent.COMPLETE, request_completeHandler)
        request.addEventListener(NetworkRequestEvent.ERROR, request_errorHandler)

        // Add item to front (LIFO)
        queue.unshift(request)
        processQueue()
        return request
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Internal
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    private function processQueue():void
    {
        while (queue.length > 0 && connections.length < MAX_CONNECTIONS)
        {
            var item:INetworkRequest = INetworkRequest(queue.shift())
            connections.push(item)
            item.start()
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
    private function request_completeHandler(event:NetworkRequestEvent):void
    {
        var index:int = connections.indexOf(event.request)

        if (index > 0)
           connections.splice(index, 1)

        processQueue()
    }

    /**
     * @private
     */
    private function request_errorHandler(event:NetworkRequestEvent):void
    {
        trace("[NetworkQueue] item_errorHandler")
        request_completeHandler(event)
    }

    /**
     * @private
     */
    private function request_progressHandler(event:ProgressEvent):void
    {
        var bytesLoaded:uint = 0
        var bytesTotal:uint = 0

        for each (var request:INetworkRequest in connections)
        {
            bytesLoaded += request.bytesLoaded
            bytesTotal += request.bytesTotal
        }

        var progressEvent:ProgressEvent = new ProgressEvent(ProgressEvent.PROGRESS)
        progressEvent.bytesLoaded = bytesLoaded
        progressEvent.bytesTotal = bytesTotal
        dispatchEvent(progressEvent)
    }
}

}
