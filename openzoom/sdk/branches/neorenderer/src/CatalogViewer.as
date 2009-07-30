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
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.ui.Keyboard;

import org.openzoom.flash.components.MemoryMonitor;
import org.openzoom.flash.components.MultiScaleContainer;
import org.openzoom.flash.descriptors.IImagePyramidDescriptor;
import org.openzoom.flash.descriptors.deepzoom.DeepZoomCollectionDescriptor;
import org.openzoom.flash.descriptors.deepzoom.DeepZoomImageDescriptor;
import org.openzoom.flash.renderers.images.ImagePyramidRenderManager;
import org.openzoom.flash.renderers.images.ImagePyramidRenderer;
import org.openzoom.flash.utils.ExternalMouseWheel;
import org.openzoom.flash.viewport.ISceneViewport;
import org.openzoom.flash.viewport.SceneViewport;
import org.openzoom.flash.viewport.constraints.CenterConstraint;
import org.openzoom.flash.viewport.constraints.CompositeConstraint;
import org.openzoom.flash.viewport.constraints.ScaleConstraint;
import org.openzoom.flash.viewport.constraints.VisibilityConstraint;
import org.openzoom.flash.viewport.constraints.ZoomConstraint;
import org.openzoom.flash.viewport.controllers.ContextMenuController;
import org.openzoom.flash.viewport.controllers.KeyboardController;
import org.openzoom.flash.viewport.controllers.MouseController;
import org.openzoom.flash.viewport.transformers.TweenerTransformer;

[SWF(width="960", height="540", frameRate="60", backgroundColor="#000000")]
public class CatalogViewer extends Sprite
{
    private static var PATH:String = ""
    private static var IMAGE_PATH:String = ""
    
    private static const DEFAULT_SCALE_FACTOR:Number = 1
    
    
    public function CatalogViewer()
    {
        stage.align = StageAlign.TOP_LEFT
        stage.scaleMode = StageScaleMode.NO_SCALE
        stage.addEventListener(Event.RESIZE,
                               stage_resizeHandler,
                               false, 0, true)
                               
        stage.stageFocusRect = false
        
        ExternalMouseWheel.initialize(stage)
        
        
        include "config.as"
        
        loader = new URLLoader()
        loader.addEventListener(Event.COMPLETE,
                                loader_completeHandler,
                                false, 0, true)
        var collectionURL:String = PATH + "collection/collection.dzc"
        loader.load(new URLRequest(collectionURL))
    }

    private var container:MultiScaleContainer
    private var memoryMonitor:MemoryMonitor
    private var renderManager:ImagePyramidRenderManager
    
    private var loader:URLLoader
    
    private var sections:Array = [
                                    [  0,   0], //  Front
                                    [  1,   2], //  Inset
                                    [  3,  10], //  1
                                    [ 11,  14], //  2
                                    [ 15, 100], //  3
                                    [101, 116], //  4
                                    [117, 136], //  5
                                    [137, 156], //  6
                                    [157, 168], //  7
                                    [169, 186], //  8
                                    [187, 200], //  9
                                    [201, 214], // 10
                                    [215, 232], // 11
                                    [233, 248], // 12
                                    [249, 264], // 13
                                    [265, 266], // Legal
                                    [267, 267], // Back
                                 ]
                                 
    private var pageSection:Array = []
    
