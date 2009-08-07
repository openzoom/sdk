package test
{

import flash.display.Graphics;

import mx.core.UIComponent;	

public class Rect extends UIComponent
{
    public function Rect()
    {
    }
    
    private var _color:uint = 0xFF6600;
    
    [Bindable]
    public function get color():uint
    {
    	return _color
    }
    
    public function set color(value:uint):void
    {
    }
    
    override protected function updateDisplayList(unscaledWidth:Number,
                                                  unscaledHeight:Number):void
    {
        var g:Graphics = this.graphics
            g.clear()
            g.beginFill(_color)
            g.drawRect(0, 0, unscaledWidth, unscaledHeight)
            g.endFill()
    }
}

}