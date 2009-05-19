package
{

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;

import org.openzoom.flash.components.MemoryMonitor;
import org.openzoom.flash.components.MultiScaleContainer;
import org.openzoom.flash.descriptors.IImagePyramidDescriptor;
import org.openzoom.flash.descriptors.deepzoom.DeepZoomImageDescriptor;
import org.openzoom.flash.renderers.images.ImagePyramidRenderManager;
import org.openzoom.flash.renderers.images.ImagePyramidRenderer;
import org.openzoom.flash.viewport.constraints.ScaleConstraint;
import org.openzoom.flash.viewport.controllers.ContextMenuController;
import org.openzoom.flash.viewport.controllers.KeyboardController;
import org.openzoom.flash.viewport.controllers.MouseController;
import org.openzoom.flash.viewport.transformers.TweenerTransformer;


[SWF(width="960", height="600", frameRate="60", backgroundColor="#222222")]
public class ImagePyramidRendererTest extends Sprite
{
    public function ImagePyramidRendererTest()
    {
        stage.align = StageAlign.TOP_LEFT
        stage.scaleMode = StageScaleMode.NO_SCALE
        stage.addEventListener(Event.RESIZE,
                               stage_resizeHandler,
                               false, 0, true)

        container = new MultiScaleContainer()
        var transformer:TweenerTransformer = new TweenerTransformer()
        container.transformer = transformer
        
        var mouseController:MouseController = new MouseController()
        var keyboardController:KeyboardController = new KeyboardController()
        var contextMenuController:ContextMenuController = new ContextMenuController()
        container.controllers = [mouseController,
                                 keyboardController,
                                 contextMenuController]
        
        renderManager = new ImagePyramidRenderManager(container.scene,
                                                      container.viewport,
                                                      container.loader)

        var source:IImagePyramidDescriptor
        var numRenderers:int
        var numColumns:int
        var width:Number
        var height:Number
        var path:String


        // Deep Zoom
        path = "http://static.gasi.ch/images/3229924166/image.dzi"
//        path = "../resources/images/deepzoom/billions.xml"
        source =
            new org.openzoom.flash.descriptors.deepzoom.DeepZoomImageDescriptor(path,
                                                                                3872,
                                                                                2592,
                                                                                256, 
                                                                                1,
                                                                                "jpg")
        numRenderers = 100
        numColumns = 128
        width = 387.2
        height = 259.2

//        // OpenStreetMap
//        source = new org.openzoom.flash.descriptors.openstreetmap.OpenStreetMapDescriptor()
//        numRenderers = 1
//        numColumns = 1
//        width = 16384
//        height = 16384

//        // Virtual Earth
//        source = new org.openzoom.flash.descriptors.virtualearth.VirtualEarthDescriptor()
//        numRenderers = 1
//        numColumns = 1
//        width = 16384
//        height = 16384

//        // Zoomify
//        // <IMAGE_PROPERTIES WIDTH="2203" HEIGHT="3290"
//        //  NUMTILES="169" NUMIMAGES="1" VERSION="1.8" TILESIZE="256" />
//        path = "../resources/images/zoomify/morocco/ImageProperties.xml"
//        source = new org.openzoom.flash.descriptors.zoomify.ZoomifyDescriptor(path,
//                                                                              2203,
//                                                                              3290,
//                                                                              169,
//                                                                              256)
//                                                                              
//        numRenderers = 1000
//        numColumns = 60
//        width = 220.3
//        height = 329.0

        
        var padding:Number = width * 0.1
        
        var maxRight:Number = 0
        var maxBottom:Number = 0
        
        for (var i:int = 0; i < numRenderers; i++)
        {
	        var renderer:ImagePyramidRenderer = new ImagePyramidRenderer()
	        renderer.x = (i % numColumns) * (width + padding)
            renderer.y = Math.floor(i / numColumns) * (height + padding)
	        renderer.width = width
	        renderer.height = height
	        renderer.source = source

	        container.addChild(renderer)
            renderManager.addRenderer(renderer)
            
            maxRight = Math.max(maxRight, renderer.x + renderer.width)
            maxBottom = Math.max(maxBottom, renderer.y + renderer.height)
        }

        container.sceneWidth = maxRight
        container.sceneHeight = maxBottom
        
        var scaleConstraint:ScaleConstraint = new ScaleConstraint()
        scaleConstraint.maxScale = source.width / container.sceneWidth
//        container.constraint = scaleConstraint
        addChild(container)
        
        memoryMonitor = new MemoryMonitor()
        addChild(memoryMonitor)
        
        layout()
    }
    
    private var container:MultiScaleContainer
    private var memoryMonitor:MemoryMonitor
    private var renderManager:ImagePyramidRenderManager

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