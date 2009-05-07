package
{

import flash.display.Bitmap;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.utils.Dictionary;

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
public class TextureMapping extends Sprite
{
	private var container:MultiScaleContainer
	
    public var tileCache:Dictionary = new Dictionary()
    public var pendingTiles:Dictionary = new Dictionary()
    public var loader:INetworkQueue
    
    public var initialized:Boolean = false
    public var descriptor:IMultiScaleImageDescriptor
    
    private const NUM_RENDERERS:uint = 1
    private const NUM_COLUMNS:uint = 1
    
    public const FRAMES_PER_SECOND:Number = 60
    
	public function TextureMapping()
	{
        // Cross-domain security
//        Security.loadPolicyFile("http://tile.openstreetmap.org/crossdomain.xml")
        
		stage.align = StageAlign.TOP_LEFT
		stage.scaleMode = StageScaleMode.NO_SCALE
		stage.addEventListener(Event.RESIZE,
		                       stage_resizeHandler,
		                       false, 0, true)
		                       
        loader = new NetworkQueue()
//        var request:INetworkRequest = loader.addRequest("../resources/images/deepzoom/billions.xml", XML)
        var request:INetworkRequest = loader.addRequest("http://static.gasi.ch/images/3229924166/image.dzi", XML)
//        var request:INetworkRequest = loader.addRequest("../resources/images/openzoom/openstreetmap.xml", XML)
        request.addEventListener(NetworkRequestEvent.COMPLETE,
                                 request_completeHandler)
		
		container = new MultiScaleContainer()
		container.viewport.addEventListener(ViewportEvent.TRANSFORM_UPDATE,
		                                    viewport_transformUpdateHandler,
		                                    false, 0, true)
		container.transformer = new TweenerTransformer()
		var mouseController:MouseController = new MouseController()
//		mouseController.smoothPanning = false
		
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
	        container.addChild(renderer)
        }
        addChild(container)
        
        layout()
	}
	
	private function viewport_transformUpdateHandler(event:ViewportEvent):void
	{
//        trace(container.viewport.zoom)
	}
    
    private function request_completeHandler(event:NetworkRequestEvent):void
    {
    	
        event.request.removeEventListener(NetworkRequestEvent.COMPLETE,
                                          request_completeHandler)
        descriptor = new DZIDescriptor("http://static.gasi.ch/images/3229924166/image.dzi", 3872 * 1000, 2592 * 1000, 256, 1, "jpg")
//        descriptor = DZIDescriptor.fromXML(event.request.uri, new XML(event.data))
//        descriptor = new VirtualEarthDescriptor()
//        descriptor = new OpenZoomDescriptor(event.request.uri, new XML(event.data))
//    	var renderer:MultiScaleImageRenderer =
//    	       new MultiScaleImageRenderer(descriptor, container.loader,
//    	                                   3872 * 0.5, 3872 * 0.5)//2592 * 0.5)
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
//                	loadTile(descriptor.getTileURL(i, j, k))
//                }   
//            }
//        }

        initialized = true
    }
    
    public function loadTile(url:String):void
    {
    	tileCache[url] = Math.random() * 0xFFFFFF
    	
//    	if (pendingTiles[url] == true)
//    	   return
//    	
//    	pendingTiles[url] = true
//    	
//        var tileRequest:INetworkRequest
//            tileRequest = loader.addRequest(url, Bitmap)
//            tileRequest.addEventListener(NetworkRequestEvent.COMPLETE,
//                                         tileRequest_completeHandler)
    	
    }
   
    
    private function tileRequest_completeHandler(event:NetworkRequestEvent):void
    {
//        event.request.removeEventListener(NetworkRequestEvent.COMPLETE,
//                                          tileRequest_completeHandler)
//        tileCache[event.request.uri] = (event.data as Bitmap).bitmapData
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
	}
}

}

import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
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
import flash.display.Bitmap;


class NeoRenderer extends Renderer
{
	private var sceneViewport:ISceneViewport
	private var app:TextureMapping
	private var tileLayer:Shape
	private var frame:Shape
	
	// Renderer is invalidated either when the viewport
	// is transformed or when a new tile has loaded
	private var invalidated:Boolean = true
	private const DEBUG:Boolean = true
	
