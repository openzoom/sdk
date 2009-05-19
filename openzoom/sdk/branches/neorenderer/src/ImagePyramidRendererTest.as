package
{

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;

import org.openzoom.flash.components.MemoryMonitor;
import org.openzoom.flash.components.MultiScaleContainer;
import org.openzoom.flash.descriptors.IImagePyramidDescriptor;
import org.openzoom.flash.descriptors.deepzoom.DZIDescriptor;
import org.openzoom.flash.descriptors.openstreetmap.OpenStreetMapDescriptor;
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
//    	Security.loadPolicyFile("http://tile.openstreetmap.org/crossdomain.xml")

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
//        source = new DZIDescriptor("../resources/images/deepzoom/billions.xml",
//                                   3872, 2592, 256, 1, "jpg")
        source = new OpenStreetMapDescriptor()
        
        var numRenderers:int = 1
        var numColumns:int = 1
//        var width:Number = 3872
//        var height:Number = 2592
        var width:Number = 16384
        var height:Number = 16384
        var padding:Number = 100
        
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