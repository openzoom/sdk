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
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.utils.Dictionary;
import flash.utils.getTimer;

import org.openzoom.flash.core.openzoom_internal;
import org.openzoom.flash.descriptors.IImagePyramidDescriptor;
import org.openzoom.flash.descriptors.IImagePyramidLevel;
import org.openzoom.flash.events.NetworkRequestEvent;
import org.openzoom.flash.events.ViewportEvent;
import org.openzoom.flash.net.INetworkQueue;
import org.openzoom.flash.net.INetworkRequest;
import org.openzoom.flash.scene.IMultiScaleScene;
import org.openzoom.flash.scene.IReadonlyMultiScaleScene;
import org.openzoom.flash.utils.Cache;
import org.openzoom.flash.utils.IDisposable;
import org.openzoom.flash.viewport.INormalizedViewport;

/**
 * Manages the rendering of all image pyramid renderers on stage.
 */
public final class ImagePyramidRenderManager implements IDisposable
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    private static const TILE_SHOW_DURATION:Number = 500 // milliseconds
    private static const MAX_CACHE_SIZE:uint = 100

    private static const MAX_CONCURRENT_DOWNLOADS:uint = 4

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function ImagePyramidRenderManager(owner:Sprite,
                                              scene:IMultiScaleScene,
                                              viewport:INormalizedViewport,
                                              loader:INetworkQueue)
    {
        this.scene = scene

        this.viewport = viewport
        this.viewport.addEventListener(ViewportEvent.TRANSFORM_UPDATE,
                                       viewport_transformUpdateHandler,
                                       false, 0, true)

        this.loader = loader

        openzoom_internal::tileCache = new Cache(MAX_CACHE_SIZE)

        this.owner = owner
        owner.addEventListener(Event.ENTER_FRAME,
                               enterFrameHandler,
                               false, 0, true)
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var renderers:Array /* of ImagePyramidRenderer */ = []

    private var owner:Sprite
    private var viewport:INormalizedViewport
    private var scene:IMultiScaleScene
    private var loader:INetworkQueue

    private var invalidateDisplayListFlag:Boolean = false

    openzoom_internal var tileCache:Cache
    private var pendingDownloads:Dictionary = new Dictionary()

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    private function updateDisplayList(renderer:ImagePyramidRenderer):void
    {
        var descriptor:IImagePyramidDescriptor = renderer.source

        // Abort if we have no descriptor
        if (!descriptor)
            return

        var viewport:INormalizedViewport = renderer.viewport
        var scene:IReadonlyMultiScaleScene = renderer.scene


        // Is renderer on scene?
        if (!viewport)
            return

        // Compute normalized scene bounds of renderer
        var sceneBounds:Rectangle = renderer.getBounds(scene.targetCoordinateSpace)
            sceneBounds.x /= scene.sceneWidth
            sceneBounds.y /= scene.sceneHeight
            sceneBounds.width /= scene.sceneWidth
            sceneBounds.height /= scene.sceneHeight

        // Visibility test
        var visible:Boolean = viewport.intersects(sceneBounds)

        if (!visible)
            return

        // Get viewport bounds (normalized)
        var viewportBounds:Rectangle = viewport.getBounds()

        // Compute normalized visible bounds in renderer coordinate system
        var localBounds:Rectangle = sceneBounds.intersection(viewportBounds)
        localBounds.offset(-sceneBounds.x, -sceneBounds.y)
        localBounds.x /= sceneBounds.width
        localBounds.y /= sceneBounds.height
        localBounds.width /= sceneBounds.width
        localBounds.height /= sceneBounds.height

        // Determine optimal level
        var stageBounds:Rectangle = renderer.getBounds(renderer.stage)
        var optimalLevel:IImagePyramidLevel = descriptor.getLevelForSize(stageBounds.width,
                                                                         stageBounds.height)

        // Render image pyramid from bottom up
        var currentTime:int = getTimer()

        var fromLevel:int
        var toLevel:int

        // FIXME: For collections it's too much work
        // to render from bottom of the image pyramid
//        var quality:int = 2
//        fromLevel = Math.max(0, optimalLevel.index - quality)
        fromLevel = 0
        toLevel = optimalLevel.index

        // Prepare tile layer
        var tileLayer:Shape = renderer.openzoom_internal::tileLayer
        var g:Graphics = tileLayer.graphics
        g.clear()
        g.beginFill(0xFF0000, 0)
        g.drawRect(0, 0, descriptor.width, descriptor.height)
        g.endFill()

        tileLayer.width = renderer.width
        tileLayer.height = renderer.height

        // Iterate over levels
        for (var l:int = fromLevel; l <= toLevel; l++)
        {
            var level:IImagePyramidLevel = descriptor.getLevelAt(l)

            // Load or draw visible tiles
            var fromPoint:Point = new Point(localBounds.left * level.width,
                                            localBounds.top * level.height)
            var toPoint:Point = new Point(localBounds.right * level.width,
                                          localBounds.bottom * level.height)
            var fromTile:Point = descriptor.getTileAtPoint(l, fromPoint)
            var toTile:Point = descriptor.getTileAtPoint(l, toPoint)

            var tileDistance:Number = Point.distance(fromTile, toTile)

            // FIXME: Safety
            if (tileDistance > 20)
            {
                trace("[ImagePyramidRenderManager] updateDisplayList: " +
                      "Tile distance too large.", tileDistance)
                continue
            }

            // Iterate over columns
            for (var c:int = fromTile.x; c <= toTile.x; c++)
            {
                // Iterate over rows
                for (var r:int = fromTile.y; r <= toTile.y; r++)
                {
                    var tile:ImagePyramidTile = renderer.openzoom_internal::getTile(l, c, r)

                    if (!renderer.ready && tile.level > 0)
                        return

                    if (!tile.loaded)
                    {
                        var downloadPossible:Boolean = numDownloads < MAX_CONCURRENT_DOWNLOADS

                        if (!tile.loading && downloadPossible)
                            loadTile(tile)

                        continue
                    }

                     // FIXME: Safety
                    if (!tile.bitmapData)
                    {
                        trace("[ImagePyramidRenderManager] updateDisplayList: " +
                                "Tile BitmapData missing.", tile.loaded, tile.loading)
                        continue
                    }

                    // Prepare alpha bitmap
                    if (tile.fadeStart == 0)
                        tile.fadeStart = currentTime

                    tile.source.lastAccessTime = currentTime

                    var duration:Number = TILE_SHOW_DURATION
                    var currentAlpha:Number = (currentTime - tile.fadeStart) / duration
                    tile.alpha = Math.min(1, currentAlpha)

                    if (tile.level == 0 && tile.alpha == 1)
                        renderer.ready = true

                    var textureMap:BitmapData

                    if (tile.alpha < 1)
                    {
                        invalidateDisplayList()

                        textureMap = new BitmapData(tile.bitmapData.width,
                                                    tile.bitmapData.height)

                        var alphaMultiplier:uint = (tile.alpha * 256) << 24
                        var alphaMap:BitmapData = new BitmapData(tile.bitmapData.width,
                                                                 tile.bitmapData.height,
                                                                 true,
                                                                 alphaMultiplier | 0x00000000)

                        textureMap.copyPixels(tile.bitmapData,
                                              tile.bitmapData.rect,
                                              new Point(),
                                              alphaMap)
                    }
                    else
                    {

                        textureMap = tile.bitmapData
                    }

                    // Draw tiles
                    var matrix:Matrix = new Matrix()
                    var sx:Number = descriptor.width / level.width
                    var sy:Number = descriptor.height / level.height
                    matrix.createBox(sx, sx, 0, tile.bounds.x * sx, tile.bounds.y * sy)

                    g.beginBitmapFill(textureMap,
                                      matrix,
                                      false, /* repeat */
                                      true /* smoothing */)
                    g.drawRect(tile.bounds.x * sx,
                               tile.bounds.y * sy,
                               tile.bounds.width * sx,
                               tile.bounds.height * sy)
                    g.endFill()
                }
            }
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Tile Cache
    //
    //--------------------------------------------------------------------------

    private var numDownloads:uint = 0

    private function loadTile(tile:ImagePyramidTile):void
    {
        if (pendingDownloads[tile.url])
           return

        pendingDownloads[tile.url] = true

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

    private function request_completeHandler(event:NetworkRequestEvent):void
    {
        numDownloads--

        var tile:ImagePyramidTile = event.context as ImagePyramidTile
        var bitmapData:BitmapData = Bitmap(event.data).bitmapData

        var sourceTile:SharedTile = new SharedTile(tile.url,
                                                          bitmapData,
                                                          tile.level)
        sourceTile.lastAccessTime = getTimer()
        openzoom_internal::tileCache.put(tile.url, sourceTile)
        tile.source = sourceTile
        tile.loading = false

        pendingDownloads[tile.url] = false

        invalidateDisplayList()
    }

    private function request_errorHandler(event:NetworkRequestEvent):void
    {
        trace("[ImagePyramidRenderManager] Tile failed to load:",
              event.request.url)

        numDownloads--
        invalidateDisplayList()
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Validation/Invalidation
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    private function enterFrameHandler(event:Event):void
    {
        // Rendering loop
        validateDisplayList()
    }

    /**
     * @private
     */
    private function viewport_transformUpdateHandler(event:ViewportEvent):void
    {
        invalidateDisplayList()
    }

    /**
     * @private
     */
    public function invalidateDisplayList():void
    {
        if (!invalidateDisplayListFlag)
            invalidateDisplayListFlag = true
    }

    /**
     * @private
     */
    public function validateDisplayList():void
    {
        if (invalidateDisplayListFlag)
        {
            // Mark as validated
            invalidateDisplayListFlag = false

            // TODO: Validate renderers from the transformation origin outwards
            for each (var renderer:ImagePyramidRenderer in renderers)
                updateDisplayList(renderer)
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Renderer management
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    public function addRenderer(renderer:ImagePyramidRenderer):ImagePyramidRenderer
    {
        if (renderers.indexOf(renderer) != -1)
            throw new ArgumentError("[ImagePyramidRenderManager] " +
                                    "Renderer already added.")

        if (renderers.length == 0)
            owner.addEventListener(Event.ENTER_FRAME,
                                   enterFrameHandler,
                                   false, 0, true)

        renderer.openzoom_internal::renderManager = this
        renderers.push(renderer)

        invalidateDisplayList()

        return renderer
    }

    /**
     * @private
     */
    public function removeRenderer(renderer:ImagePyramidRenderer):ImagePyramidRenderer
    {
        var index:int = renderers.indexOf(renderer)
        if (index == -1)
            throw new ArgumentError("[ImagePyramidRenderManager] " +
                                    "Renderer does not exist.")

        renderers.splice(index, 1)
        renderer.openzoom_internal::renderManager = null

        if (renderers.length == 0)
            owner.removeEventListener(Event.ENTER_FRAME,
                                      enterFrameHandler)

        return renderer
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: IDisposable
    //
    //--------------------------------------------------------------------------

    public function dispose():void
    {
        // Remove render loop
        owner.removeEventListener(Event.ENTER_FRAME,
                                  enterFrameHandler)

        // Remove render manager from all its renderers
        for each (var renderer:ImagePyramidRenderer in renderers)
            renderer.openzoom_internal::renderManager = null

        owner = null
        scene = null
        viewport = null
        loader = null

        openzoom_internal::tileCache.dispose()
        openzoom_internal::tileCache = null
    }
}

}
