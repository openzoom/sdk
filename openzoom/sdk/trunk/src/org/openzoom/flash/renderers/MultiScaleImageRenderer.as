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
package org.openzoom.flash.renderers
{

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.Loader;
import flash.display.Shape;
import flash.events.Event;
import flash.events.TimerEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.utils.Timer;

import org.openzoom.flash.descriptors.IMultiScaleImageDescriptor;
import org.openzoom.flash.descriptors.IMultiScaleImageLevel;
import org.openzoom.flash.events.NetworkRequestEvent;
import org.openzoom.flash.events.RendererEvent;
import org.openzoom.flash.events.ViewportEvent;
import org.openzoom.flash.net.ILoaderClient;
import org.openzoom.flash.net.INetworkQueue;
import org.openzoom.flash.net.INetworkRequest;
import org.openzoom.flash.renderers.images.ITileLayer;
import org.openzoom.flash.renderers.images.RenderingMode;
import org.openzoom.flash.renderers.images.Tile;
import org.openzoom.flash.renderers.images.TileLayer;
import org.openzoom.flash.utils.math.clamp;
import com.flashdynamix.motion.TweensyZero;

/**
 * @private
 *
 * Generic renderer for multiscale images.
 */
public class MultiScaleImageRenderer extends Renderer
                                     implements ILoaderClient
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    private static const DEFAULT_BACKGROUND_SHOW_DURATION:Number = 2.5
    private static const DEFAULT_RENDERING_MODE:String = RenderingMode.SMOOTH

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function MultiScaleImageRenderer(descriptor:IMultiScaleImageDescriptor,
                                            loader:INetworkQueue,
                                            width:Number, height:Number)
    {
        addEventListener(RendererEvent.ADDED_TO_SCENE,
                         addedToSceneHandler,
                         false, 0, true)
                         
        addEventListener(RendererEvent.REMOVED_FROM_SCENE,
                         removedFromSceneHandler,
                         false, 0, true)
        _loader = loader
        this.descriptor = descriptor
        createFrame(width, height)

        // FIXME: Phase instantiation of layers
        createLayers(descriptor, frame.width, frame.height)

        // TODO: Debug
        createDebugLayer()

        // Load highest single tile level as background to prevent
        // artifacts between tiles in case we have a format that doesn't
        // feature tile overlap.
        if (descriptor.tileOverlap == 0 && renderingMode != RenderingMode.SMOOTH)
            loadBackground()
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var updateDisplayListTimer:Timer

    private var descriptor:IMultiScaleImageDescriptor
    private var backgroundLoader:Loader

    private var layers:Array /* of ITileLayer */ = []
    private var backgroundTile:Bitmap
    private var frame:Shape
    private var debugLayer:Shape

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  loader
    //----------------------------------

    private var _loader:INetworkQueue

    /**
     * @private
     */
    public function get loader():INetworkQueue
    {
        return _loader
    }

    public function set loader(value:INetworkQueue):void
    {
        _loader = value
    }

    //----------------------------------
    //  renderingMode
    //----------------------------------

    private var _renderingMode:String = DEFAULT_RENDERING_MODE

    /**
     * @private
     */
    public function get renderingMode():String
    {
        return _renderingMode
    }

    public function set renderingMode(value:String):void
    {
        _renderingMode = value
    }

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    private function addedToSceneHandler(event:RendererEvent):void
    {
        viewport.addEventListener(ViewportEvent.TRANSFORM_END,
                                  viewport_transformEndHandler,
                                  false, 0, true)
        updateDisplayList()
    } 

    /**
     * @private
     */
    private function removedFromSceneHandler(event:RendererEvent):void
    {
        viewport.removeEventListener(ViewportEvent.TRANSFORM_END,
                                     viewport_transformEndHandler)
    } 

    /**
     * @private
     */
    private function viewport_transformEndHandler(event:ViewportEvent):void
    {
        updateDisplayList()
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods: Internal
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    private function createFrame(width:Number, height:Number):void
    {
        frame = new Shape()
        var g:Graphics = frame.graphics
        g.beginFill(0x000000, 0)
        g.drawRect(0, 0, width, height)
        g.endFill()

        addChildAt(frame, 0)
    }

    /**
     * @private
     */
    private function createDebugLayer():void
    {
        debugLayer = new Shape()
        addChild(debugLayer)
    }

    /**
     * @private
     */
    private function drawVisibleRegion(region:Rectangle):void
    {
        var g:Graphics = debugLayer.graphics
            g.clear()
            g.lineStyle(0, 0xFF0000)
            g.beginFill(0x000000, 0)
            // TODO: Debug
//            g.drawRect(Math.max(0, region.x),
//                        Math.max(0, region.y),
//                        Math.min(frame.width, region.width),
//                        Math.min(frame.height, region.height))
            g.drawRect(region.x, region.y, region.width, region.height)
            g.endFill()
    }

    /**
     * @private
     */
    private function createLayers(descriptor:IMultiScaleImageDescriptor, width:Number, height:Number):void
    {
        for (var i:int = 0; i < descriptor.numLevels; i++)
        {
            var level:IMultiScaleImageLevel = descriptor.getLevelAt(i)
            var layer:TileLayer = new TileLayer(level.width, level.height, level)
//          var layer:TileLayer = new TileLayer(frame.width, frame.height, level)
            layers[i] = layer

            // FIXME: Very large layer dimensions cause problems...
            // Actually, they don't as long as their dimensions are powers of two.
            layer.width = width
            layer.height = height

            addChild(layer)
        }
    }

    /**
     * @private
     */
    private function loadBackground():void
    {
        var level:int = getHighestSingleTileLevel()

        if (!descriptor.existsTile(level, 0, 0))
            return

        var url:String = descriptor.getTileURL(level, 0, 0)

        var item:INetworkRequest = loader.addRequest(url, Bitmap)
            item.addEventListener(Event.COMPLETE,
                                  backgroundCompleteHandler)
    }

    /**
     * @private
     */
    private function updateDisplayList():void
    {
    	if (!viewport)
    	   return
    	
//        trace("[MultiScaleImageRender] updateDisplayList()")
//        debugLayer.graphics.clear()

        var bounds:Rectangle
            bounds = getBounds(viewport.scene.targetCoordinateSpace)

            bounds.x /= Math.abs(scaleX)
            bounds.y /= Math.abs(scaleY)
            bounds.width /= Math.abs(scaleX)
            bounds.height /= Math.abs(scaleY)

        var normalizedBounds:Rectangle = bounds.clone()
            normalizedBounds.x /= viewport.scene.sceneWidth
            normalizedBounds.y /= viewport.scene.sceneHeight
            normalizedBounds.width /= viewport.scene.sceneWidth
            normalizedBounds.height /= viewport.scene.sceneHeight

        // Return if we're not visible
        if (!viewport.intersects(normalizedBounds))
            return

        var visibleRegion:Rectangle = viewport.intersection(normalizedBounds)
        visibleRegion.offset(-bounds.x, -bounds.y)

//        drawVisibleRegion(visibleRegion)
        
        var scale:Number = viewport.scale
        var level:IMultiScaleImageLevel = descriptor.getMinLevelForSize(width * scale, height * scale)

        // TODO: remove all tiles from loading queue

        var firstLevel:int = level.index + 1
//
        for (var i:int = firstLevel; i < descriptor.numLevels; i++)
            getLayer(i).removeAllTiles()

        if (renderingMode == RenderingMode.SMOOTH)
        {
            for (var l:int = 0; l <= level.index; l++)
            {
                var currentLevel:IMultiScaleImageLevel = descriptor.getLevelAt(l)
                loadTiles(currentLevel, visibleRegion)
                
                // TODO: Phase loading of layers
//                setTimeout(loadTiles, i * 100, descriptor.getLevelAt(l), visibleRegion)
            }
        }
        else
        {
            loadTiles(level, visibleRegion)
        }
    }

    /**
     * @private
     */
    private function loadTiles(level:IMultiScaleImageLevel, area:Rectangle):void
    {
        // FIXME
        var minColumn:int = Math.max(0, Math.floor(area.left * level.numColumns / unscaledWidth) - 1)
        var maxColumn:int = Math.min(level.numColumns, Math.ceil(area.right * level.numColumns / unscaledWidth))
        var minRow:int = Math.max(0, Math.floor(area.top * level.numRows / unscaledHeight) - 1)
        var maxRow:int = Math.min(level.numRows, Math.ceil(area.bottom * level.numRows / unscaledHeight))

        var layer:ITileLayer = getLayer(level.index)
        var tiles:Array = []
        var center:Point = new Point((minColumn +  maxColumn) / 2,
                                       (minRow + maxRow) / 2)

        for (var column:int = minColumn; column < maxColumn; column++)
        {
            for (var row:int = minRow; row < maxRow; row++)
            {
                var tile:Tile = new Tile(null,
                                            level.index,
                                            row,
                                            column,
                                            descriptor.tileOverlap)

                var contained:Boolean = layer.containsTile(tile)
                var exists:Boolean =
                      descriptor.existsTile(tile.level, tile.column, tile.row)

                if (contained || !exists)
                    continue

                var url:String = descriptor.getTileURL(tile.level,
                                                          tile.column,
                                                          tile.row)

                // Prioritize tiles in the center of the screen
                var position:Point = new Point(tile.column, tile.row)
                var dx:Number = Math.abs(position.x - center.x)
                var dy:Number = Math.abs(position.y - center.y)
                var distance:Number = dx * dx + dy * dy
                tiles.push({url: url, tile: tile, distance: distance})
            }
        }

        tiles.sort(compareTiles, Array.DESCENDING)

        for (var i:int = 0; i < tiles.length; i++)
        {
            var t:Tile = tiles[i].tile
            var item:INetworkRequest = loader.addRequest(tiles[i].url, Bitmap, t)
                item.addEventListener(Event.COMPLETE,
                                      tileCompleteHandler,
                                      false, 0, true)
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Comparator
    //
    //--------------------------------------------------------------------------

    private function compareTiles(tile1:Object, tile2:Object):int
    {
        if (tile1.distance < tile2.distance)
           return -1
        if (tile1.distance > tile2.distance)
           return 1
        else
           return 0
    }

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

    private function updateDisplayListTimer_timerHandler(event:TimerEvent):void
    {
        updateDisplayList()
    }

    /**
     * @private
     */
    private function tileCompleteHandler(event:NetworkRequestEvent):void
    {
        var tile:Tile = event.context as Tile
            tile.bitmap = event.data

        var layer:ITileLayer = getLayer(tile.level)
        layer.addTile(tile)
    }

    /**
     * @private
     */
    private function backgroundCompleteHandler(event:NetworkRequestEvent):void
    {
        backgroundTile = event.data as Bitmap

        var level:IMultiScaleImageLevel = descriptor.getLevelAt(getHighestSingleTileLevel())
        var tooWide:Boolean = backgroundTile.width > level.width
        var tooHigh:Boolean = backgroundTile.height > level.height

        if (tooWide || tooHigh)
        {
            var cropBitmapData:BitmapData =
                   new BitmapData(Math.min(level.width, backgroundTile.width),
                                  Math.min(level.height, backgroundTile.height))
            cropBitmapData.copyPixels(backgroundTile.bitmapData,
                                      cropBitmapData.rect,
                                      new Point(0, 0))
            var croppedTileBitmap:Bitmap = new Bitmap(cropBitmapData)
            backgroundTile = croppedTileBitmap
        }

        backgroundTile.smoothing = true
        backgroundTile.width = frame.width
        backgroundTile.height = frame.height
        backgroundTile.alpha = 0

        addChildAt(backgroundTile, getChildIndex(frame))

//        backgroundTile.alpha = 1
        TweensyZero.to(backgroundTile, {alpha: 1}, DEFAULT_BACKGROUND_SHOW_DURATION)
    }

    //--------------------------------------------------------------------------
    //
    //  Properties: Internal
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    private function get unscaledWidth():Number
    {
        return width / Math.abs(scaleX)
    }

    /**
     * @private
     */
    private function get unscaledHeight():Number
    {
        return height / Math.abs(scaleY)
    }


    //--------------------------------------------------------------------------
    //
    //  Methods: Internal
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    private function getLayer(index:int):ITileLayer
    {
        return ITileLayer(layers[index])
    }

    /**
     * @private
     */
    private function getHighestSingleTileLevel():int
    {
        var level:IMultiScaleImageLevel

        for (var i:int = 0; i < descriptor.numLevels; i++)
        {
            level = descriptor.getLevelAt(i)

            if (level.numColumns != 1 || level.numRows != 1)
                break
        }

        var index:int = clamp(i - 1, 0, descriptor.numLevels - 1)
        return index
    }
}

}
