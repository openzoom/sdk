////////////////////////////////////////////////////////////////////////////////
//
//  OpenZoom
//
//  Copyright (c) 2007-2009, Daniel Gasienica <daniel@gasienica.ch>
//
//  OpenZoom is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  OpenZoom is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with OpenZoom. If not, see <http://www.gnu.org/licenses/>.
//
////////////////////////////////////////////////////////////////////////////////
package org.openzoom.gigapan
{

import com.adobe.serialization.json.JSON;

	
[Bindable]
/**
 * The GigaPan class holds information about a GigaPan image.
 */
public class GigaPan
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function GigaPan()
    {
    }
    
    public static function fromJSON(jsonString:String):GigaPan
    {
    	var data:Object = JSON.decode(jsonString)
    	var gigapan:GigaPan = new GigaPan()
    	
    	gigapan.id = data.id
    	gigapan.name = data.name
    	gigapan.description = data.description
    	
    	gigapan.width = data.width
    	gigapan.height = data.height
    	
    	gigapan.views = data.views
    	gigapan.gigapixels = data.gigapixels
    	
        return gigapan    	
    }
    
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    public var id:uint
    public var name:String
    public var description:String
    
//    public var dateUploaded:Date
//    public var dateUpdated:Date
//    public var dateTaken:Date
    
    public var width:uint = 0
    public var height:uint = 0
    
    public var views:int
    public var gigapixels:Number
}

}