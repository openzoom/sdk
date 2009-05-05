package org.openzoom.examples.powerLawScaling.renderers
{

import org.openzoom.examples.powerLawScaling.Pin;
import org.openzoom.flash.events.RendererEvent;
import org.openzoom.flash.events.ViewportEvent;
import org.openzoom.flash.renderers.Renderer;

public class AdvancedPinRenderer extends Renderer
{
	public function AdvancedPinRenderer()
	{
        addEventListener(RendererEvent.ADDED_TO_SCENE,
                         addedToSceneHandler,
                         false, 0, true)
	}
	
	private function addedToSceneHandler(event:RendererEvent):void
	{
        viewport.addEventListener(ViewportEvent.TRANSFORM_UPDATE,
                                  viewport_transformUpdateHandler,
                                  false, 0, true)
        addChild(new Pin())
        layout()
	}
	
	private function viewport_transformUpdateHandler(event:ViewportEvent):void
	{
		layout()
	}
	
	private function layout():void
	{
		// Inspired by «Powerlaw scaling of synchronized content with Deep Zoom»
		// http://blogs.msdn.com/lutzg/archive/2008/11/03/powerlaw-scaling-of-synchronized-content-with-deep-zoom.aspx
        var factor:Number = Math.log(1 / viewport.width) / Math.LN2
        var scale:Number = Math.pow(0.02 * (factor + 1), 2) + 0.01
		scaleX = scaleY = scale / viewport.scale * 16
	}
}

}