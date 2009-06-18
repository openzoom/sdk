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
import flash.display.StageDisplayState;
import flash.display.StageQuality;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.utils.setTimeout;

import org.openzoom.flash.components.MemoryMonitor;
import org.openzoom.flash.components.MultiScaleContainer;
import org.openzoom.flash.descriptors.IImagePyramidDescriptor;
import org.openzoom.flash.descriptors.openstreetmap.OpenStreetMapDescriptor;
import org.openzoom.flash.events.ViewportEvent;
import org.openzoom.flash.renderers.images.ImagePyramidRenderManager;
import org.openzoom.flash.renderers.images.ImagePyramidRenderer;
import org.openzoom.flash.utils.ExternalMouseWheel;
import org.openzoom.flash.viewport.constraints.CenterConstraint;
import org.openzoom.flash.viewport.constraints.CompositeConstraint;
import org.openzoom.flash.viewport.constraints.MappingConstraint;
import org.openzoom.flash.viewport.constraints.ScaleConstraint;
import org.openzoom.flash.viewport.constraints.VisibilityConstraint;
import org.openzoom.flash.viewport.constraints.ZoomConstraint;
import org.openzoom.flash.viewport.controllers.ContextMenuController;
import org.openzoom.flash.viewport.controllers.KeyboardController;
import org.openzoom.flash.viewport.controllers.MouseController;
import org.openzoom.flash.viewport.transformers.TweenerTransformer;

[SWF(width="960", height="600", frameRate="60", backgroundColor="#000000")]
public class dourado extends Sprite
{
	private static const DEFAULT_SCALE_FACTOR:Number = 1.0
	
    public function dourado()
    {
        stage.align = StageAlign.TOP_LEFT
        stage.scaleMode = StageScaleMode.NO_SCALE
        stage.addEventListener(Event.RESIZE,
                               stage_resizeHandler,
                               false, 0, true)
        stage.addEventListener(KeyboardEvent.KEY_DOWN,
                               stage_keyDownHandler,
                               false, 0, true)
        stage.quality = StageQuality.LOW

        ExternalMouseWheel.initialize(stage)

        container = new MultiScaleContainer()
        var transformer:TweenerTransformer = new TweenerTransformer()
        transformer.duration = 0.2
        container.transformer = transformer

        var mouseController:MouseController = new MouseController()
        mouseController.minMouseWheelZoomInFactor = 2.01
        mouseController.minMouseWheelZoomOutFactor = 0.49
        mouseController.smoothPanning = false

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

//        source = new VirtualEarthDescriptor()
        source = new OpenStreetMapDescriptor()
        aspectRatio = source.width / source.height
        width = 16384 * 2
        height = width / aspectRatio

        var renderer:ImagePyramidRenderer = new ImagePyramidRenderer()
        renderer.width = width
        renderer.height = height
        renderer.source = source
//        renderer.smoothing = false

        container.addChild(renderer)
        renderManager.addRenderer(renderer)

        container.sceneWidth = renderer.width
        container.sceneHeight = renderer.height

        // Constraints
        var scaleConstraint:ScaleConstraint = new ScaleConstraint()
        scaleConstraint.maxScale = source.width / container.sceneWidth * DEFAULT_SCALE_FACTOR

        var zoomConstraint:ZoomConstraint = new ZoomConstraint()
        zoomConstraint.minZoom = 1
        
        var centerConstraint:CenterConstraint = new CenterConstraint()
        
        var visibilityContraint:VisibilityConstraint = new VisibilityConstraint()
        var mappingConstraint:MappingConstraint = new MappingConstraint()

        var compositeContraint:CompositeConstraint = new CompositeConstraint()
        compositeContraint.constraints = [scaleConstraint,
                                          centerConstraint,
                                          visibilityContraint,
                                          mappingConstraint,
                                          zoomConstraint,
                                          ]
        container.constraint = compositeContraint
        addChild(container)

        attributionLabel = new AttributionLabel()
        addChild(attributionLabel)

        container.viewport.addEventListener(ViewportEvent.TRANSFORM_UPDATE,
                                            viewport_transformUpdateHandler,
                                            false, 0, true)

        // Layout
        layout()
        
        // Refresh source
        setTimeout(container.showAll, 400, true)
    }

    private var container:MultiScaleContainer
    private var memoryMonitor:MemoryMonitor
    private var renderManager:ImagePyramidRenderManager

    private var attributionLabel:AttributionLabel

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
        
        if (attributionLabel)
        {
            attributionLabel.x = stage.stageWidth - attributionLabel.width
            attributionLabel.y = stage.stageHeight - attributionLabel.height
        }
    }
    
    private function viewport_transformUpdateHandler(event:ViewportEvent):void
    {
//    	trace(container.viewport.scale)
    }

    private function stage_keyDownHandler(event:KeyboardEvent):void
    {
        if (event.keyCode == 70)
            toggleFullScreen()
    }
    
    private function toggleFullScreen():void
    {
        if (stage.displayState == StageDisplayState.NORMAL)
            stage.displayState = StageDisplayState.FULL_SCREEN
        else
            stage.displayState = StageDisplayState.NORMAL
    }
}

}

import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.system.System;
import flash.text.AntiAliasType;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flash.events.MouseEvent;
import flash.net.navigateToURL;
import flash.net.URLRequest;

class AttributionLabel extends Sprite
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     */
    public function AttributionLabel():void
    {
        createBackground()
        createLabel()
        layout()

        mouseEnabled = true
        mouseChildren = false
        buttonMode = true
                
        addEventListener(MouseEvent.CLICK,
                         clickHandler,
                         false, 0, true)
    }

    //--------------------------------------------------------------------------
    //
    //  Children
    //
    //--------------------------------------------------------------------------

    private var label:TextField
    private var background:Shape

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    private function createBackground():void
    {
        background = new Shape()

        var g:Graphics = background.graphics
        g.beginFill(0x101010)
        g.drawRoundRect(0, 0, 160, 22, 0)
        g.endFill()

        addChildAt(background, 0)
    }

    private function createLabel():void
    {
        label = new TextField()

        var textFormat:TextFormat = new TextFormat()
        textFormat.size = 10
        textFormat.font = "Arial"
        textFormat.bold = true
        textFormat.align = TextFormatAlign.CENTER
        textFormat.color = 0xFFFFFF

        label.defaultTextFormat = textFormat
        label.antiAliasType = AntiAliasType.ADVANCED
        label.autoSize = TextFieldAutoSize.LEFT
        label.selectable = false

        label.htmlText = "Powered by OpenStreetMap"
        
        addChild(label)
    }

    private function layout():void
    {
        // center label
        label.x = (background.width - label.width) / 2
        label.y = (background.height - label.height) / 2
    }
    
    private function clickHandler(event:MouseEvent):void
    {
    	navigateToURL(new URLRequest("http://www.openstreetmap.org/"), "_blank")
    }
}
