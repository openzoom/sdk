package
{

import flash.display.Bitmap;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.utils.Dictionary;

import org.openzoom.flash.components.MemoryMonitor;
import org.openzoom.flash.components.MultiScaleContainer;
import org.openzoom.flash.descriptors.IImagePyramidDescriptor;
import org.openzoom.flash.descriptors.IImagePyramidLevel;
import org.openzoom.flash.descriptors.virtualearth.VirtualEarthDescriptor;
import org.openzoom.flash.events.NetworkRequestEvent;
import org.openzoom.flash.events.ViewportEvent;
import org.openzoom.flash.net.INetworkQueue;
import org.openzoom.flash.net.INetworkRequest;
import org.openzoom.flash.net.NetworkQueue;
import org.openzoom.flash.viewport.constraints.CompositeConstraint;
import org.openzoom.flash.viewport.constraints.MappingConstraint;
import org.openzoom.flash.viewport.constraints.ScaleConstraint;
import org.openzoom.flash.viewport.controllers.ContextMenuController;
import org.openzoom.flash.viewport.controllers.KeyboardController;
import org.openzoom.flash.viewport.controllers.MouseController;
import org.openzoom.flash.viewport.transformers.TweenerTransformer;

[SWF(width="960", height="600", frameRate="60", backgroundColor="#222222")]
public class VirtualEarth extends Sprite
{
    private var container:MultiScaleContainer

    public var tileCache:Dictionary = new Dictionary()
    public var pendingTiles:Dictionary = new Dictionary()
    public var loader:INetworkQueue

    public var initialized:Boolean = false
    public var descriptor:IImagePyramidDescriptor

    private var memoryMonitor:MemoryMonitor

    private const NUM_RENDERERS:uint = 1
    private const NUM_COLUMNS:uint = 1

    public const FRAMES_PER_SECOND:Number = 60

    public function VirtualEarth()
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
        var request:INetworkRequest = loader.addRequest("../resources/images/openzoom/openstreetmap.xml", XML)
//        var request:INetworkRequest = loader.addRequest("../resources/images/openzoom/google-maps-road.xml", XML)
//        var request:INetworkRequest = loader.addRequest("http://static.gasi.ch/images/3229924166/image.dzi", XML)
//        var request:INetworkRequest = loader.addRequest("../resources/images/openzoom/openstreetmap.xml", XML)
        request.addEventListener(NetworkRequestEvent.COMPLETE,
                                 request_completeHandler)

        container = new MultiScaleContainer()
        container.viewport.addEventListener(ViewportEvent.TRANSFORM_UPDATE,
                                            viewport_transformUpdateHandler,
                                            false, 0, true)
        var transformer:TweenerTransformer = new TweenerTransformer()
//        transformer.duration = 0.8
//        transformer.easing = "easeOutSine"
        container.transformer = transformer
        var mouseController:MouseController = new MouseController()
        mouseController.smoothPanning = false

        var keyboardController:KeyboardController = new KeyboardController()
        var contextMenuController:ContextMenuController = new ContextMenuController()
        container.controllers = [mouseController,
                                 keyboardController,
                                 contextMenuController]

        var aspectRatio:Number = 1//3872 / 2592
        var size:Number = 16384
        var padding:Number = 10

        var numRenderers:int = NUM_RENDERERS
        var numColumns:int = NUM_COLUMNS

        container.sceneWidth = size
        container.sceneHeight = size
        var compositeConstraint:CompositeConstraint = new CompositeConstraint()
        var scaleConstraint:ScaleConstraint = new ScaleConstraint()
        scaleConstraint.maxScale = new VirtualEarthDescriptor().width / container.sceneWidth // 24 // VirtualEarth
//        scaleConstraint.maxScale = 67108864 / container.sceneWidth // OpenStreetMap
//        scaleConstraint.maxScale = 268435456 / container.sceneWidth // Google Satellite
        var mappingConstraint:MappingConstraint = new MappingConstraint()
        compositeConstraint.constraints = [scaleConstraint/*, mappingConstraint*/]
        container.constraint = compositeConstraint

        renderer = new NeoRenderer(this, size, size / aspectRatio)
        renderer.width = container.sceneWidth
        renderer.height = container.sceneHeight
        container.addChild(renderer)
        addChild(container)


        memoryMonitor = new MemoryMonitor()
        addChild(memoryMonitor)

        layout()
    }

    private var renderer:NeoRenderer

    private function viewport_transformUpdateHandler(event:ViewportEvent):void
    {
//        trace(container.viewport.zoom)
    }

    private function request_completeHandler(event:NetworkRequestEvent):void
    {

        event.request.removeEventListener(NetworkRequestEvent.COMPLETE,
                                          request_completeHandler)
        descriptor = new VirtualEarthDescriptor()
//        descriptor = new OpenZoomDescriptor(event.request.uri, new XML(event.data))

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
        renderer.invalidated = true

        event.request.removeEventListener(NetworkRequestEvent.COMPLETE,
                                          tileRequest_completeHandler)
        tileCache[event.request.url] = (event.data as Bitmap).bitmapData
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
}

}

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import flash.utils.getTimer;
import flash.utils.setInterval;

