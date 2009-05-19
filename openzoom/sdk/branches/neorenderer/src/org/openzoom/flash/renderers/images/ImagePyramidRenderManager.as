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

import org.openzoom.flash.core.openzoom_internal;
import org.openzoom.flash.descriptors.IImagePyramidDescriptor;
import org.openzoom.flash.descriptors.IImagePyramidLevel;
import org.openzoom.flash.events.NetworkRequestEvent;
import org.openzoom.flash.events.ViewportEvent;
import org.openzoom.flash.net.INetworkQueue;
import org.openzoom.flash.net.INetworkRequest;
import org.openzoom.flash.scene.IMultiScaleScene;
import org.openzoom.flash.scene.IReadonlyMultiScaleScene;
import org.openzoom.flash.viewport.INormalizedViewport;

/**
 * Manages the rendering of all image pyramid renderers on stage.
 */
public class ImagePyramidRenderManager
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------
    
    private static const FRAMES_PER_SECOND:Number = 60
    
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
    
    openzoom_internal var tileBitmapDataCache:Dictionary /* of BitmapData */ = new Dictionary()
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
        var fromLevel:int = 0
//        var toLevel:int = descriptor.numLevels - 1
        var toLevel:int = optimalLevel.index
        
        var tileLayer:Shape = renderer.openzoom_internal::tileLayer
	    var g:Graphics = tileLayer.graphics
        g.clear()
        g.beginFill(0x000000, 0)
        g.drawRect(0, 0, descriptor.width, descriptor.height)
        g.endFill()
        
        tileLayer.width = renderer.width
        tileLayer.height = renderer.height
    
        // levels
        for (var l:int = fromLevel; l <= toLevel; l++)
        {
        	var level:IImagePyramidLevel = descriptor.getLevelAt(l)
        	
        	// Prepare tile layer
//	        var tileLayer:Shape = renderer.openzoom_internal::tileLayers[l]
//	        var g:Graphics = tileLayer.graphics
//	        g.clear()
//	        g.beginFill(0x000000, 0)
//	        g.drawRect(0, 0, level.width, level.height)
//	        g.endFill()
//	        
//            tileLayer.width = renderer.width
//            tileLayer.height = renderer.height
//        	
//        	if (l > optimalLevel.index + 1)
//        	   continue
        	
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
	        
	        // columns
	        for (var c:int = fromTile.x; c <= toTile.x; c++)
	        {
		        for (var r:int = fromTile.y; r <= toTile.y; r++)
		        {
		        	var tile:Tile2 = renderer.openzoom_internal::getTile(l, c, r)
		        	var downloadPossible:Boolean = numDownloads < MAX_CONCURRENT_DOWNLOADS
		        	
		        	if (!tile.loaded && downloadPossible)
		        	{
		        		if (!tile.loading)
		        		    loadTile(tile)
		        		    
		        		continue
		        	}
		        	
		        	if (!tile.bitmapData)
		        	{
                        trace("[ImagePyramidRenderManager] updateDisplayList: Tile BitmapData missing.", tile.loaded, tile.loading)
                        continue		        		
		        	}

//		        	var matrix:Matrix = new Matrix()
////		        	matrix.createBox(1, 1, 0, tile.bounds.x, tile.bounds.y)
//                    matrix.tx = tile.bounds.x
//                    matrix.ty = tile.bounds.y
//		        	                 
//		        	g.beginBitmapFill(tile.bitmapData, matrix, false, true)
//		        	
//		        	g.drawRect(tile.bounds.x,
//		        	           tile.bounds.y,
//		        	           tile.bounds.width,
//		        	           tile.bounds.height)
//		        		
//                    g.endFill()
                    
		        	var matrix:Matrix = new Matrix()
		        	var sx:Number = descriptor.width / level.width
		        	var sy:Number = descriptor.height / level.height
		        	matrix.createBox(sx, sx, 0, tile.bounds.x * sx, tile.bounds.y * sy)
		        	                 
		        	                 
		        	g.beginBitmapFill(tile.bitmapData, matrix, false, true)
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
    private var numDownloads:uint = 0
    
    private function loadTile(tile:Tile2):void
    {
    	if (pendingDownloads[tile.url])
    	   return
    	
    	numDownloads++
    	
    	var request:INetworkRequest = loader.addRequest(tile.url, Bitmap, tile)
    	request.addEventListener(NetworkRequestEvent.COMPLETE,
    	                         request_completeHandler)
    	
    	tile.loading = true
    	
    	pendingDownloads[tile.url] = true
    }
    
    private function request_completeHandler(event:NetworkRequestEvent):void
    {
    	numDownloads--
    	event.request.removeEventListener(NetworkRequestEvent.COMPLETE,
    	                                  request_completeHandler)
    	                                  
    	var tile:Tile2 = event.context as Tile2
        var bitmapData:BitmapData = Bitmap(event.data).bitmapData
        
        openzoom_internal::tileBitmapDataCache[tile.url] = bitmapData 
        
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
            // TODO: Validate renderers from the transformation origin outwards
            for each (var renderer:ImagePyramidRenderer in renderers)
                updateDisplayList(renderer)
                
            // Mark as validated
            invalidateDisplayListFlag = false
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