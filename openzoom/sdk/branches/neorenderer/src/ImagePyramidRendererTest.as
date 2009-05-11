package
{

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;

import org.openzoom.flash.components.MemoryMonitor;
import org.openzoom.flash.components.MultiScaleContainer;
import org.openzoom.flash.renderers.images.ImagePyramidRenderManager;
import org.openzoom.flash.renderers.images.ImagePyramidRenderer;
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
                                 
        memoryMonitor = new MemoryMonitor()
        addChild(memoryMonitor)
        
        renderManager = new ImagePyramidRenderManager(container.scene,
                                                      container.viewport,
                                                      container.loader)

        var renderer:ImagePyramidRenderer = new ImagePyramidRenderer()
        renderer.x = 1024
        renderer.y = 1024
        renderer.width = 2048
        renderer.height = 2048
        renderManager.addRenderer(renderer)
        
        container.sceneWidth = 4096
        container.sceneHeight = 4096
        container.addChild(renderer)
        addChild(container)
        
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