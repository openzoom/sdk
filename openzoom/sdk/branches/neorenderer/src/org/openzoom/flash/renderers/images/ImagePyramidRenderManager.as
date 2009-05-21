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
import flash.events.TimerEvent;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.utils.Dictionary;
import flash.utils.Timer;
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
import org.openzoom.flash.viewport.INormalizedViewport;

/**
 * Manages the rendering of all image pyramid renderers on stage.
 */
public final class ImagePyramidRenderManager
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------
    
    private static const FRAMES_PER_SECOND:Number = 30
    private static const TILE_SHOW_DURATION:Number = 500 // milliseconds
    private static const MAX_CACHE_SIZE:uint = 100
    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     * Constructor.
     */
    public function ImagePyramidRenderManager(scene:IMultiScaleScene,
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

        timer = new Timer(1000 / FRAMES_PER_SECOND)
        timer.addEventListener(TimerEvent.TIMER,
                               timer_timerHandler,
                               false, 0, true)
        timer.start()
    }
    
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var renderers:Array /* of ImagePyramidRenderer */ = []

    private var timer:Timer
    private var viewport:INormalizedViewport
    private var scene:IMultiScaleScene
    private var loader:INetworkQueue

    private var invalidateDisplayListFlag:Boolean = false
    
    openzoom_internal var tileCache:Cache
    
    openzoom_internal var tileBitmapDataCache:Dictionary /* of BitmapData */ = new Dictionary()
    openzoom_internal var tileBitmapData:Array /* of BitmapData */ = []
    openzoom_internal var urlTileMap:Dictionary /* of Array of Tile2 */ = new Dictionary()

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
        var descriptor:IImagePyramidDescriptor = renderer.source
        var stageBounds:Rectangle = renderer.getBounds(renderer.stage)
        var optimalLevel:IImagePyramidLevel = descriptor.getLevelForSize(stageBounds.width,
                                                                         stageBounds.height)
        
        // Render image pyramid from bottom up
        var currentTime:int = getTimer()
        
        var quality:int = 2
        var fromLevel:int
        var toLevel:int
        
        fromLevel = Math.max(0, optimalLevel.index - quality)
        toLevel = optimalLevel.index
        fromLevel = 0
