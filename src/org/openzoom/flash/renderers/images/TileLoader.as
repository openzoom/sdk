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
package org.openzoom.flash.renderers.images
{

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.events.EventDispatcher;
import flash.utils.Dictionary;
import flash.utils.getTimer;

import org.openzoom.flash.core.openzoom_internal;
import org.openzoom.flash.events.NetworkRequestEvent;
import org.openzoom.flash.net.INetworkQueue;
import org.openzoom.flash.net.INetworkRequest;
import org.openzoom.flash.utils.ICache;

use namespace openzoom_internal;

[ExcludeClass]
/**
 * @private
 */
internal final class TileLoader extends EventDispatcher
{
	include "../../core/Version.as"

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
