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

import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.utils.getTimer;

import org.openzoom.flash.core.openzoom_internal;
import org.openzoom.flash.descriptors.IImagePyramidDescriptor;
import org.openzoom.flash.descriptors.IImagePyramidLevel;
import org.openzoom.flash.descriptors.deepzoom.DeepZoomImageDescriptor;
import org.openzoom.flash.events.ViewportEvent;
import org.openzoom.flash.net.INetworkQueue;
import org.openzoom.flash.scene.IMultiScaleScene;
import org.openzoom.flash.scene.IReadonlyMultiScaleScene;
import org.openzoom.flash.utils.Cache;
import org.openzoom.flash.utils.IDisposable;
import org.openzoom.flash.utils.MortonOrder;
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
    
    private static const MAX_CACHE_SIZE:uint = 200

    private static const MAX_DOWNLOADS_STATIC:uint = 4
//    private static const MAX_DOWNLOADS_DYNAMIC:uint = 4

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

        this.loader = loader
        tileCache = new Cache(MAX_CACHE_SIZE)
        this.owner = owner
        tileLoader = new TileLoader(this,
                                    loader,
                                    tileCache,
                                    MAX_DOWNLOADS_STATIC)

        this.viewport.addEventListener(ViewportEvent.TRANSFORM_UPDATE,
                                       viewport_transformUpdateHandler,
                                       false, 0, true)

//        this.viewport.addEventListener(ViewportEvent.TRANSFORM_START,
//                                       viewport_transformStartHandler,
//                                       false, 0, true)
//
//        this.viewport.addEventListener(ViewportEvent.TRANSFORM_END,
//                                       viewport_transformEndHandler,
//                                       false, 0, true)

        // Render loop
        owner.addEventListener(Event.ENTER_FRAME,
                               enterFrameHandler,
                               false, 0, true)

//        setInterval(enterFrameHandler, 500, null)
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
    private var tileLoader:TileLoader

    private var invalidateDisplayListFlag:Boolean = true

    private var tileCache:Cache

    //--------------------------------------------------------------------------
    //
    //  Methods: Validation/Invalidation
    //
    //--------------------------------------------------------------------------
    
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
//            // TODO: Validate renderers from the transformation origin outwards
//            var nextRenderer:ImagePyramidRenderer
//
//            var center:Point = viewport.center
//            center.x *= scene.sceneWidth
//            center.y *= scene.sceneHeight
//
//            for each (var renderer:ImagePyramidRenderer in renderers)
//            {
//                var dx:Number = renderer.x - center.x
//                var dy:Number = renderer.y - center.y
//                var distance:Number = dx*dx + dy*dy
//                renderer.openzoom_internal::distance =  distance
//                
//                if (!nextRenderer && !validated[renderer])
//                    nextRenderer = renderer
//    
//                if (!validated[renderer] && distance <= nextRenderer.openzoom_internal::distance)
//                    nextRenderer = renderer
//            }
//    
//            if (nextRenderer)
//            {
//                updateDisplayList(nextRenderer)
//                validated[nextRenderer] = true
//                invalidateDisplayList()
//            }
//            else
//            {
//                // Mark as validated
//                invalidateDisplayListFlag = false
//                validated = new Dictionary()
//            }

//            for each (var renderer:ImagePyramidRenderer in renderers)
//                updateDisplayList(renderer)

            var numRenderers:int = renderers.length
            for (var i:int = 0; i < numRenderers; i++)
                updateDisplayList(renderers[i])

//            for (var i:int = currentIndex; i < Math.min(currentIndex + 100, renderers.length); i++)
//                updateDisplayList(renderers[i])
//            
//            currentIndex = (currentIndex + 100) % renderers.length    

        }
    }
    
