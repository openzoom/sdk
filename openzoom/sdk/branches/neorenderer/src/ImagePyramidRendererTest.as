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

import org.openzoom.flash.components.MemoryMonitor;
import org.openzoom.flash.components.MultiScaleContainer;
import org.openzoom.flash.descriptors.IImagePyramidDescriptor;
import org.openzoom.flash.descriptors.deepzoom.DeepZoomImageDescriptor;
import org.openzoom.flash.descriptors.virtualearth.VirtualEarthDescriptor;
import org.openzoom.flash.descriptors.zoomify.ZoomifyDescriptor;
import org.openzoom.flash.renderers.images.ImagePyramidRenderManager;
import org.openzoom.flash.renderers.images.ImagePyramidRenderer;
import org.openzoom.flash.viewport.constraints.CompositeConstraint;
import org.openzoom.flash.viewport.constraints.MappingConstraint;
import org.openzoom.flash.viewport.constraints.ScaleConstraint;
import org.openzoom.flash.viewport.constraints.VisibilityConstraint;
import org.openzoom.flash.viewport.controllers.ContextMenuController;
import org.openzoom.flash.viewport.controllers.KeyboardController;
import org.openzoom.flash.viewport.controllers.MouseController;
import org.openzoom.flash.viewport.transformers.TweenerTransformer;


[SWF(width="960", height="600", frameRate="60", backgroundColor="#000000")]
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
//        mouseController.minMouseWheelZoomInFactor = 2.01
//        mouseController.minMouseWheelZoomOutFactor = 0.45
//        mouseController.smoothPanning = false
        
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
        var aspectRatio:Number


        // Deep Zoom
//        path = "http://static.gasi.ch/images/3229924166/image.dzi"
////        path = "../resources/images/deepzoom/billions.xml"
//        source = new DeepZoomImageDescriptor(path, 3872, 2592, 256,  1, "jpg")
//        numRenderers = 1
//        numColumns = 1
//        width = 3872
//        height = 2592

        // Deep Zoom: Carina Nebula
        path = "http://seadragon.com/content/images/CarinaNebula.dzi"
        source = new DeepZoomImageDescriptor(path, 29566, 14321, 254,  1, "jpg")
        numRenderers = 1
        numColumns = 1
        aspectRatio = source.width / source.height 
        width = 16384
        height = 16384 / aspectRatio
        
//        // Deep Zoom: Inline Multiscale Image Replacement
//        path = "http://gasi.ch/examples/2009/04/08/inline-multiscale-image-replacement/nytimes/ridge-run/image.dzi"
//        source = new DeepZoomImageDescriptor(path, 3627, 2424, 256,  1, "jpg")
//        numRenderers = 300
//        numColumns = 24
//        aspectRatio = source.width / source.height 
//        width = 163.84
//        height = width / aspectRatio
        
        // Deep Zoom: World wide music scene
//        path = "http://seadragon.com/content/images/lastfm.dzi"
//        source = new DeepZoomImageDescriptor(path, 20000, 15000, 254,  1, "jpg")
//        numRenderers = 1
//        numColumns = 1
//        aspectRatio = source.width / source.height 
//        width = 16384
//        height = 16384 / aspectRatio
        
//        // Deep Zoom: Obama
//        path = "http://7.latest.gigapan-mobile.appspot.com/gigapan/15374.dzi"
//        source = new DeepZoomImageDescriptor(path, 59783, 24658, 256, 0, "jpg")
//        numRenderers = 1
//        numColumns = 1
//        aspectRatio = source.width / source.height 
//        width = 16384
//        height = 16384 / aspectRatio
//        
//        // Deep Zoom: CMU
//        path = "http://7.latest.gigapan-mobile.appspot.com/gigapan/23379.dzi"
//        source = new DeepZoomImageDescriptor(path, 79433, 17606, 256, 0, "jpg")
//        numRenderers = 1
//        numColumns = 1
//        aspectRatio = source.width / source.height 
//        width = 16384
//        height = 16384 / aspectRatio

        // Deep Zoom: Hanauma Bay
//        path = "http://7.latest.gigapan-mobile.appspot.com/gigapan/5322.dzi"
//        source = new DeepZoomImageDescriptor(path, 154730, 36408, 256, 0, "jpg")
//        numRenderers = 1//400
//        numColumns = 1//12
//        aspectRatio = source.width / source.height 
//        width = 16384
//        height = width / aspectRatio

        // Zoomify
//        path = "http://shutter.gigapixelphotography.com/images/vancouver-yaletown-condos/ImageProperties.xml"
//        source = new ZoomifyDescriptor(path, 46953, 22255, 21420, 256)
//        numRenderers = 1
//        numColumns = 1
//        aspectRatio = source.width / source.height 
//        width = 16384
//        height = 16384 / aspectRatio

        // OpenStreetMap
//        source = new OpenStreetMapDescriptor()
//        numRenderers = 1
//        numColumns = 1
//        width = 16384
//        height = 16384

//        // Virtual Earth
//        source = new VirtualEarthDescriptor()
//        numRenderers = 1
//        numColumns = 1
//        width = 16384
//        height = 16384

        // Zoomify
        // <IMAGE_PROPERTIES WIDTH="2203" HEIGHT="3290"
        //  NUMTILES="169" NUMIMAGES="1" VERSION="1.8" TILESIZE="256" />
//        path = "../resources/images/zoomify/morocco/ImageProperties.xml"
//        source = new ZoomifyDescriptor(path, 2203, 3290, 169, 256)
//                                                                              
//        numRenderers = 360
//        numColumns = 36
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
        scaleConstraint.maxScale = source.width / container.sceneWidth * 4
//        container.constraint = scaleConstraint

        var mappingConstraint:MappingConstraint = new MappingConstraint()
        var visibilityContraint:VisibilityConstraint = new VisibilityConstraint()
        visibilityContraint.visibilityRatio = 0.5
        
        var compositeContraint:CompositeConstraint = new CompositeConstraint()
        compositeContraint.constraints = [scaleConstraint]
//        compositeContraint.constraints = [scaleConstraint,
//                                          mappingConstraint]
//        compositeContraint.constraints = [scaleConstraint,
//                                          visibilityContraint,
//                                          mappingConstraint]
//        container.constraint = compositeContraint
        
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