import org.openzoom.flash.descriptors.IImagePyramidLevel;
import org.openzoom.flash.events.RendererEvent;
import org.openzoom.flash.events.ViewportEvent;
import org.openzoom.flash.renderers.Renderer;
import org.openzoom.flash.utils.math.clamp;
import org.openzoom.flash.viewport.ISceneViewport;
import org.openzoom.flash.viewport.SceneViewport;
import flash.geom.Point;


class NeoRenderer extends Renderer
{
    private var sceneViewport:ISceneViewport
    private var app:VirtualEarth
    private var tileLayer:Shape
    private var frame:Shape

    // Renderer is invalidated either when the viewport
    // is transformed or when a new tile has loaded
    public var invalidated:Boolean = true
    private const DEBUG:Boolean = true

    /**
     * Constructor.
     */
    public function NeoRenderer(app:VirtualEarth, width:Number, height:Number)
    {
        this.app = app

        frame = new Shape()

        var g:Graphics = frame.graphics
        g.beginFill(0xFF0000)
        g.drawRect(0, 0, width, height)
        g.endFill()
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

//        setInterval(updateDisplayList, 1000 / app.FRAMES_PER_SECOND)

        addEventListener(Event.ENTER_FRAME, enterFrameHandler)

        viewport.addEventListener(ViewportEvent.TRANSFORM_UPDATE,
                                  viewport_transformUpdateHandler,
                                  false, 0, true)
        viewport.addEventListener(ViewportEvent.TRANSFORM_END,
                                  viewport_transformEndHandler,
                                  false, 0, true)
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
        updateDisplayList()
    }