//    private var currentIndex:int = 0
//    private var validated:Dictionary = new Dictionary()
    
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
        // Abort if we're not visible
        if (!renderer.visible)
            return

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

        var toLevel:int
        var fromLevel:int

        toLevel = 0
        fromLevel = optimalLevel.index

        var level:IImagePyramidLevel
        var nextTile:ImagePyramidTile
        var renderingQueue:Array = []

        // Iterate over levels
        for (var l:int = fromLevel; l >= toLevel; --l)
        {
            var done:Boolean = true
            level = descriptor.getLevelAt(l)

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

            // FIXME: Currently center, calculate origin
            var t:Point = new Point(0.5, 0.5) // viewport.transform.origin
            var origin:Point = new Point((1 - t.x) * fromTile.x + t.x * toTile.x,
                                         (1 - t.y) * fromTile.y + t.y * toTile.y)

            // Iterate over columns
            for (var c:int = fromTile.x; c <= toTile.x; c++)
            {
                // Iterate over rows
                for (var r:int = fromTile.y; r <= toTile.y; r++)
                {
                    var tile:ImagePyramidTile = renderer.openzoom_internal::getTile(l, c, r)

                    if (!tile.source)
                    {
                        if (tileCache.contains(tile.url))
                        {
                            var sourceTile:SourceTile = tileCache.get(tile.url) as SourceTile
                            tile.source = sourceTile
                            tile.loading = false
                        }
                    }

                    var dx:Number = tile.column - origin.x
                    var dy:Number = tile.row - origin.y
                    var distance:Number = dx * dx + dy * dy
                    tile.distance = distance

                    if (!tile.loaded)
                    {
                        if (!tile.loading && (!nextTile || tile.compareTo(nextTile) >= 0))
                            nextTile = tile

                        done = false
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
                    var levelAlpha:Number = 1.0//Math.min(1, stageBounds.width / level.width)
//                    trace(level.width / stageBounds.width, l)
//                    trace(stageBounds)
                    tile.alpha = Math.min(1, currentAlpha) * levelAlpha

                    if (tile.alpha < 1)
                        done = false

                    renderingQueue.push(tile)
               }
            }

            if (done)
                break
        }

        if (nextTile)
        {
            tileLoader.loadTile(nextTile)
            invalidateDisplayList()
        }

        // Prepare tile layer
        var tileLayer:Shape = renderer.openzoom_internal::tileLayer
        var g:Graphics = tileLayer.graphics
        g.clear()
        g.beginFill(0xFF0000, 0)
        g.drawRect(0, 0, descriptor.width, descriptor.height)
        g.endFill()

        tileLayer.width = renderer.width
        tileLayer.height = renderer.height

        while (renderingQueue.length > 0)
        {
            tile = renderingQueue.pop()

            var textureMap:BitmapData

            if (tile.alpha < 1)
            {
                invalidateDisplayList()

                textureMap = new BitmapData(tile.bitmapData.width,
                                            tile.bitmapData.height)

                var alphaMultiplier:uint = (tile.alpha * 256) << 24
                var alphaMap:BitmapData

                alphaMap = new BitmapData(tile.bitmapData.width,
                                          tile.bitmapData.height,
                                          true,
                                          alphaMultiplier | 0x00000000)

                textureMap.copyPixels(tile.bitmapData,
                                      tile.bitmapData.rect,
                                      ZERO_POINT,
                                      alphaMap)
            }
            else
            {

                textureMap = tile.bitmapData
            }

            // Draw tiles
            level = descriptor.getLevelAt(tile.level)
            var matrix:Matrix = new Matrix()
            var sx:Number
            var sy:Number
            var dziDescriptor:DeepZoomImageDescriptor = descriptor as DeepZoomImageDescriptor

            if (!(dziDescriptor &&
                  dziDescriptor.collection &&
                  tile.level <= dziDescriptor.collection.maxLevel))
            {
                sx = descriptor.width / level.width
                sy = descriptor.height / level.height
                matrix.createBox(sx, sy, 0, tile.bounds.x * sx, tile.bounds.y * sy)
            }
            else
            {
                var levelSize:uint = 1 << tile.level // Math.pow(2, tile.level)
                var position:Point = MortonOrder.getPosition(dziDescriptor.mortonNumber)
                var tileSize:uint = dziDescriptor.collection.tileSize
                var offsetX:uint = (position.x * levelSize) % tileSize
                var offsetY:uint = (position.y * levelSize) % tileSize
                sx = descriptor.width / level.width
                sy = descriptor.height / level.height
//                matrix.translate(-offsetX, -offsetY)
//                matrix.scale(sx, sy)
                matrix.createBox(sx, sy, 0, -offsetX * sx, -offsetY * sy)
            }


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

    private static const ZERO_POINT:Point = new Point(0, 0)
    
    //--------------------------------------------------------------------------
    //
    //  Event handlers
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

//    /**
//     * @private
//     */
//    private function viewport_transformStartHandler(event:ViewportEvent):void
//    {
//        if (tileLoader)
//            tileLoader.maxDownloads = MAX_DOWNLOADS_DYNAMIC
//    }
//
//    /**
//     * @private
//     */
//    private function viewport_transformEndHandler(event:ViewportEvent):void
//    {
//        if (tileLoader)
//            tileLoader.maxDownloads = MAX_DOWNLOADS_STATIC
//
//        invalidateDisplayList()
//    }

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
