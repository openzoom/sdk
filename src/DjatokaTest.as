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
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.geom.Rectangle;

import org.openzoom.flash.components.MemoryMonitor;
import org.openzoom.flash.components.MultiScaleContainer;
import org.openzoom.flash.descriptors.IImagePyramidDescriptor;
import org.openzoom.flash.descriptors.deepzoom.DeepZoomImageDescriptor;
import org.openzoom.flash.descriptors.djatoka.DjatokaDescriptor;
import org.openzoom.flash.descriptors.virtualearth.VirtualEarthDescriptor;
import org.openzoom.flash.renderers.images.ImagePyramidRenderManager;
import org.openzoom.flash.renderers.images.ImagePyramidRenderer;
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
public class DjatokaTest extends Sprite
{
    public function DjatokaTest()
    {
        stage.align = StageAlign.TOP_LEFT
        stage.scaleMode = StageScaleMode.NO_SCALE
        stage.addEventListener(Event.RESIZE,
                               stage_resizeHandler,
                               false, 0, true)

        ExternalMouseWheel.initialize(stage)

        container = new MultiScaleContainer()
        var tweenerTransformer:TweenerTransformer = new TweenerTransformer()
        container.transformer = tweenerTransformer
        
        // Smooth transformer
        smoothTransformer = SmoothTransformer.getInstance(container.viewport)

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
//        path = "http://7.latest.gigapan-mobile.appspot.com/gigapan/5322.dzi"
//        source = new DeepZoomImageDescriptor(path, 154730, 36408, 256, 0, "jpg")
//        numRenderers = 1
//        numColumns = 1
//        aspectRatio = source.width / source.height
//        width = 16384
//        height = width / aspectRatio

        // Djatoka
//        source = new DjatokaDescriptor("http://african.lanl.gov/adore-djatoka/resolver",
//                                       "info:lanl-repo/ds/5aa182c2-c092-4596-af6e-e95d2e263de3&",
//                                       5120,
//                                       3372)
//                                       
//        source = new DjatokaDescriptor("http://african.lanl.gov/adore-djatoka/resolver",
//                                       "http://mars.asu.edu/~cyates/P01_001337_1945_XN_14N065W.jp2",
//                                       5056, 11264, 256, 0, "image/jpeg", 5)
                                       
//        source = DjatokaDescriptor.fromJSONMetadata("http://african.lanl.gov/adore-djatoka/resolver",
//                                                    "http://mars.asu.edu/~cyates/P01_001337_1945_XN_14N065W.jp2",
//                                                    '{\n"identifier": "http://mars.asu.edu/~cyates/P01_001337_1945_XN_14N065W.jp2",\n' + 
//                                                    '"imagefile": "/home/rchute/tomcat/temp/cache160035104950802.jp2",\n' + 
//                                                    '"width": "5056",\n' + 
//                                                    '"height": "11264",\n' + 
//                                                    '"dwtLevels": "5",\n' + 
//                                                    '"levels": "5",\n' + 
//                                                    '"compositingLayerCount": "1"\n' + 
//                                                    '}')
                                                    
        var jsonString:String = '{"identifier": "http://mars.asu.edu/~cyates/P01_001337_1945_XN_14N065W.jp2",' + 
                                 '"imagefile": "/home/rchute/tomcat/temp/cache160035104950802.jp2",' + 
                                 '"width": "5056",' + 
                                 '"height": "11264",' + 
                                 '"dwtLevels": "5",' + 
                                 '"levels": "5",' + 
                                 '"compositingLayerCount": "1"}'
        source = DjatokaDescriptor.fromJSONMetadata("http://african.lanl.gov/adore-djatoka/resolver",
                                                    "http://mars.asu.edu/~cyates/P01_001337_1945_XN_14N065W.jp2",
                                                    jsonString)

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
                                         0.05,
                                         0.05))
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
}

}