    private function updateDisplayList():void
    {
        if (!app.initialized)
           return

        if (!invalidated)
           return

        var sceneBounds:Rectangle = getBounds(scene.targetCoordinateSpace)
        if (!sceneViewport.intersects(sceneBounds) || !app.descriptor)
           return

        var stageBounds:Rectangle = getBounds(stage)
        var level:IImagePyramidLevel = app.descriptor.getLevelForSize(stageBounds.width, stageBounds.height)
        var index:int = clamp(level.index, 0, app.descriptor.numLevels - 1)
        trace(stageBounds.width / app.descriptor.getLevelAt(index).width)

        var time:Number = getTimer()


        level = app.descriptor.getLevelAt(index)

        var g:Graphics = tileLayer.graphics
        g.clear()
        g.beginFill(0x333333)
        g.drawRect(0, 0, level.width, level.height)
        g.endFill()


        var sceneViewportBounds:Rectangle = sceneViewport.getBounds()
        var localBounds:Rectangle = sceneBounds.intersection(sceneViewportBounds)

        var offset:int  = 1
        var left:uint   = Math.max(0,                Math.floor(localBounds.left   * level.numColumns / sceneBounds.width)  - offset)
        var right:uint  = Math.min(level.numColumns, Math.floor(localBounds.right  * level.numColumns / sceneBounds.width)  + offset)
        var top:uint    = Math.max(0,                Math.floor(localBounds.top    * level.numRows    / sceneBounds.height) - offset)
        var bottom:uint = Math.min(level.numRows,    Math.floor(localBounds.bottom * level.numRows    / sceneBounds.height) + offset)

//        for (var a:int = 0; a < 2; a++)
//        {
//            for (var h:int = 0; h < 2; h++)
//            {
//                var q:int = app.descriptor is VirtualEarth ? 1 : 0
//                var url:String = app.descriptor.getTileURL(q, a, h)
//                var bounds:Rectangle = app.descriptor.getTileBounds(q, a, h)
//
//                var bitmapData:BitmapData = app.tileCache[url] as BitmapData
//                if (!bitmapData)
//                {
//                    app.loadTile(url)
//                    continue
//                }
//
//                bitmapData.merge(bitmapData, bitmapData.rect, new Point(), 255, 255, 255, 128)
//
//                var s:Number = level.width / 512
//                var matrix:Matrix = new Matrix(s, 0, 0, s)
//                matrix.tx = bounds.x * s
//                matrix.ty = bounds.y * s
//                g.beginBitmapFill(bitmapData, matrix, false, true)
//
//                g.drawRect(bounds.x * s, bounds.y * s, bounds.width * s, bounds.height * s)
//                g.endFill()
//            }
//        }

//        trace(viewport.getBounds())

        for (var i:int = left; i < right; i++)
        {
            for (var j:int = top; j < bottom; j++)
            {
                var url:String = app.descriptor.getTileURL(index, i, j)
                var bounds:Rectangle = app.descriptor.getTileBounds(index, i, j)

                var bitmapData:BitmapData = app.tileCache[url] as BitmapData

                if (!bitmapData)
                {
                    app.loadTile(url)
                    continue
                }

//                var t:BitmapData = new BitmapData(bitmapData.rect.width,
//                                                  bitmapData.rect.height,
//                                                  true)
//                t.copyPixels(bitmapData, bitmapData.rect, new Point())

//                if (!fill || !fill.rect.equals(bitmapData.rect))
//                var fillData:BitmapData = new BitmapData(bitmapData.rect.width, bitmapData.rect.height, true)
//                fillData.fillRect(fillData.rect, 0xFFFF0000)
//                fillData.fillRect(fillData.rect, 0x80FF0000)
                
//                fillData.merge(t, bitmapData.rect, new Point(),
//                               0x100, 0x100, 0x100, 0x100)

//                var alphaMultiplier:uint = (Math.random() * 0x100) << 24
//                ALPHA_MAP.fillRect(bitmapData.rect, alphaMultiplier | 0)
////                fillData.fillRect(FILL.rect, 0)
//                fillData.copyPixels(bitmapData,
//                                    bitmapData.rect,
//                                    ZERO_POINT,
//                                    ALPHA_MAP)
                                    
                var matrix:Matrix = new Matrix()
                matrix.tx = bounds.x
                matrix.ty = bounds.y
//                g.beginBitmapFill(fillData, matrix, false, true)
                g.beginBitmapFill(bitmapData, matrix, false, true)
                g.drawRect(bounds.x, bounds.y, bounds.width, bounds.height)
                g.endFill()
                
//                fillData.dispose()
            }
        }

        tileLayer.width = frame.width
        tileLayer.height = frame.height

        invalidated = false

//        trace((getTimer() - time) * app.numChildren)
    }
    
    private static const ALPHA_MAP:BitmapData = new BitmapData(258, 258)
    private static const ZERO_POINT:Point = new Point() 
//    private static const FILL:BitmapData = new BitmapData(258, 258) 
//    private static var fill:BitmapData
}