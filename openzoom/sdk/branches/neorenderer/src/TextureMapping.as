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
import org.openzoom.flash.net.INetworkQueue;
import org.openzoom.flash.net.INetworkRequest;
import org.openzoom.flash.net.NetworkQueue;
import org.openzoom.flash.viewport.controllers.KeyboardController;
import org.openzoom.flash.viewport.controllers.MouseController;
import org.openzoom.flash.viewport.transformers.TweenerTransformer;

[SWF(width="960", height="600", frameRate="60", backgroundColor="#222222")]
public class TextureMapping extends Sprite
{
	private var container:MultiScaleContainer
	
    public var tileCache:Dictionary = new Dictionary()
    public var loader:INetworkQueue
    
    public var initialized:Boolean = false
    public var descriptor:IMultiScaleImageDescriptor
    
	public function TextureMapping()
	{
		stage.align = StageAlign.TOP_LEFT
		stage.scaleMode = StageScaleMode.NO_SCALE
		stage.addEventListener(Event.RESIZE,
		                       stage_resizeHandler,
		                       false, 0, true)
		                       
        loader = new NetworkQueue()
        var request:INetworkRequest = loader.addRequest("../resources/images/deepzoom/morocco.xml", XML)
        request.addEventListener(NetworkRequestEvent.COMPLETE,
                                 request_completeHandler)
		
		container = new MultiScaleContainer()
		container.sceneWidth = (2203 + 300) * 40
		container.sceneHeight = (3209 + 300) * 40
		container.transformer = new TweenerTransformer()
		var mouseController:MouseController = new MouseController()
		var keyboardController:KeyboardController = new KeyboardController()
		container.controllers = [mouseController, keyboardController]

        for (var i:int = 0; i < 1000; i++)
        {
	        var renderer:NeoRenderer = new NeoRenderer(this)
        	renderer.x = (i % 40) * (2203 + 300)
        	renderer.y = Math.floor(i / 40) * (3209 + 300)
	        container.addChild(renderer)
        }       
        addChild(container)
        
        layout()
	}
    
    private function request_completeHandler(event:NetworkRequestEvent):void
    {
        event.request.removeEventListener(NetworkRequestEvent.COMPLETE,
                                          request_completeHandler)
        descriptor = DZIDescriptor.fromXML(event.request.uri, new XML(event.data))
        
//        var g:Graphics = graphics
//        g.beginFill(0xFF0000)
//        g.drawRect(0, 0, descriptor.width, descriptor.height)
//        g.endFill()
        
        loader.addEventListener(Event.COMPLETE,
                                loader_completeHandler,
                                false, 0, true)
        
        var tileRequest:INetworkRequest
        
        for (var i:int = 0; i < 7/*descriptor.numLevels*/; i++)  // level
        {
            var level:IMultiScaleImageLevel = descriptor.getLevelAt(i)
            
            for (var j:int = 0; j < level.numColumns; j++)  // column
            {
                for (var k:int = 0; k < level.numRows; k++) // row
                {
                    tileRequest = loader.addRequest(descriptor.getTileURL(i, j, k), Bitmap)
                    tileRequest.addEventListener(NetworkRequestEvent.COMPLETE,
                                                 tileRequest_completeHandler)
                }   
            }
        }
    }
    
    private function tileRequest_completeHandler(event:NetworkRequestEvent):void
    {
        event.request.removeEventListener(NetworkRequestEvent.COMPLETE,
                                          tileRequest_completeHandler)
        tileCache[event.request.uri] = (event.data as Bitmap).bitmapData
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

import org.openzoom.flash.renderers.Renderer;
import org.openzoom.flash.viewport.ISceneViewport;
import org.openzoom.flash.events.RendererEvent;
import flash.utils.setInterval;
import flash.display.Graphics;
import flash.display.BitmapData;
import org.openzoom.flash.descriptors.IMultiScaleImageLevel;
import flash.geom.Rectangle;
import flash.geom.Matrix;
import org.openzoom.flash.viewport.SceneViewport;


class NeoRenderer extends Renderer
{
	private var sceneViewport:ISceneViewport
	private var app:TextureMapping
	
    public function NeoRenderer(app:TextureMapping)
    {
    	this.app = app
    	
    	drawBackground()
    	addEventListener(RendererEvent.ADDED_TO_SCENE,
    	                 addedToSceneHandler,
    	                 false, 0, true)
    }
    
    private function drawBackground():void
    {
        var g:Graphics = graphics
        g.beginFill(0xFF0000)
        g.drawRect(0, 0, 100, 100)
        g.endFill()
    }
    
    private function addedToSceneHandler(event:RendererEvent):void
    {
    	sceneViewport = SceneViewport.getInstance(viewport)
    	setInterval(updateDisplayList, 1000/12)
//    	viewport.addEventListener(ViewportEvent.TRANSFORM_UPDATE,
//    	                          viewport_transformUpdateHandler,
//    	                          false, 0, true)	
    }
    
    private var counter:int = 0
    
//    private function viewport_transformUpdateHandler(event:ViewportEvent):void
//    {
//    }
    
    private function updateDisplayList():void
    {
        var sceneBounds:Rectangle = getBounds(scene.targetCoordinateSpace)
        if (!sceneViewport.intersects(sceneBounds) || !app.descriptor)
           return
        
        if (!app.initialized)
           return
           
        var stageBounds:Rectangle = getBounds(stage)
        var level:IMultiScaleImageLevel = app.descriptor.getLevelForSize(stageBounds.width, stageBounds.height)
//        trace(level.index, stageBounds, viewport.zoom)
        
        var url:String = app.descriptor.getTileURL(counter++ % 6, 0, 0)
        var bitmapData:BitmapData = app.tileCache[url] as BitmapData
        var matrix:Matrix = new Matrix()
        matrix.createBox(app.descriptor.width / bitmapData.width,
                         app.descriptor.height / bitmapData.height)
        var g:Graphics = graphics
        g.beginBitmapFill(bitmapData, matrix, true, true)
        g.drawRect(0, 0, app.descriptor.width, app.descriptor.height)
        g.endFill()
    }
}