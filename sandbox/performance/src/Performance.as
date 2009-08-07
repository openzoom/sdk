package
{

import flash.display.Sprite;
import flash.utils.getTimer;

public class Performance extends Sprite
{
	private static const NUM_ITERATIONS:int = 1000000
	
    public function Performance()
    {
    	var plainObject:PlainObject = new PlainObject()
    	var getterSetterObject:GetterSetterObject = new GetterSetterObject()
    	
    	var value:Number
    	
    	// Test #1
    	var startTime:int = getTimer()
    	
    	for (var i:int = 0; i < NUM_ITERATIONS; i++)
    	{
    		plainObject.value = 5
    		value = plainObject.value
    	}
    	
    	trace(getTimer() - startTime)
    	
        // Test #2
    	startTime = getTimer()
    	
    	for (var j:int = 0; j < NUM_ITERATIONS; j++)
    	{
    		getterSetterObject.value = 5
    		value = getterSetterObject.value
    	}
    	
    	trace(getTimer() - startTime)
    }
}

}

class GetterSetterObject
{
	private var _value:Number
	
	public function get value():Number
	{
		return _value
	}
	
	public function set value(value:Number):void
	{
		_value = value
	}
}

class PlainObject
{
    public var value:Number
}