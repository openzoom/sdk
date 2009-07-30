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
import flash.geom.Rectangle;
import flash.utils.setTimeout;

import org.openzoom.flash.components.MemoryMonitor;
import org.openzoom.flash.components.MultiScaleImage2;
import org.openzoom.flash.descriptors.IImagePyramidDescriptor;
import org.openzoom.flash.descriptors.deepzoom.DeepZoomImageDescriptor;
import org.openzoom.flash.descriptors.gigapan.GigaPanDescriptor;
import org.openzoom.flash.events.ViewportEvent;
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
public class GigaPanViewer2 extends Sprite
{
    public function GigaPanViewer2()
    {
        // FIXME
//        stage.quality = StageQuality.HIGH
        
        stage.align = StageAlign.TOP_LEFT
        stage.scaleMode = StageScaleMode.NO_SCALE
        stage.addEventListener(Event.RESIZE,
                               stage_resizeHandler,
                               false, 0, true)

        ExternalMouseWheel.initialize(stage)

        image = new MultiScaleImage2()
        image.transformer = new TweenerTransformer()
        
        // Smooth transformer
        transformer = new SmoothTransformer()
        transformer.viewport = image.viewport

        // Controllers
        var mouseController:MouseController = new MouseController()
        var keyboardController:KeyboardController = new KeyboardController()
        var contextMenuController:ContextMenuController = new ContextMenuController()
        image.controllers = [mouseController,
                             keyboardController,
                             contextMenuController]

        var source:IImagePyramidDescriptor

        // Deep Zoom: Hanauma Bay
        var path:String = "http://gigapan-mobile.appspot.com/gigapan/5322.dzi"
        source = new DeepZoomImageDescriptor(path, 154730, 36408, 256, 0, "jpg")
        source = GigaPanDescriptor.fromID(5322, 154730, 36408)
        source = GigaPanDescriptor.fromID(23611, 204600, 47202)
//        source = GigaPanDescriptor.fromID(14766, 125440, 39680)
//        source = GigaPanDescriptor.fromID(25701, 41315, 11548)
//        source = GigaPanDescriptor.fromID(6568, 180504, 27837)


        image.source = source

        var scaleConstraint:ScaleConstraint = new ScaleConstraint()
        scaleConstraint.maxScale = source.width / image.sceneWidth * 4

        var mappingConstraint:MappingConstraint = new MappingConstraint()
        var visibilityContraint:VisibilityConstraint = new VisibilityConstraint()
        visibilityContraint.visibilityRatio = 1.0

        var zoomConstraint:ZoomConstraint = new ZoomConstraint()
        zoomConstraint.minZoom = 1

        var centerConstraint:CenterConstraint = new CenterConstraint()
        var fillConstraint:FillConstraint = new FillConstraint()

        var compositeContraint:CompositeConstraint = new CompositeConstraint()
        compositeContraint.constraints = [
                                          scaleConstraint,
                                          visibilityContraint,
                                          zoomConstraint,
                                          centerConstraint,
                                          ]
        image.constraint = compositeContraint

        addChild(image)

        memoryMonitor = new MemoryMonitor()
        addChild(memoryMonitor)

        layout()
        
        image.viewport.addEventListener(ViewportEvent.TARGET_UPDATE,
                                            viewport_targetUpdateHandler,
                                            false, 0, true)
                           
        stage.addEventListener(KeyboardEvent.KEY_DOWN,
                               keyDownHandler,
                               false, 0, true)
                               
        setTimeout(image.showAll, 500, true)
    }

    private var image:MultiScaleImage2
    private var transformer:SmoothTransformer
    
    private var memoryMonitor:MemoryMonitor

    private function stage_resizeHandler(event:Event):void
    {
        layout()
    }

    private function layout():void
    {
        if (image)
        {
            image.width = stage.stageWidth
            image.height = stage.stageHeight
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
        
        var target:IViewportTransform = image.viewport.transform
        var bounds:Rectangle = new Rectangle(0.1 + Math.random() * 0.8,
                                             0.1 + Math.random() * 0.8,
                                             0.01,
                                             0.01)
        target.fitToBounds(bounds)

        if (transformer)
            transformer.transform(target)
    }
    
    private function viewport_targetUpdateHandler(event:ViewportEvent):void
    {
        if (transformer)
            transformer.stop()
    }
}

}
