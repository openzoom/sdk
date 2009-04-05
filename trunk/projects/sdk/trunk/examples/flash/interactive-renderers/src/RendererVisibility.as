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
