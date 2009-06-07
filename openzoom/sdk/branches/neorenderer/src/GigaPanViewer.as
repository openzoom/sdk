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
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.utils.setTimeout;

import org.openzoom.flash.components.MemoryMonitor;
import org.openzoom.flash.components.MultiScaleContainer;
import org.openzoom.flash.descriptors.IImagePyramidDescriptor;
import org.openzoom.flash.descriptors.deepzoom.DeepZoomImageDescriptor;
import org.openzoom.flash.renderers.images.ImagePyramidRenderManager;
import org.openzoom.flash.renderers.images.ImagePyramidRenderer;
import org.openzoom.flash.utils.ExternalMouseWheel;
import org.openzoom.flash.viewport.constraints.CenterConstraint;
import org.openzoom.flash.viewport.constraints.CompositeConstraint;
import org.openzoom.flash.viewport.constraints.FillConstraint;
import org.openzoom.flash.viewport.constraints.ScaleConstraint;
import org.openzoom.flash.viewport.constraints.VisibilityConstraint;
import org.openzoom.flash.viewport.constraints.ZoomConstraint;
import org.openzoom.flash.viewport.controllers.ContextMenuController;
import org.openzoom.flash.viewport.controllers.KeyboardController;
import org.openzoom.flash.viewport.controllers.MouseController;
import org.openzoom.flash.viewport.transformers.TweenerTransformer;

[SWF(width="960", height="600", frameRate="60", backgroundColor="#000000")]
public class GigaPanViewer extends Sprite
{
    public function GigaPanViewer()
    {
        stage.align = StageAlign.TOP_LEFT
        stage.scaleMode = StageScaleMode.NO_SCALE
        stage.addEventListener(Event.RESIZE,
                               stage_resizeHandler,
                               false, 0, true)

        ExternalMouseWheel.initialize(stage)

        container = new MultiScaleContainer()
        var transformer:TweenerTransformer = new TweenerTransformer()
        container.transformer = transformer

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

        // Deep Zoom: Obama
        path = "http://7.latest.gigapan-mobile.appspot.com/gigapan/15374.dzi"
        source = new DeepZoomImageDescriptor(path, 59783, 24658, 256, 0, "jpg")
        numRenderers = 1
        numColumns = 1
        aspectRatio = source.width / source.height
        width = 16384
        height = 16384 / aspectRatio

        // Deep Zoom: CMU
//        path = "http://7.latest.gigapan-mobile.appspot.com/gigapan/23379.dzi"
//        source = new DeepZoomImageDescriptor(path, 79433, 17606, 256, 0, "jpg")
//        numRenderers = 1
//        numColumns = 1
//        aspectRatio = source.width / source.height
//        width = 16384
//        height = 16384 / aspectRatio

        // Deep Zoom: Hanauma Bay
        path = "http://7.latest.gigapan-mobile.appspot.com/gigapan/5322.dzi"
        source = new DeepZoomImageDescriptor(path, 154730, 36408, 256, 0, "jpg")
        numRenderers = 1
        numColumns = 1
        aspectRatio = source.width / source.height
        width = 16384
        height = width / aspectRatio

//        source = new GigaPanDescriptor(5322, 154730, 36408)
//        numRenderers = 1
//        numColumns = 1
//        aspectRatio = source.width / source.height
//        width = 16384
//        height = width / aspectRatio
        
        // GigaPan: Twin Peaks (San Francisco)
//        source = new GigaPanDescriptor(1155, 141812, 25730)
//        numRenderers = 1
//        numColumns = 1
//        aspectRatio = source.width / source.height
//        width = 16384
//        height = width / aspectRatio
        
        // Deep Zoom: Twin Peaks (San Francisco)
//        path = "http://7.latest.gigapan-mobile.appspot.com/gigapan/1155.dzi"
//        source = new DeepZoomImageDescriptor(path, 141812, 25730, 256, 0, "jpg")
//        numRenderers = 1
//        numColumns = 1
//        aspectRatio = source.width / source.height
//        width = 16384
//        height = width / aspectRatio
        
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

        // Constraints
        var scaleConstraint:ScaleConstraint = new ScaleConstraint()
        scaleConstraint.maxScale = source.width / container.sceneWidth * 4

        var zoomConstraint:ZoomConstraint = new ZoomConstraint()
        zoomConstraint.minZoom = 1
        
        var centerConstraint:CenterConstraint = new CenterConstraint()
        
        var visibilityContraint:VisibilityConstraint = new VisibilityConstraint()
//        visibilityContraint.visibilityRatio = 1

        var compositeContraint:CompositeConstraint = new CompositeConstraint()
        compositeContraint.constraints = [scaleConstraint,
                                          centerConstraint,
                                          zoomConstraint,
                                          visibilityContraint]
        container.constraint = compositeContraint

        addChild(container)

        memoryMonitor = new MemoryMonitor()
        addChild(memoryMonitor)

        layout()
        
        setTimeout(container.showAll, 500)
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