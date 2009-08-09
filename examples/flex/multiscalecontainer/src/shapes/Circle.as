package shapes
{

import flash.display.Graphics;
import flash.display.Sprite;    

public class Circle extends Sprite
{
    public function Circle()
    {
        updateDisplayList()
    }

    private var _radius:Number = 10
    private var _color:uint = 0xFF6600
    private var _opacity:uint = 1.0

    public function get color():uint
    {
        return _color
    }

    public function set color(value:uint):void
    {
        _color = value
        updateDisplayList()
    }

    public function get radius():Number
    {
        return _radius
    }

    public function set radius(value:Number):void
    {
        _radius = value
        updateDisplayList()
    }

    protected function updateDisplayList():void
    {
        var g:Graphics = this.graphics
            g.clear()
            g.beginFill(_color, _opacity)
            g.drawCircle(_radius, _radius, _radius)
            g.endFill()
    }
}

}