	/**
	 * Constructor.
	 */
    public function NeoRenderer(app:TextureMapping, width:Number, height:Number)
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
    	
    	tileLayer = new Shape()
    	addChild(tileLayer)
    	
    	addEventListener(RendererEvent.ADDED_TO_SCENE,
    	                 addedToSceneHandler,
    	                 false, 0, true)
    }
    
    private function addedToSceneHandler(event:RendererEvent):void
    {
    	sceneViewport = SceneViewport.getInstance(viewport)
    	setInterval(updateDisplayList, 1000 / app.FRAMES_PER_SECOND)
    	viewport.addEventListener(ViewportEvent.TRANSFORM_UPDATE,
    	                          viewport_transformUpdateHandler,
    	                          false, 0, true)
        viewport.addEventListener(ViewportEvent.TRANSFORM_END,
                                  viewport_transformEndHandler,
                                  false, 0, true)	
    }
    
    private var counter:int = 0
    
    private function viewport_transformUpdateHandler(event:ViewportEvent):void
    {
    	invalidated = true
    }
    
    private function viewport_transformEndHandler(event:ViewportEvent):void
    {
    	// force validation
    	invalidated = true
    	updateDisplayList()
    }
    
    private function updateDisplayList():void
    {
    	if (!invalidated)
    	   return
    	
        var sceneBounds:Rectangle = getBounds(scene.targetCoordinateSpace)
        if (!sceneViewport.intersects(sceneBounds) || !app.descriptor)
           return
        
        if (!app.initialized)
           return
        
        var time:Number = getTimer()
        
        var stageBounds:Rectangle = getBounds(stage)
        var level:IMultiScaleImageLevel = app.descriptor.getLevelForSize(stageBounds.width, stageBounds.height)
        var index:int = clamp(level.index + 1, 0, app.descriptor.numLevels - 1)
        level = app.descriptor.getLevelAt(index)
        
        var g:Graphics = tileLayer.graphics
        g.clear()
        g.beginFill(0xFF6600)
        g.drawRect(0, 0, level.width, level.height)
        g.endFill()
        
        var sceneViewportBounds:Rectangle = sceneViewport.getBounds()
        var localBounds:Rectangle = sceneBounds.intersection(sceneViewportBounds) 
//        trace(localBounds, sceneViewportBounds)
        
//        var ratioL:Number = localBounds.left / sceneBounds.width
//        var ratioR:Number = localBounds.right / sceneBounds.width
//        var ratioT:Number = localBounds.top / sceneBounds.height
//        var ratioB:Number = localBounds.bottom / sceneBounds.height
//        trace(ratioL, ratioR, ratioT, ratioB)
        var left:uint = Math.floor((localBounds.left * level.numColumns) / sceneBounds.width)
        var right:uint = Math.ceil((localBounds.right * level.numColumns) / sceneBounds.width)
        var top:uint = Math.floor((localBounds.top * level.numRows) / sceneBounds.height)
        var bottom:uint = Math.ceil((localBounds.bottom * level.numRows) / sceneBounds.height)
        
        for (var i:int = left; i < right; i++)
        {
            for (var j:int = top; j < bottom; j++)
            {
		        var url:String = app.descriptor.getTileURL(index, i, j)
		        var bounds:Rectangle = app.descriptor.getTileBounds(index, i, j)
		        
//		        var bitmapData:BitmapData = app.tileCache[url] as BitmapData
//		        
//		        if (!bitmapData)
//		        {
//		        	app.loadTile(url)
//                    continue
//                }
		        
		        if (!app.tileCache[url])
		        {
		        	app.loadTile(url)
		        	continue
		        }
		        
//		        if (DEBUG)
//		        {
                    g.beginFill(app.tileCache[url])	
//		        }
//		        else
//		        {
//			        var matrix:Matrix = new Matrix()
//			        matrix.tx = bounds.x
//			        matrix.ty = bounds.y
//			        g.beginBitmapFill(bitmapData, matrix, false, true)
//		        }
		        
		        g.drawRect(bounds.x, bounds.y, bounds.width, bounds.height)
		        g.endFill()
            }
        }
        
        tileLayer.width = frame.width
        tileLayer.height = frame.height
        
        invalidated = false
        
//        trace((getTimer() - time) * app.numChildren)
    }
}