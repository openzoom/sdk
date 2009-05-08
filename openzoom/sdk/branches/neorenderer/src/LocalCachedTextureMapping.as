package
{

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.geom.Point;
import flash.utils.Dictionary;

import org.openzoom.flash.components.MemoryMonitor;
import org.openzoom.flash.components.MultiScaleContainer;
import org.openzoom.flash.descriptors.IMultiScaleImageDescriptor;
import org.openzoom.flash.descriptors.IMultiScaleImageLevel;
import org.openzoom.flash.descriptors.deepzoom.DZIDescriptor;
import org.openzoom.flash.events.NetworkRequestEvent;
import org.openzoom.flash.events.ViewportEvent;
import org.openzoom.flash.net.INetworkQueue;
import org.openzoom.flash.net.INetworkRequest;
import org.openzoom.flash.net.NetworkQueue;
import org.openzoom.flash.viewport.controllers.ContextMenuController;
import org.openzoom.flash.viewport.controllers.KeyboardController;
import org.openzoom.flash.viewport.controllers.MouseController;
import org.openzoom.flash.viewport.transformers.TweenerTransformer;

[SWF(width="960", height="600", frameRate="60", backgroundColor="#222222")]
public class LocalCachedTextureMapping extends Sprite
{
    private var container:MultiScaleContainer

    public const CACHE_SIZE:int = 100
    public var tileCache:Dictionary = new Dictionary()
    public var tiles:Array = []
    public var pendingTiles:Dictionary = new Dictionary()
    public var loader:INetworkQueue

    public var initialized:Boolean = false
    public var descriptor:IMultiScaleImageDescriptor
    
    private var renderers:Array = []
    private var memoryMonitor:MemoryMonitor

    private const NUM_RENDERERS:uint = 1000
    private const NUM_COLUMNS:uint = 40

    public const FRAMES_PER_SECOND:Number = 24

    public function LocalCachedTextureMapping()
    {

        stage.align = StageAlign.TOP_LEFT
        stage.scaleMode = StageScaleMode.NO_SCALE
        stage.addEventListener(Event.RESIZE,
                               stage_resizeHandler,
                               false, 0, true)

        loader = new NetworkQueue()
        var request:INetworkRequest = loader.addRequest("../resources/images/deepzoom/billions.xml", XML)
        request.addEventListener(NetworkRequestEvent.COMPLETE,
                                 request_completeHandler)

        container = new MultiScaleContainer()
        container.viewport.addEventListener(ViewportEvent.TRANSFORM_UPDATE,
                                            viewport_transformUpdateHandler,
                                            false, 0, true)
        var transformer:TweenerTransformer = new TweenerTransformer()
//        transformer.duration = 0.5
//        transformer.easing = "easeOutSine"
        container.transformer = transformer
        var mouseController:MouseController = new MouseController()
//        mouseController.smoothPanning = false

        var keyboardController:KeyboardController = new KeyboardController()
        var contextMenuController:ContextMenuController = new ContextMenuController()
        container.controllers = [mouseController,
                                 keyboardController,
                                 contextMenuController]

        var aspectRatio:Number = 3872 / 2592
        var size:Number = 100
        var padding:Number = 10

        var numRenderers:int = NUM_RENDERERS
        var numColumns:int = NUM_COLUMNS

        container.sceneWidth = (size + padding) * numColumns
        container.sceneHeight = (size / aspectRatio + padding) * Math.ceil(numRenderers / numColumns)

        for (var i:int = 0; i < numRenderers; i++)
        {
            var renderer:NeoRenderer = new NeoRenderer(this, size, size / aspectRatio)
            renderer.x = (i % numColumns) * (size + padding)
            renderer.y = Math.floor(i / numColumns) * (size / aspectRatio + padding)
            renderers.push(renderer)
            container.addChild(renderer)
        }
        addChild(container)


        memoryMonitor = new MemoryMonitor()
        addChild(memoryMonitor)

        layout()
    }

    private function viewport_transformUpdateHandler(event:ViewportEvent):void
    {
    }

    private function request_completeHandler(event:NetworkRequestEvent):void
    {
        event.request.removeEventListener(NetworkRequestEvent.COMPLETE,
                                          request_completeHandler)
        descriptor = DZIDescriptor.fromXML(event.request.uri, new XML(event.data))
//        var renderer:MultiScaleImageRenderer =
//               new MultiScaleImageRenderer(descriptor, container.loader,
//                                           3872 * 0.5, 3872 * 0.5)//2592 * 0.5)
//        renderer.x = 2200
//        container.addChild(renderer)

//        loader.addEventListener(Event.COMPLETE,
//                                loader_completeHandler,
//                                false, 0, true)
//
//        for (var i:int = 0; i < descriptor.numLevels; i++)  // level
//        {
//            var level:IMultiScaleImageLevel = descriptor.getLevelAt(i)
//
//            for (var j:int = 0; j < level.numColumns; j++)  // column
//            {
//                for (var k:int = 0; k < level.numRows; k++) // row
//                {
//                    loadTile(descriptor.getTileURL(i, j, k))
//                }
//            }
//        }

        initialized = true
    }

    public function loadTile(url:String):void
    {
        if (pendingTiles[url] == true)
           return

        pendingTiles[url] = true

        var tileRequest:INetworkRequest
            tileRequest = loader.addRequest(url, Bitmap)
            tileRequest.addEventListener(NetworkRequestEvent.COMPLETE,
                                         tileRequest_completeHandler)

    }


    private function tileRequest_completeHandler(event:NetworkRequestEvent):void
    {
        event.request.removeEventListener(NetworkRequestEvent.COMPLETE,
                                          tileRequest_completeHandler)
                              
        var tile:Tile = new Tile()
        
        var t:BitmapData = (event.data as Bitmap).bitmapData         
            tile.bitmapData = new BitmapData(t.width, t.height)
            tile.bitmapData.copyPixels(t, t.rect, ZERO_POINT)
            t.dispose()
//            tile.bitmapData = t
            tile.uri = event.request.uri 
            
//        trace(tile.bitmapData.transparent)            
        
        if (tiles.length < CACHE_SIZE)
        {   
            tiles.push(tile)
            tileCache[tile.uri] = tile
        }
        else
        {
//	        trace("PRE:", tiles.length)
//	        var index:int = Math.floor(Math.random() * (tiles.length - 1))
//        	var oldTile:Tile = tiles[index] as Tile
//        	tileCache[oldTile.uri] = null
//        	oldTile.dispose()
//        	
//	        trace("INV:", tiles.length, Math.random())
//	        
//        	tiles[index] = tile
//        	tileCache[tile.uri] = tile
//	        trace("POST:", tiles.length)

	        trace("PRE:", tiles.length)
        	var oldTile:Tile = tiles.shift() as Tile
        	tileCache[oldTile.uri] = null
        	pendingTiles[oldTile.uri] = false
        	oldTile.dispose()
        	
	        trace("INV:", tiles.length, Math.random())
	        
        	tiles.push(tile)
        	tileCache[tile.uri] = tile
	        trace("POST:", tiles.length)
        }
        
        for each (var renderer:NeoRenderer in renderers)
            renderer.invalidated = true
    }

    private function loader_completeHandler(event:Event):void
    {
        trace("All tiles loaded.")
        initialized = true
    }

    private function stage_resizeHandler(event:Event):void
    {
        layout()
    }

    private function layout():void
    {
        if (container)
        {
            container.width = stage.stageWidth
            container.height = stage.stageHeight
        }
        
        if (memoryMonitor)
        {
        	memoryMonitor.x = stage.stageWidth - memoryMonitor.width - 10
        	memoryMonitor.y = stage.stageHeight - memoryMonitor.height - 10
        }
    }
    
    private static const ZERO_POINT:Point = new Point()
}

}

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import flash.utils.getTimer;
import flash.utils.setInterval;

