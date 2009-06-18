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
package
{

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageQuality;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.geom.Rectangle;

import org.openzoom.flash.components.MemoryMonitor;
import org.openzoom.flash.components.MultiScaleContainer;
import org.openzoom.flash.descriptors.IImagePyramidDescriptor;
import org.openzoom.flash.descriptors.deepzoom.DeepZoomImageDescriptor;
import org.openzoom.flash.descriptors.gigapan.GigaPanDescriptor;
import org.openzoom.flash.descriptors.virtualearth.VirtualEarthDescriptor;
import org.openzoom.flash.events.ViewportEvent;
import org.openzoom.flash.renderers.images.ImagePyramidRenderManager;
import org.openzoom.flash.renderers.images.ImagePyramidRenderer;
import org.openzoom.flash.utils.ExternalMouseWheel;
import org.openzoom.flash.viewport.IViewportTransform;
import org.openzoom.flash.viewport.constraints.CenterConstraint;
import org.openzoom.flash.viewport.constraints.CompositeConstraint;
import org.openzoom.flash.viewport.constraints.FillConstraint;
import org.openzoom.flash.viewport.constraints.MappingConstraint;
import org.openzoom.flash.viewport.constraints.ScaleConstraint;
import org.openzoom.flash.viewport.constraints.VisibilityConstraint;
import org.openzoom.flash.viewport.constraints.ZoomConstraint;
import org.openzoom.flash.viewport.controllers.ContextMenuController;
import org.openzoom.flash.viewport.controllers.KeyboardController;
import org.openzoom.flash.viewport.controllers.MouseController;
import org.openzoom.flash.viewport.transformers.SmoothTransformer;
import org.openzoom.flash.viewport.transformers.TweenerTransformer;

[SWF(width="960", height="600", frameRate="60", backgroundColor="#000000")]
public class SmoothTransformerTest extends Sprite
{
    public function SmoothTransformerTest()
    {
        stage.align = StageAlign.TOP_LEFT
        stage.scaleMode = StageScaleMode.NO_SCALE
        stage.addEventListener(Event.RESIZE,
                               stage_resizeHandler,
                               false, 0, true)

        ExternalMouseWheel.initialize(stage)

        container = new MultiScaleContainer()
        var tweenerTransformer:TweenerTransformer = new TweenerTransformer()
//        tweenerTransformer.duration = 0.8
        container.transformer = tweenerTransformer

//        container.viewport.addEventListener(ViewportEvent.TRANSFORM_START,
//                                            viewport_transformStartHandler,
//                                            false, 0, true)
//        container.viewport.addEventListener(ViewportEvent.TRANSFORM_END,
//                                            viewport_transformEndHandler,
//                                            false, 0, true)
        
        // Smooth transformer
        smoothTransformer = SmoothTransformer.getInstance(container.viewport)
//        smoothTransformer.speed = 1.6

        // Controllers
        var mouseController:MouseController = new MouseController()
        var keyboardController:KeyboardController = new KeyboardController()
        var contextMenuController:ContextMenuController = new ContextMenuController()
        container.controllers = [mouseController,
                                 keyboardController,
                                 contextMenuController]

        renderManager = new ImagePyramidRenderManager(container,
                                                      container.scene,
                                                      container.viewport,
                                                      container.loader)

        var source:IImagePyramidDescriptor
        var numRenderers:int
        var numColumns:int
        var width:Number
        var height:Number
        var path:String
        var aspectRatio:Number

        // Deep Zoom: Carina Nebula
        path = "http://seadragon.com/content/images/CarinaNebula.dzi"
        source = new DeepZoomImageDescriptor(path, 29566, 14321, 254,  1, "jpg")
        numRenderers = 1
        numColumns = 1
        aspectRatio = source.width / source.height
        width = 16384
        height = 16384 / aspectRatio

        // Virtual Earth
        source = new VirtualEarthDescriptor()
        numRenderers = 1
        numColumns = 1
        width = 16384
        height = 16384

//        // Deep Zoom: Hanauma Bay
        path = "http://7.latest.gigapan-mobile.appspot.com/gigapan/5322.dzi"
        source = new DeepZoomImageDescriptor(path, 154730, 36408, 256, 0, "jpg")
        numRenderers = 1
        numColumns = 1
        aspectRatio = source.width / source.height
        width = 16384
        height = width / aspectRatio

//        source = GigaPanDescriptor.fromID(14766, 125440, 39680)
//        numRenderers = 1
//        numColumns = 1
//        aspectRatio = source.width / source.height
//        width = 16384
//        height = width / aspectRatio
        
        source = GigaPanDescriptor.fromID(6568, 180504, 27837)
        numRenderers = 1
        numColumns = 1
        aspectRatio = source.width / source.height
        width = 16384
        height = width / aspectRatio


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
        scaleConstraint.maxScale = source.width / container.sceneWidth * numColumns * 4

        var mappingConstraint:MappingConstraint = new MappingConstraint()
        var visibilityContraint:VisibilityConstraint = new VisibilityConstraint()
//        visibilityContraint.visibilityRatio = 1.0

        var zoomConstraint:ZoomConstraint = new ZoomConstraint()
        zoomConstraint.minZoom = 1

        var centerConstraint:CenterConstraint = new CenterConstraint()
        var fillConstraint:FillConstraint = new FillConstraint()

        var compositeContraint:CompositeConstraint = new CompositeConstraint()
        compositeContraint.constraints = [
                                          scaleConstraint,
                                          zoomConstraint,
                                          centerConstraint,
                                          visibilityContraint,
//                                          fillConstraint,
                                          ]
//        compositeContraint.constraints = [scaleConstraint,
//                                          mappingConstraint]
//        compositeContraint.constraints = [scaleConstraint,
//                                          visibilityContraint,
//                                          mappingConstraint]
        container.constraint = compositeContraint

        addChild(container)

        memoryMonitor = new MemoryMonitor()
        addChild(memoryMonitor)

        layout()
                                                
        stage.addEventListener(KeyboardEvent.KEY_DOWN,
                               keyDownHandler,
                               false, 0, true)
    }

    private var container:MultiScaleContainer
    private var memoryMonitor:MemoryMonitor
    private var renderManager:ImagePyramidRenderManager

    private var smoothTransformer:SmoothTransformer

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
    
    private function keyDownHandler(event:KeyboardEvent):void
    {
        if (event.keyCode != 76) // L
            return
        
        var target:IViewportTransform = container.viewport.transform
        target.fitToBounds(new Rectangle(0.1 + Math.random() * 0.8,
                                         0.1 + Math.random() * 0.8,
                                         0.005,
                                         0.005))
//        target.fitToBounds(new Rectangle(0.45 + Math.random() * 0.05,
//                                         0.45 + Math.random() * 0.2,
//                                         0.01,
//                                         0.01))
//        target.fitToBounds(new Rectangle(0.5 + Math.random() * 0.4,
//                                         0.3 + Math.random() * 0.4,
//                                         0.00004,
//                                         0.00004))
//        target.fitToBounds(new Rectangle(0.5234956109333568,
//                                         0.35019891395599395,
//                                         0.00004,
//                                         0.00004))
        
        smoothTransformer.transform(target)
    }
    
    private function viewport_transformStartHandler(event:ViewportEvent):void
    {
        stage.quality = StageQuality.LOW
    }
    
    private function viewport_transformEndHandler(event:ViewportEvent):void
    {
        stage.quality = StageQuality.BEST
    }
}

}