package org.openzoom.flash.renderers
{

import flash.display.Graphics;
import flash.display.Sprite;
import flash.geom.Point;


public class MultiScaleImageRendererX extends Renderer
{
    public function MultiScaleImageRendererX()
    {
    	tileLayer = new Sprite()
    	
    	var g:Graphics = tileLayer.graphics
    	g.beginFill(0x0088FF)
    	g.drawRect(0, 0, 400, 300)
    	g.endFill()
    	
    	addChild(tileLayer)
    }
    
    private var tileLayer:Sprite
    
    private var invalidateDisplayListFlag:Boolean = false
    
    public function invalidateDisplayList():void
    {
    	if (!invalidateDisplayListFlag)
            invalidateDisplayListFlag = true
    }
    
    public function validateDisplayList():void
    {
    	if (invalidateDisplayListFlag)
    		updateDisplayList()
    }
    
    private function updateDisplayList():void
    {
    	if (!viewport)
    	   return

        // Compute visible bounds
        
        // Clear previously drawn images
        
        // Clear tile layer
        var g:Graphics = tileLayer.graphics
        g.clear()
        
        var transformOrigin:Point = viewport.transform.getOrigin()

        
        // Determine tiles to draw
        //   Load tiles if not available
        //     Cache loaded tiles
        //        If cache full, evict oldest cache item (LRU)
        
        // Compute highest level that fills visible bounds
        
        // Draw from optimal layer down to previously determined layer
        //   Fade in new tiles using bitmap fills with alpha channel
    }
}

}