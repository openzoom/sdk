////////////////////////////////////////////////////////////////////////////////
//
//  OpenZoom SDK
//
//  Version: MPL 1.1/GPL 3/LGPL 3
//
//  The contents of this file are subject to the Mozilla Public License Version
//  1.1 (the "License"); you may not use this file except in compliance with
//  the License. You may obtain a copy of the License at
//  http://www.mozilla.org/MPL/
//
//  Software distributed under the License is distributed on an "AS IS" basis,
//  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
//  for the specific language governing rights and limitations under the
//  License.
//
//  The Original Code is the OpenZoom SDK.
//
//  The Initial Developer of the Original Code is Daniel Gasienica.
//  Portions created by the Initial Developer are Copyright (c) 2007-2010
//  the Initial Developer. All Rights Reserved.
//
//  Contributor(s):
//    Daniel Gasienica <daniel@gasienica.ch>
//
//  Alternatively, the contents of this file may be used under the terms of
//  either the GNU General Public License Version 3 or later (the "GPL"), or
//  the GNU Lesser General Public License Version 3 or later (the "LGPL"),
//  in which case the provisions of the GPL or the LGPL are applicable instead
//  of those above. If you wish to allow use of your version of this file only
//  under the terms of either the GPL or the LGPL, and not to allow others to
//  use your version of this file under the terms of the MPL, indicate your
//  decision by deleting the provisions above and replace them with the notice
//  and other provisions required by the GPL or the LGPL. If you do not delete
//  the provisions above, a recipient may use your version of this file under
//  the terms of any one of the MPL, the GPL or the LGPL.
//
////////////////////////////////////////////////////////////////////////////////
package org.openzoom.flash.net
{

import flash.display.Bitmap;
import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.ProgressEvent;

import org.openzoom.flash.core.openzoom_internal;
import org.openzoom.flash.events.NetworkRequestEvent;

use namespace openzoom_internal;

/**
 * @private
 *
 * Basic loading queue for all kinds of network objects.
 */
public final class NetworkQueue extends EventDispatcher
                                implements INetworkQueue
{
	include "../core/Version.as"

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
//      if (type == URLVariables)

        // TODO
//      if (type == Sound)

        // TODO
//      if (type == Video || type == NetStream)

        if (type == DisplayObject || type == Bitmap)
            request = new DisplayObjectRequest(url, context)

        if (type == String || type == XML)
            request = new URLRequest(url, context)

        if (!request)
            throw new ArgumentError("Type " + type.toString() + " not supported.")
            
        addEventListeners(request)

        // Add item to front (LIFO)
        if (queue.length == 0 && connections.length == 0)
            dispatchEvent(new Event(Event.INIT))

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

        if (index >= 0)
           connections.splice(index, 1)

        removeEventListeners(event.request)

        processQueue()

        if (queue.length == 0 && connections.length == 0)
            dispatchEvent(new Event(Event.COMPLETE))
    }

    /**
     * @private
     */
    private function request_errorHandler(event:NetworkRequestEvent):void
    {
        trace("[NetworkQueue] Error")
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

        var progressEvent:ProgressEvent =
                new ProgressEvent(ProgressEvent.PROGRESS)
        progressEvent.bytesLoaded = bytesLoaded
        progressEvent.bytesTotal = bytesTotal
        dispatchEvent(progressEvent)
    }
    
    private function addEventListeners(request:INetworkRequest):void
    {
        request.addEventListener(ProgressEvent.PROGRESS,
                                 request_progressHandler)
        request.addEventListener(NetworkRequestEvent.COMPLETE,
                                 request_completeHandler)
        request.addEventListener(NetworkRequestEvent.ERROR,
                                 request_errorHandler)
    }
    
    private function removeEventListeners(request:INetworkRequest):void
    {
        request.removeEventListener(ProgressEvent.PROGRESS,
                                    request_progressHandler)
        request.removeEventListener(NetworkRequestEvent.COMPLETE,
                                   request_completeHandler)
        request.removeEventListener(NetworkRequestEvent.ERROR,
                                    request_errorHandler)
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: IDisposable
    //
    //--------------------------------------------------------------------------
    
    public function dispose():void
    {
    	var request:INetworkRequest
        for each (request in queue)
        {
        	removeEventListeners(request)
            request.dispose()
        }
        
        queue = []
        
        for each (request in connections)
        {
        	removeEventListeners(request)
            request.dispose()
        }
        
        connections = []
            
    }    
}

}
