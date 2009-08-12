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

import flash.display.Sprite
import flash.display.StageAlign
import flash.display.StageScaleMode
import flash.events.ContextMenuEvent
import flash.events.Event
import flash.net.URLRequest
import flash.net.navigateToURL
import flash.ui.ContextMenuItem

import org.openzoom.flash.components.MemoryMonitor
import org.openzoom.flash.components.MultiScaleContainer
import org.openzoom.flash.descriptors.rosettaproject.RosettaDiskBackDescriptor
import org.openzoom.flash.descriptors.rosettaproject.RosettaDiskFrontDescriptor
import org.openzoom.flash.renderers.images.ImagePyramidRenderManager
import org.openzoom.flash.renderers.images.ImagePyramidRenderer
import org.openzoom.flash.utils.ExternalMouseWheel
import org.openzoom.flash.viewport.constraints.CenterConstraint
import org.openzoom.flash.viewport.constraints.CompositeConstraint
import org.openzoom.flash.viewport.constraints.ScaleConstraint
import org.openzoom.flash.viewport.constraints.VisibilityConstraint
import org.openzoom.flash.viewport.constraints.ZoomConstraint
import org.openzoom.flash.viewport.controllers.ContextMenuController
import org.openzoom.flash.viewport.controllers.KeyboardController
import org.openzoom.flash.viewport.controllers.MouseController
import org.openzoom.flash.viewport.transformers.TweenerTransformer


[SWF(width="960", height="600", frameRate="60", backgroundColor="#FFFFFF")]
public class RosettaProjectViewer extends Sprite
{
    // Attribution
    private static const ABOUT_CAPTION:String = "About OpenZoom..."
    private static const ABOUT_URL:String = "http://openzoom.org/"

    public function RosettaProjectViewer()
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

        var numRenderers:int
        var numColumns:int
        var width:Number
        var height:Number
        var path:String
        var aspectRatio:Number

        var sources:Array = [new RosettaDiskFrontDescriptor(), new RosettaDiskBackDescriptor()]
        numRenderers = 2
        numColumns = 2
        width = 8192
        height = 8192

        var padding:Number = 0

        var maxRight:Number = 0
        var maxBottom:Number = 0

        for (var i:int = 0; i < numRenderers; i++)
        {
            var renderer:ImagePyramidRenderer = new ImagePyramidRenderer()
            renderer.x = (i % numColumns) * (width + padding)
            renderer.y = Math.floor(i / numColumns) * (height + padding)
            renderer.width = width
            renderer.height = height
            renderer.source = sources[i]

            container.addChild(renderer)
            renderManager.addRenderer(renderer)

            maxRight = Math.max(maxRight, renderer.x + renderer.width)
            maxBottom = Math.max(maxBottom, renderer.y + renderer.height)
        }

        container.sceneWidth = maxRight
        container.sceneHeight = maxBottom

        var scaleConstraint:ScaleConstraint = new ScaleConstraint()
        scaleConstraint.maxScale = sources[1].width / container.sceneWidth * 8

        var visibilityContraint:VisibilityConstraint = new VisibilityConstraint()
        visibilityContraint.visibilityRatio = 0.5

        var centerConstraint:CenterConstraint = new CenterConstraint()
        var zoomConstraint:ZoomConstraint = new ZoomConstraint()
        zoomConstraint.minZoom = 0.4
        var compositeContraint:CompositeConstraint = new CompositeConstraint()
        compositeContraint.constraints = [zoomConstraint,
                                          centerConstraint,
                                          scaleConstraint,
                                          visibilityContraint]
        container.constraint = compositeContraint

        addChild(container)

        memoryMonitor = new MemoryMonitor()
        addChild(memoryMonitor)

        // Credits where credits are due
        var aboutMenu:ContextMenuItem =
                new ContextMenuItem(ABOUT_CAPTION,
                                    true /* Separator */)
        aboutMenu.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,
                                   aboutMenu_menuItemSelectHandler,
                                   false, 0, true)
        container.contextMenu.customItems.push(aboutMenu)

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

    private function aboutMenu_menuItemSelectHandler(event:ContextMenuEvent):void
    {
        navigateToURL(new URLRequest(ABOUT_URL), "_blank")
    }
}

}