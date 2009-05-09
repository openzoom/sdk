package
{

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.utils.setTimeout;

import org.openzoom.flash.components.MemoryMonitor;
import org.openzoom.flash.components.MultiScaleContainer;
import org.openzoom.flash.renderers.MultiScaleImageRenderManager;
import org.openzoom.flash.renderers.MultiScaleImageRendererX;
import org.openzoom.flash.viewport.controllers.ContextMenuController;
import org.openzoom.flash.viewport.controllers.KeyboardController;
import org.openzoom.flash.viewport.controllers.MouseController;
import org.openzoom.flash.viewport.transformers.TweenerTransformer;


[SWF(width="960", height="600", frameRate="60", backgroundColor="#222222")]
public class MultiScaleImageRendererXTest extends Sprite
{
    public function MultiScaleImageRendererXTest()
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
        
        renderManager = new MultiScaleImageRenderManager(container.viewport,
                                                         container.loader)

        var renderer:MultiScaleImageRendererX = new MultiScaleImageRendererX()
        renderer.width = 4096
        renderer.height = 4096
        renderManager.addRenderer(renderer)
        
        container.sceneWidth = 4096
        container.sceneHeight = 4096
        container.addChild(renderer)
        addChild(container)
        
        layout()
        
//        setTimeout(function():void {renderer.height = 2048}, 2000)
    }
    
    private var container:MultiScaleContainer
    private var memoryMonitor:MemoryMonitor
    private var renderManager:MultiScaleImageRenderManager

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