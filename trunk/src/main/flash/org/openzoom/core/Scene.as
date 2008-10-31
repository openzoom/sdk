package org.openzoom.core
{

import flash.events.EventDispatcher;

public class Scene extends EventDispatcher implements IScene
{
    public function Scene( width : Number, height : Number )
    {
        _width = width
        _height = height
    }

    private var _width : Number

    public function get width():Number
    {
        return _width
    }

    private var _height : Number

    public function get height():Number
    {
        return _height
    }
    
    public function get aspectRatio() : Number
    {
    	return width / height
    }
}

}