import org.openzoom.flash.descriptors.IMultiScaleImageLevel;
import org.openzoom.flash.events.RendererEvent;
import org.openzoom.flash.events.ViewportEvent;
import org.openzoom.flash.renderers.Renderer;
import org.openzoom.flash.utils.math.clamp;
import org.openzoom.flash.viewport.ISceneViewport;
import org.openzoom.flash.viewport.SceneViewport;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.display.BlendMode;
import flash.display.PixelSnapping;
import org.openzoom.flash.renderers.images.Tile;
import flash.display.BitmapDataChannel;


class NeoRenderer extends Renderer
{
    private var sceneViewport:ISceneViewport
    private var app:LocalCachedTextureMapping
    private var tileLayer:Shape
    private var frame:Shape

    // Renderer is invalidated either when the viewport
    // is transformed or when a new tile has loaded
    public var invalidated:Boolean = true
    private const DEBUG:Boolean = true

    /**
     * Constructor.
     */
    public function NeoRenderer(app:LocalCachedTextureMapping, width:Number, height:Number)
    {
        this.app = app

        frame = new Shape()

        var g:Graphics = frame.graphics
        g.beginFill(0xFF0000)
        g.drawRect(0, 0, width, height)
        g.endFill()
        frame.width = width
        frame.height = height
        addChild(frame)
        mask = frame

        // Stress Test
//        for (var i:int = 0; i < 20; i++)
//        {
//            var s:Shape = new Shape
//            g.beginFill(0xFF0000, 0)
//            g.drawRect(0, 0, width, height)
//            g.endFill()
//            addChild(s)
//        }

        tileLayer = new Shape()
        addChild(tileLayer)

        addEventListener(RendererEvent.ADDED_TO_SCENE,
                         addedToSceneHandler,
                         false, 0, true)
    }

