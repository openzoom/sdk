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

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;

import org.openzoom.flash.components.MultiScaleContainer;
import org.openzoom.flash.viewport.controllers.KeyboardController;
import org.openzoom.flash.viewport.controllers.MouseController;
import org.openzoom.flash.viewport.transformers.TweenerTransformer;

[SWF(width="960", height="600", frameRate="60", backgroundColor="#222222")]
/**
 * Example that illustrates how to use interactive renderers with the OpenZoom SDK.
 */
public class InteractiveRenderers extends Sprite
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
	public function InteractiveRenderers()
    {
    	stage.align = StageAlign.TOP_LEFT
    	stage.scaleMode = StageScaleMode.NO_SCALE
    	stage.addEventListener(Event.RESIZE, stage_resizeHandler)
    	
    	container = new MultiScaleContainer()
    	container.transformer = new TweenerTransformer()
    	var mouseController:MouseController = new MouseController()
    	var keyboardController:KeyboardController = new KeyboardController()
    	container.controllers = [mouseController, keyboardController]
    	
    	var spacing:uint = 100
    	
    	for (var i:int = 0; i < 500; i++)
    	{
    		var format:String
            if (Math.random() > 0.5)
                format = Format.LANDSCAPE
            else
                format = Format.PORTRAIT
                 
    		var renderer:InteractiveRenderer = new InteractiveRenderer(format)
    		var dimension:Number = InteractiveRenderer.DIMENSION 
    		var offsetX:Number = (renderer.width - dimension) / 2 
    		var offsetY:Number = (renderer.height - dimension) / 2 
    		renderer.x = (i % 20) * (dimension + spacing) - offsetX
    		renderer.y = Math.floor(i / 20) * (dimension + spacing) - offsetY
    		
    		container.addChild(renderer)
    	}
    	
    	var lastRenderer:DisplayObject = container.getChildAt(i-1)
    	container.sceneWidth = lastRenderer.x + lastRenderer.width
    	container.sceneHeight = lastRenderer.y + lastRenderer.height
    	
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


class InteractiveRenderer extends Renderer
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------
    
	public static const DIMENSION:Number = 300
	public static const ASPECT_RATIO:Number = 2/3
	public static const PADDING:Number = 8
	
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     * Constructor.
     */ 
	public function InteractiveRenderer(format:String)
	{
		addEventListener(RendererEvent.ADDED_TO_SCENE,
		                 addedToSceneHandler,
		                 false, 0, true)
		draw(format)
	}
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
	
	private function draw(format:String):void
	{
        var width:Number
        var height:Number
        
        if (format == Format.LANDSCAPE)
        {
            width = DIMENSION
            height = DIMENSION * ASPECT_RATIO
        }
        else
        {
            width = DIMENSION * ASPECT_RATIO
            height = DIMENSION
        }
        
        var g:Graphics = graphics
        g.beginFill(0xFFFFFF)
        g.drawRect(0, 0, width, height)
        g.endFill()
        
        g.beginFill(0x000000)
        g.drawRect(PADDING,
                   PADDING,
                   width - 2 * PADDING,
                   height - 2 * PADDING)
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
	}
	
	private function clickHandler(event:MouseEvent):void
	{
		var vp:ISceneViewport = SceneViewport.getInstance(viewport)
		vp.fitToBounds(getBounds(scene.targetCoordinateSpace), 0.5)
	}
}


class Format
{
	public static const PORTRAIT:String = "portrait" 
	public static const LANDSCAPE:String = "landscape"
}