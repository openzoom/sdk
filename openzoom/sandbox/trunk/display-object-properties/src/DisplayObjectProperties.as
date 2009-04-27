package
{

import flash.display.Sprite;

[SWF(width="960", height="600", frameRate="60", backgroundColor="#222222")]
public class DisplayObjectProperties extends Sprite
{
    public function DisplayObjectProperties()
    {
        var box1:Box = new Box(100, 100, 0xFF600)
        addChild(box1)
        
        var box2:Box = new Box(50, 50, 0xFF6600)
        box2.x = 25
        box2.y = 25
        box1.addChild(box2)
        
        box1.width = 500
        box1.width = 500
        trace(box1.toString())
        trace(box2.toString())
    }
}

}

import flash.display.Sprite;
import flash.display.Graphics;
    

class Box extends Sprite
{
    public function Box(width:Number, height:Number, color:uint = 0xFFFFFF)
    {
        var g:Graphics = graphics
        g.beginFill(color)
        g.drawRect(0, 0, width, height)
        g.endFill()
    }
    
    override public function toString():String
    {
    	return ["scaleX:", scaleX,
                "scaleY:", scaleY,
                "width:", width,
                "height:", height].join(" ")
    }
}