package org.openzoom.flash.utils.string
{
	public function format(string:String, ...rest):String
	{
		var result:String = string
		
		for (var i:int = 0; i < rest.length; i++)
		{
			result = result.replace("{" + i + "}", rest[i]) 
		}
		
		return result
	}
}