    private function addedToSceneHandler(event:RendererEvent):void
    {
        sceneViewport = SceneViewport.getInstance(viewport)

//        setInterval(updateDisplayList, 1000 / app.FRAMES_PER_SECOND)

        viewport.addEventListener(ViewportEvent.TRANSFORM_UPDATE,
                                  viewport_transformUpdateHandler,
                                  false, 0, true)
        viewport.addEventListener(ViewportEvent.TRANSFORM_END,
                                  viewport_transformEndHandler,
                                  false, 0, true)
        addEventListener(Event.ENTER_FRAME,
                         enterFrameHandler,
                         false, 0, true)

        buttonMode = true
        addEventListener(MouseEvent.CLICK,
                         clickHandler,
                         false, 0, true)
    }

    private function clickHandler(event:MouseEvent):void
    {
//        sceneViewport.fitToBounds(getBounds(scene.targetCoordinateSpace))
    }

    private var counter:int = 0

    private function enterFrameHandler(event:Event):void
    {
        updateDisplayList()
    }

    private function viewport_transformUpdateHandler(event:ViewportEvent):void
    {
        invalidated = true
    }

    private function viewport_transformEndHandler(event:ViewportEvent):void
    {
        // force validation
        invalidated = true
//        updateDisplayList()
    }

    private function updateDisplayList():void
    {
        if (!app.initialized)
           return

        if (!invalidated)
           return

        var sceneBounds:Rectangle = getBounds(scene.targetCoordinateSpace)
        if (!app.descriptor || !sceneViewport.intersects(sceneBounds))
        {
            tileLayer.graphics.clear()        	
            return
        }

//        trace("[NeoRenderer] updateDisplayList")

        var stageBounds:Rectangle = getBounds(stage)
        var level:IMultiScaleImageLevel = app.descriptor.getLevelForSize(stageBounds.width, stageBounds.height)
        var index:int = clamp(level.index + 1, 0, app.descriptor.numLevels - 1)

        var time:Number = getTimer()


        level = app.descriptor.getLevelAt(index)

        var g:Graphics = tileLayer.graphics
        g.clear()
        g.beginFill(0x666666)
        g.drawRect(0, 0, level.width, level.height)
        g.endFill()

        var sceneViewportBounds:Rectangle = sceneViewport.getBounds()
        var localBounds:Rectangle = sceneBounds.intersection(sceneViewportBounds)
        localBounds.offset(-sceneBounds.x, -sceneBounds.y)

        var offset:int  = 1
        var left:uint   = Math.max(0,                Math.floor(localBounds.left   * level.numColumns / sceneBounds.width)  - offset)
        var right:uint  = Math.min(level.numColumns, Math.floor(localBounds.right  * level.numColumns / sceneBounds.width)  + offset)
        var top:uint    = Math.max(0,                Math.floor(localBounds.top    * level.numRows    / sceneBounds.height) - offset)
        var bottom:uint = Math.min(level.numRows,    Math.floor(localBounds.bottom * level.numRows    / sceneBounds.height) + offset)

        for (var i:int = left; i < right; i++)
        {
            for (var j:int = top; j < bottom; j++)
            {
                var url:String = app.descriptor.getTileURL(index, i, j)
                var bounds:Rectangle = app.descriptor.getTileBounds(index, i, j)

                var tile:Tile = app.tileCache[url] as Tile

                if (!tile)
                {
                    app.loadTile(url)
                    continue
                }
                
//                var alphaMultiplier:uint = ((Math.random() * 0.5 + 0.5) * 0x100)
//                ALPHA_MAP.fillRect(bitmapData.rect, alphaMultiplier | 0x00000000)
//                bitmapData.copyChannel(ALPHA_MAP, bitmapData.rect, ZERO_POINT, BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA)
                
                var bitmapData:BitmapData = tile.bitmapData
                
                // Fading
//                var fillData:BitmapData = new BitmapData(bitmapData.rect.width,
//                                                         bitmapData.rect.height,
//                                                         true)
//                var alphaMultiplier:uint = ((Math.random() * 0.5 + 0.5) * 0x100) << 24
//                ALPHA_MAP.fillRect(bitmapData.rect, alphaMultiplier | 0x00000000)
//                fillData.copyPixels(bitmapData,
//                                    bitmapData.rect,
//                                    ZERO_POINT,
//                                    ALPHA_MAP)

                var matrix:Matrix = new Matrix()
                matrix.tx = bounds.x
                matrix.ty = bounds.y
                g.beginBitmapFill(bitmapData, matrix, false, true)
//                g.beginBitmapFill(fillData, matrix, false, true)
                g.drawRect(bounds.x, bounds.y, bounds.width, bounds.height)
                g.endFill()
                
//                fillData.dispose()
            }
        }

        tileLayer.width = frame.width
        tileLayer.height = frame.height

        invalidated = false
    }
    
    private static const ALPHA_MAP:BitmapData = new BitmapData(258, 258)
    private static const ZERO_POINT:Point = new Point() 
//    private static const FILL:BitmapData = new BitmapData(258, 258) 
//    private static var fill:BitmapData
}

class Tile implements IDisposable
{
	public var bitmapData:BitmapData
	public var uri:String
	
	public function dispose():void
	{
		bitmapData.dispose()
		bitmapData = null
		uri = null
	}
}

interface IDisposable
{
	function dispose():void
}