////////////////////////////////////////////////////////////////////////////////
//
//  OpenZoom SDK
//
//  Version: MPL 1.1/GPL 3/LGPL 3
//
//  The contents of this file are subject to the Mozilla Public License Version
//  1.1 (the "License"); you may not use this file except in compliance with
//  the License. You may obtain a copy of the License at
//  http://www.mozilla.org/MPL/
//
//  Software distributed under the License is distributed on an "AS IS" basis,
//  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
//  for the specific language governing rights and limitations under the
//  License.
//
//  The Original Code is the OpenZoom SDK.
//
//  The Initial Developer of the Original Code is Daniel Gasienica.
//  Portions created by the Initial Developer are Copyright (c) 2007-2009
//  the Initial Developer. All Rights Reserved.
//
//  Contributor(s):
//    Daniel Gasienica <daniel@gasienica.ch>
//
//  Alternatively, the contents of this file may be used under the terms of
//  either the GNU General Public License Version 3 or later (the "GPL"), or
//  the GNU Lesser General Public License Version 3 or later (the "LGPL"),
//  in which case the provisions of the GPL or the LGPL are applicable instead
//  of those above. If you wish to allow use of your version of this file only
//  under the terms of either the GPL or the LGPL, and not to allow others to
//  use your version of this file under the terms of the MPL, indicate your
//  decision by deleting the provisions above and replace them with the notice
//  and other provisions required by the GPL or the LGPL. If you do not delete
//  the provisions above, a recipient may use your version of this file under
//  the terms of any one of the MPL, the GPL or the LGPL.
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
import flash.utils.setTimeout;

import org.openzoom.flash.components.MemoryMonitor;
import org.openzoom.flash.components.MultiScaleImage2;
import org.openzoom.flash.descriptors.IImagePyramidDescriptor;
import org.openzoom.flash.descriptors.deepzoom.DeepZoomImageDescriptor;
import org.openzoom.flash.events.ViewportEvent;
import org.openzoom.flash.utils.ExternalMouseWheel;
import org.openzoom.flash.viewport.IViewportTransform;
import org.openzoom.flash.viewport.constraints.CenterConstraint;
import org.openzoom.flash.viewport.constraints.CompositeConstraint;
import org.openzoom.flash.viewport.constraints.FillConstraint;
import org.openzoom.flash.viewport.constraints.ScaleConstraint;
import org.openzoom.flash.viewport.constraints.VisibilityConstraint;
import org.openzoom.flash.viewport.constraints.ZoomConstraint;
import org.openzoom.flash.viewport.controllers.ContextMenuController;
import org.openzoom.flash.viewport.controllers.KeyboardController;
import org.openzoom.flash.viewport.controllers.MouseController;
import org.openzoom.flash.viewport.transformers.SmoothTransformer;
import org.openzoom.flash.viewport.transformers.TweenerTransformer;

[SWF(width="960", height="600", frameRate="60", backgroundColor="#000000")]
public class GigaPanViewer extends Sprite
{
    public function GigaPanViewer()
    {
        // FIXME
        stage.quality = StageQuality.HIGH

        stage.align = StageAlign.TOP_LEFT
        stage.scaleMode = StageScaleMode.NO_SCALE
        stage.addEventListener(Event.RESIZE,
                               stage_resizeHandler,
                               false, 0, true)

        ExternalMouseWheel.initialize(stage)

        image = new MultiScaleImage2()
        image.transformer = new TweenerTransformer()

        // Smooth transformer
        transformer = SmoothTransformer.getInstance(image.viewport)

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
//        source = GigaPanDescriptor.fromID(5322, 154730, 36408)
//        source = GigaPanDescriptor.fromID(23611, 204600, 47202)
//        source = GigaPanDescriptor.fromID(14766, 125440, 39680)
//        source = GigaPanDescriptor.fromID(25701, 41315, 11548)
//        source = GigaPanDescriptor.fromID(6568, 180504, 27837)


        image.source = source

        var scaleConstraint:ScaleConstraint = new ScaleConstraint()
        scaleConstraint.maxScale = source.width / image.sceneWidth * 2

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

//        memoryMonitor = new MemoryMonitor()
//        addChild(memoryMonitor)

        layout()

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