//        toLevel = 0
        
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
                   
	        if (tileDistance > 10)
	        {
                trace("[ImagePyramidRenderManager] updateDisplayList: Tile distance too large.", tileDistance)
                continue
	        }
	        
	        // Iterate over columns
	        for (var c:int = fromTile.x; c <= toTile.x; c++)
	        {
	        	// Iterate over rows
		        for (var r:int = fromTile.y; r <= toTile.y; r++)
		        {
		        	var tile:Tile2 = renderer.openzoom_internal::getTile(l, c, r)
		        	
		        	if (!tile.loaded)
		        	{
                        var downloadPossible:Boolean = numDownloads < MAX_CONCURRENT_DOWNLOADS
                        
		        		if (!tile.loading && downloadPossible)
		        		    loadTile(tile)
		        		    
		        		continue
		        	}
		        	
		        	if (!tile.bitmapData)
		        	{
                        trace("[ImagePyramidRenderManager] updateDisplayList: Tile BitmapData missing.", tile.loaded, tile.loading)
                        continue		        		
		        	}

                    // Prepare alpha bitmap
                    if (tile.fadeStart == 0)
                    	tile.fadeStart = currentTime
                    
                    var duration:Number = TILE_SHOW_DURATION
                    
                    // Fade lowest level quicker
//                    if (tile.level == 0)
//                        duration = 100         

                    var currentAlpha:Number = (currentTime - tile.fadeStart) / duration
                	tile.alpha = Math.min(1, currentAlpha) 
                    	
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
    
    private static const MAX_CONCURRENT_DOWNLOADS:uint = 4
    private static const MAX_CACHE_ITEMS:uint = 1000
    private var numDownloads:uint = 0
    
    private function loadTile(tile:Tile2):void
    {
    	if (pendingDownloads[tile.url])
    	   return

    	pendingDownloads[tile.url] = true
    	
    	numDownloads++
    	
    	var request:INetworkRequest = loader.addRequest(tile.url, Bitmap, tile)
    	request.addEventListener(NetworkRequestEvent.COMPLETE,
    	                         request_completeHandler)
    	
    	tile.loading = true
    	
    }
    
    private function request_completeHandler(event:NetworkRequestEvent):void
    {
    	numDownloads--
    	event.request.removeEventListener(NetworkRequestEvent.COMPLETE,
    	                                  request_completeHandler)
    	                                  
    	var tile:Tile2 = event.context as Tile2
        var bitmapData:BitmapData = Bitmap(event.data).bitmapData
        
        // Cache not full
//        if (openzoom_internal::tileBitmapData.length < MAX_CACHE_ITEMS)
        {
	        openzoom_internal::tileBitmapDataCache[tile.url] = bitmapData 
        	openzoom_internal::tileBitmapData.push(bitmapData)
        }
//        // Cache full
//        else
//        {
//            // Evict oldest tile with highest level
//        	
//        	
//            trace("PRE:", openzoom_internal::tileBitmapData.length)
//            
//            var oldEntry:BitmapData = openzoom_internal::tileBitmapData.shift()
//            openzoom_internal::tileBitmapDataCache[tile.url] = null
//            oldEntry.dispose()
//            
//            trace("INV:", openzoom_internal::tileBitmapData.length, Math.random())
//            
//            openzoom_internal::tileBitmapData.push(bitmapData)
//            openzoom_internal::tileBitmapDataCache[tile.url] = bitmapData
//            
//            trace("POST:", openzoom_internal::tileBitmapData.length)
//        	
//        }
        
        tile.bitmapData = bitmapData
        tile.loaded = true
        tile.loading = false
        
        pendingDownloads[tile.url] = false
        
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
    private function timer_timerHandler(event:TimerEvent):void
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
            throw new ArgumentError("Renderer already added.")

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
            throw new ArgumentError("Renderer does not exist.")

        renderers.splice(index, 1)
        renderer.openzoom_internal::renderManager = null
        
        return renderer
    }
}

}

import flash.utils.Dictionary;
import flash.display.Bitmap;
import flash.display.BitmapData;
import org.openzoom.flash.utils.IDisposable;
import org.openzoom.flash.utils.IComparable;
import flash.errors.IllegalOperationError;

class TileCache
{
    public function TileCache(size:uint)
    {
    	cache = new Dictionary()
    }
    
    private var cache:Dictionary
    
    public function get(url:String):TileCacheEntry
    {
    	var entry:TileCacheEntry = cache[url]
    	return entry
    }
    
    public function put(url:String,
                        bitmapData:BitmapData,
                        lowLevel:Boolean=false,
                        shared:Boolean=false):void
    {
        cache[url] = bitmapData
    }
}

class TileCacheEntry implements IDisposable,
                                IComparable
{
    public function TileCacheEntry(url:String,
                                   bitmapData:BitmapData,
                                   level:int,
                                   shared:Boolean=false)
    {
    	this.url = url
    	this.bitmapData = bitmapData
    	this.level = level
    	this.shared = shared
    }
    
    public var url:String
    public var bitmapData:BitmapData
    public var level:int
    public var shared:Boolean
    
    public var lastAccessTime:int = 0
    
    public function dispose():void
    {
    	bitmapData = null
    }
    
    public function compareTo(other:*):int
    {
    	var entry:TileCacheEntry = other as TileCacheEntry
    	
    	if (!entry)
    	   throw new ArgumentError("[TileCacheEntry] Object to compare has wrong type.")

        // Shared tiles have higher order
        if (shared && !entry.shared)
            return 1

        // Otherwise newer tiles have higher order
        if (entry.lastAccessTime > lastAccessTime)
            return -1
        else if (entry.lastAccessTime == lastAccessTime)
            return 0
        else
            return 1
    }   	
}