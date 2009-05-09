package org.openzoom.flash.renderers
{

import flash.display.Graphics;

import org.openzoom.flash.descriptors.virtualearth.VirtualEarthDescriptor;


public class MultiScaleImageRendererX extends Renderer
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     * Constructor.
     */ 
    public function MultiScaleImageRendererX()
    {
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  source
    //----------------------------------
    
    private var _source:* = new VirtualEarthDescriptor()
    
    public function get source():*
    {
    	return _source
    }
    
    public function set source(value:*):void
    {
    	if (_source !== value)
    	   return
    	
    	_source = value
    }

    //----------------------------------
    //  width
    //----------------------------------
    
    private var _width:Number = 0
    
    override public function get width():Number
    {
        return _width
    }
    
    override public function set width(value:Number):void
    {
    	if (value === _width)
    	   return
    	   
        _width = value
        
        drawFrame(width, height)
    }

    //----------------------------------
    //  height
    //----------------------------------
    
    private var _height:Number = 0
    
    override public function get height():Number
    {
        return _height
    }
    
    override public function set height(value:Number):void
    {
    	if (value === _height)
    	   return
    	   
        _height = value
        
        drawFrame(width, height)
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    private function drawFrame(width:Number, height:Number):void
    {
    	var g:Graphics = graphics
    	g.beginFill(0x000000, 0)
    	g.drawRect(0, 0, width, height)
    	g.endFill()
    }
}

}