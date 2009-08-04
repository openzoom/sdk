package
{

import flash.display.Graphics;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.events.FocusEvent;
import flash.utils.setTimeout;

[SWF(width="960", height="600", frameRate="30", backgroundColor="#000000")]
public class Activation extends Sprite
{
	public function Activation()
	{
		stage.align = StageAlign.TOP_LEFT
		stage.scaleMode = StageScaleMode.NO_SCALE
        stage.addEventListener(Event.ACTIVATE,
                               stage_activateHandler,
                               false, 0, true)
        stage.addEventListener(Event.DEACTIVATE,
                               stage_deactivateHandler,
                               false, 0, true)
        stage.addEventListener(FocusEvent.FOCUS_IN,
                               stage_activateHandler,
                               false, 0, true)
        drawBackground(0x00CC00)
		
        setTimeout(drawBackground, 100, 0x00CC00)
	}
	
	private function stage_activateHandler(event:Event):void
	{
		drawBackground(0x00CC00)
	}
	
	private function stage_deactivateHandler(event:Event):void
	{
		drawBackground(0xCC0000)
	}
	
	private function drawBackground(color:uint):void
	{
		var g:Graphics = graphics
		g.clear()
		g.beginFill(color)
		g.drawRect(0, 0, stage.stageWidth, stage.stageHeight)
		g.endFill()
	}
}

}
