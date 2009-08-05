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
package org.openzoom.flash.renderers.images
{
    
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.events.EventDispatcher;
import flash.utils.Dictionary;
import flash.utils.getTimer;

import org.openzoom.flash.events.NetworkRequestEvent;
import org.openzoom.flash.net.INetworkQueue;
import org.openzoom.flash.net.INetworkRequest;
import org.openzoom.flash.utils.ICache;

/**
 * @private
 */
internal final class TileLoader extends EventDispatcher
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     * Constructor.
     */     
    public function TileLoader(owner:ImagePyramidRenderManager,
                               loader:INetworkQueue,
                               cache:ICache,
                               maxDownloads:int)
    {
        this.owner = owner
        this.loader = loader
        this.cache = cache
        
        this.maxDownloads = maxDownloads
    }
    
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    private var owner:ImagePyramidRenderManager
    private var loader:INetworkQueue
    private var cache:ICache
    
    internal var maxDownloads:int
    private var numDownloads:int
    private var pending:Dictionary = new Dictionary()

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */ 
    public function loadTile(tile:ImagePyramidTile):void
    {
        if (numDownloads >= maxDownloads)
            return
        
        if (pending[tile.url])
           return

        pending[tile.url] = true

        numDownloads++

        var request:INetworkRequest = loader.addRequest(tile.url, Bitmap, tile)

        request.addEventListener(NetworkRequestEvent.COMPLETE,
                                 request_completeHandler,
                                 false, 0, true)

        request.addEventListener(NetworkRequestEvent.ERROR,
                                 request_errorHandler,
                                 false, 0, true)

        tile.loading = true

    }

    /**
     * @private
     */ 
    private function request_completeHandler(event:NetworkRequestEvent):void
    {
        numDownloads--

        var tile:ImagePyramidTile = event.context as ImagePyramidTile
        var bitmapData:BitmapData = Bitmap(event.data).bitmapData

        var sourceTile:SourceTile = new SourceTile(tile.url,
                                                   bitmapData,
                                                   tile.level)
        sourceTile.lastAccessTime = getTimer()
        cache.put(tile.url, sourceTile)
        tile.source = sourceTile
        tile.loading = false

        pending[tile.url] = false

        owner.invalidateDisplayList()
    }

    /**
     * @private
     */ 
    private function request_errorHandler(event:NetworkRequestEvent):void
    {
        trace("[ImagePyramidRenderManager] Tile failed to load:", event.request.url)

        numDownloads--
        owner.invalidateDisplayList()
    }
}

}
