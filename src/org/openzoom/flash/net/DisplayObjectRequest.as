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

import flash.display.DisplayObject;
import flash.display.Loader;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLRequest;
import flash.system.LoaderContext;

import org.openzoom.flash.core.openzoom_internal;
import org.openzoom.flash.events.NetworkRequestEvent;

use namespace openzoom_internal;

/**
 * @private
 *
 * Represents a single DisplayObject item to load.
 */
internal final class DisplayObjectRequest extends EventDispatcher
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
		// TODO Add error handling
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
//      // TODO
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
