package
{

import flash.display.Sprite;
import flash.utils.Dictionary;

public class DictionarySandbox extends Sprite
{
	public function DictionarySandbox()
	{
		var dictionary:Dictionary = new Dictionary()
		var item:Object = dictionary["http://example.com/"]
		trace(item)
	}
}

}