    private function loader_completeHandler(event:Event):void
    {
        for (var section:int = 0; section < sections.length; section++)
        {
            var firstPage:int = sections[section][0]
            var lastPage:int = sections[section][1]
            
            for (var page:int = firstPage; page <= lastPage; page++)
                pageSection[page] = section
        }
        
        container = new MultiScaleContainer()
        var transformer:TweenerTransformer = new TweenerTransformer()
        transformer.duration = 1.2
//        transformer.easing = "easeOutSine"
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

        var collection:DeepZoomCollectionDescriptor
        var collectionXML:XML = new XML(loader.data)

        collection = new DeepZoomCollectionDescriptor(PATH + "collection/collection.dzc",
                                                      collectionXML)

        path = IMAGE_PATH + "1/image.dzi"
        source = new DeepZoomImageDescriptor(path, 2896, 4096, 254, 1, "png")
        numRenderers = 268
        numColumns = 22 //34 // 67 // 134 // 268
        aspectRatio = source.width / source.height
        width = 256
        height = width / aspectRatio

        var hPadding:Number = width * 0.1
        var vPadding:Number = height * 0.15

        var maxRight:Number = 0
        var maxBottom:Number = 0

        var column:int = 0
        var row:int = 0

        for (var i:int = 0; i < numRenderers; i++)
        {
            var renderer:ImagePyramidRenderer = new ImagePyramidRenderer()
//            renderer.x = (i % numColumns) * (width + padding)
//            renderer.y = Math.floor(i / numColumns) * (height + padding)

            if (i % 2 == 0 && i != 0)
            {
                renderer.x = column * (width + hPadding) - hPadding * 0.66
                renderer.y = row * (height + vPadding)
            }
            else
            {
                renderer.x = column * (width + hPadding)
                renderer.y = row * (height + vPadding)
            }

            renderer.width = width
            renderer.height = height
            
            var s:String = IMAGE_PATH + (i + 1) + "/image.dzi"
            renderer.source = new DeepZoomImageDescriptor(s, 2896, 4096, 254, 1, "png", i, collection)

            container.addChild(renderer)
            renderManager.addRenderer(renderer)
            
            renderer.buttonMode = true
            renderer.addEventListener(MouseEvent.CLICK,
                                      renderer_clickHandler,
                                      false, 0, true)

            maxRight = Math.max(maxRight, renderer.x + renderer.width)
            maxBottom = Math.max(maxBottom, renderer.y + renderer.height)
            
            column++
            if (column == numColumns || pageSection[i] != pageSection[i+1])
            {
                column = 0                
                row++
            }
        }

        container.sceneWidth = maxRight
        container.sceneHeight = maxBottom

        var scaleConstraint:ScaleConstraint = new ScaleConstraint()
        scaleConstraint.maxScale = source.width / container.sceneWidth * numColumns * DEFAULT_SCALE_FACTOR

        var visibilityContraint:VisibilityConstraint = new VisibilityConstraint()
        var centerConstraint:CenterConstraint = new CenterConstraint()
        var zoomConstraint:ZoomConstraint = new ZoomConstraint()
        zoomConstraint.minZoom = 1

        var compositeContraint:CompositeConstraint = new CompositeConstraint()
        compositeContraint.constraints = [scaleConstraint,
//                                          centerConstraint,
//                                          zoomConstraint,
                                          visibilityContraint]
        container.constraint = compositeContraint
        
//        focusIndex = 0
//        focusRenderer(container.getChildAt(0) as ImagePyramidRenderer, 1.0, true)
        
        addChild(container)

        memoryMonitor = new MemoryMonitor()
        addChild(memoryMonitor)
        
        stage.addEventListener(KeyboardEvent.KEY_DOWN,
                               stage_keyDownHandler,
                               false, 0, true)
        layout()
    }
    
    private var focusIndex:int = -1
    private var focusedRenderer:ImagePyramidRenderer = null
    
    private function stage_keyDownHandler(event:KeyboardEvent):void
    {
        var renderer:ImagePyramidRenderer
        
        switch (event.keyCode)
        {
            case Keyboard.TAB:
            {
                var step:int = 1     
                   
                if (event.shiftKey)
                    step = -1
                
                focusIndex = (focusIndex + step) % container.numChildren
                
                if (focusIndex < 0)
                    focusIndex = container.numChildren - 1
                
                renderer = container.getChildAt(focusIndex) as ImagePyramidRenderer
                break
            }
//            case Keyboard.HOME:
//            {
//                focusIndex = 0
//                renderer = container.getChildAt(focusIndex) as ImagePyramidRenderer
//                break
//            }
//            case Keyboard.END:
//            {
//                focusIndex = container.numChildren - 1
//                renderer = container.getChildAt(focusIndex) as ImagePyramidRenderer
//                break
//            }
        }
        
        if (renderer)
            focusRenderer(renderer)
    }
    
    private function renderer_clickHandler(event:MouseEvent):void
    {
        var renderer:ImagePyramidRenderer = event.target as ImagePyramidRenderer
        if (renderer)
        {
            focusIndex = container.getChildIndex(renderer)
            focusRenderer(renderer)
            focusedRenderer = renderer
        }
    }
    
    private function focusRenderer(renderer:ImagePyramidRenderer,
                                   scale:Number=0.8,
                                   immediately:Boolean=false):void
    {
        if (renderer == focusedRenderer && renderer.zoom > 0.5)
            return
            
        var sceneViewport:ISceneViewport = SceneViewport.getInstance(container.viewport)
        var bounds:Rectangle = renderer.getBounds(container.scene.targetCoordinateSpace)
        sceneViewport.fitToBounds(bounds, scale, immediately)
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