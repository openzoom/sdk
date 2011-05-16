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
//  Portions created by the Initial Developer are Copyright (c) 2007-2010
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

import org.openzoom.flash.components.MultiScaleContainer;
import org.openzoom.flash.renderers.Renderer;
import org.openzoom.flash.viewport.controllers.ContextMenuController;
import org.openzoom.flash.viewport.controllers.KeyboardController;
import org.openzoom.flash.viewport.controllers.MouseController;
import org.openzoom.flash.viewport.transformers.TweenerTransformer;

[SWF(width="960", height="600", frameRate="60", backgroundColor="#222222")]
public class RendererVisibility extends Sprite
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
	public function RendererVisibility()
    {
    	stage.align = StageAlign.TOP_LEFT
    	stage.scaleMode = StageScaleMode.NO_SCALE
    	stage.addEventListener(Event.RESIZE, stage_resizeHandler)
    	
    	container = new MultiScaleContainer()
    	
    	var transformer:TweenerTransformer = new TweenerTransformer()
//      transformer.easing = "easeOutElastic"
//    	transformer.duration = 1
    	container.transformer = transformer
    	
    	var mouseController:MouseController = new MouseController()
    	var keyboardController:KeyboardController = new KeyboardController()
    	var contextMenuController:ContextMenuController = new ContextMenuController()
    	
    	contextMenuController.panUp = false
    	contextMenuController.panDown = false
    	contextMenuController.panRight = false
    	contextMenuController.panLeft = false
    	
    	contextMenuController.zoomIn = false
    	contextMenuController.zoomOut = false
    	
    	container.controllers = [mouseController,
    	                         keyboardController,
    	                         contextMenuController]
    	
//    	container.sceneWidth = 1000
//    	container.sceneHeight = 1000
//    	
//        var renderer:Renderer
//        renderer = new BoxRenderer()
//        renderer.x = 100
//        renderer.y = 100
//        container.addChild(renderer)

        var spacing:uint = 100
        var maxRight:Number = 0
        var maxBottom:Number = 0
        var numColumns:uint = 60

        for (var i:int = 0; i < 800; i++)
        {
            var renderer:BoxRenderer = new BoxRenderer()
            var dimension:Number = BoxRenderer.DIMENSION
            var offsetX:Number = (renderer.width - dimension) / 2
            var offsetY:Number = (renderer.height - dimension) / 2
            renderer.x = (i % numColumns) * (dimension + spacing) - offsetX
            renderer.y = Math.floor(i / numColumns) * (dimension + spacing) - offsetY

            if (renderer.x + renderer.width > maxRight)
                maxRight = renderer.x + renderer.width

            if (renderer.y + renderer.height > maxBottom)
                maxBottom = renderer.y + renderer.height

            container.addChild(renderer)
        }

        container.sceneWidth = maxRight
        container.sceneHeight = maxBottom

    	
    	addChild(container)
    	layout()
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var container:MultiScaleContainer

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

    private function stage_resizeHandler(event:Event):void
    {
    	layout()
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    private function layout():void
    {
    	if (container)
    	{
    		container.width = stage.stageWidth
    		container.height = stage.stageHeight
    	}
    }
}

}


import flash.display.Sprite;
import flash.display.Graphics;
import flash.events.MouseEvent;

import org.openzoom.flash.events.RendererEvent;
import org.openzoom.flash.renderers.Renderer;
import org.openzoom.flash.viewport.ISceneViewport;
import org.openzoom.flash.viewport.SceneViewport;
import flash.geom.Rectangle;
import org.openzoom.flash.events.ViewportEvent;


class BoxRenderer extends Renderer
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

	public static const DIMENSION:Number = 100
	
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
	public function BoxRenderer()
	{
		addEventListener(RendererEvent.ADDED_TO_SCENE,
		                 addedToSceneHandler,
		                 false, 0, true)
		draw()
	}

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
	
	private function draw():void
	{
        var g:Graphics = graphics
        g.clear()
        g.beginFill(0x000000)
        g.drawRect(0, 0, DIMENSION, DIMENSION)
        g.endFill()
	}

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------
	
	private function addedToSceneHandler(event:RendererEvent):void
	{
		addEventListener(MouseEvent.CLICK,
		                 clickHandler,
		                 false, 0, true)

        viewport.addEventListener(ViewportEvent.TRANSFORM_UPDATE,
                                  viewport_transformEndHandler,
                                  false, 0, true)
	}
	
	private function viewport_transformEndHandler(event:ViewportEvent):void
	{
		var vp:ISceneViewport = SceneViewport.getInstance(viewport)
        var bounds:Rectangle = getBounds(scene.targetCoordinateSpace)

        if (!vp.intersects(bounds))
            return

        var visibleBounds:Rectangle = vp.intersection(bounds)
        visibleBounds.offset(-bounds.x, -bounds.y)

//        trace("visibleBounds:", visibleBounds, width, height, scaleX, scaleY)

        draw()
        var g:Graphics = graphics
        g.beginFill(0xFF0000)
        g.drawRect(visibleBounds.x + 10, visibleBounds.y + 10,
                   visibleBounds.width - 20, visibleBounds.height - 20)
        g.endFill()
	}
	
	private function clickHandler(event:MouseEvent):void
	{
		var vp:ISceneViewport = SceneViewport.getInstance(viewport)
        var bounds:Rectangle = getBounds(scene.targetCoordinateSpace)
		vp.fitToBounds(bounds, 0.6)
	}
}
