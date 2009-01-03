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
import flash.events.SecurityErrorEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;

import org.openzoom.flash.events.LoadingItemEvent;

/**
 * @private
 *
 * Represents a single item to load from a URL.
 */
internal class URLLoadingItem extends EventDispatcher
                              implements ILoadingItem
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function URLLoadingItem( url : String, context : * = null )
    {
        this.url = url
        this.context = context
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var context : *
    private var loader : URLLoader
    private var url : String

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     * @inheritDoc
     */
    public function load() : void
    {
       var request : URLRequest = new URLRequest( url )
       loader = new URLLoader()
       addEventListeners( loader )
       loader.load( request )
    }

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    private function contentLoaderInfo_completeHandler( event : Event ) : void
    {
        var data : String = loader.data

        cleanUp()

        var loadingItemEvent : LoadingItemEvent =
                               new LoadingItemEvent( LoadingItemEvent.COMPLETE )
            loadingItemEvent.item = this
            loadingItemEvent.data = data
            loadingItemEvent.context = context

        dispatchEvent( loadingItemEvent )
    }

    /**
     * @private
     */
    private function contentLoaderInfo_httpStatusHandler(
                                                event : HTTPStatusEvent ) : void
    {
        // FIXME
//        cleanUp()

        var itemEvent : LoadingItemEvent =
                                  new LoadingItemEvent( LoadingItemEvent.ERROR )
            itemEvent.item = this

        dispatchEvent( itemEvent )
    }

    /**
     * @private
     */
    private function contentLoaderInfo_ioErrorHandler(
                                                   event : IOErrorEvent ) : void
    {
        // FIXME
//        cleanUp()

        var itemEvent : LoadingItemEvent =
                new LoadingItemEvent( LoadingItemEvent.ERROR )
            itemEvent.item = this

        dispatchEvent( itemEvent )
    }

    /**
     * @private
     */
    private function contentLoaderInfo_securityErrorHandler(
                                             event : SecurityErrorEvent ) : void
    {
        // FIXME
//        cleanUp()

        var itemEvent : LoadingItemEvent =
                new LoadingItemEvent( LoadingItemEvent.ERROR )
            itemEvent.item = this

        dispatchEvent( itemEvent )
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Internal
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    private function cleanUp() : void
    {
        removeEventListeners( loader )
        loader = null
    }

    /**
     * @private
     */
    private function addEventListeners( target : IEventDispatcher ) : void
    {
       target.addEventListener( Event.COMPLETE,
                                contentLoaderInfo_completeHandler,
                                false, 0, true )
       target.addEventListener( HTTPStatusEvent.HTTP_STATUS,
                                contentLoaderInfo_httpStatusHandler,
                                false, 0, true )
       target.addEventListener( IOErrorEvent.IO_ERROR,
                                contentLoaderInfo_ioErrorHandler,
                                false, 0, true )
       target.addEventListener( SecurityErrorEvent.SECURITY_ERROR,
                                contentLoaderInfo_securityErrorHandler,
                                false, 0, true )
    }

    /**
     * @private
     */
    private function removeEventListeners( target : IEventDispatcher ) : void
    {
        target.removeEventListener( Event.COMPLETE,
                                    contentLoaderInfo_completeHandler )
        target.removeEventListener( HTTPStatusEvent.HTTP_STATUS,
                                    contentLoaderInfo_httpStatusHandler )
        target.removeEventListener( IOErrorEvent.IO_ERROR,
                                    contentLoaderInfo_ioErrorHandler )
        target.removeEventListener( SecurityErrorEvent.SECURITY_ERROR,
                                    contentLoaderInfo_securityErrorHandler )
    }
}

}