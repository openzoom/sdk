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
package org.openzoom.flash.descriptors.deepzoom
{

import flash.geom.Rectangle;

import org.openzoom.flash.utils.MIMEUtil;

/**
 * Descriptor for the
 * <a href="http://msdn.microsoft.com/en-us/library/cc645077(VS.95).aspx">
 * Microsoft Deep Zoom Collection (DZC) format</a>.
 */
public final class DeepZoomCollectionDescriptor
{
    //--------------------------------------------------------------------------
    //
    //  Namespaces
    //
    //--------------------------------------------------------------------------

    namespace deepzoom = "http://schemas.microsoft.com/deepzoom/2008"

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function DeepZoomCollectionDescriptor(source:String, xml:XML)
    {
    	use namespace deepzoom
    	
        this.source = source
        _tileSize = xml.@TileSize
        _format = xml.@Format
        _maxLevel = xml.@MaxLevel
        _type = MIMEUtil.getContentType(_format)
        
        var item:CollectionItem
        for each (var itemXML:XML in xml.Items.*)
        {
            item = CollectionItem.fromXML(itemXML)
            items.push(item)
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    private var source:String
    private var items:Array = []
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  format
    //----------------------------------
    
    private var _format:String

    public function get format():String
    {
    	return _format
    }
    
    //----------------------------------
    //  numItems
    //----------------------------------

    public function get numItems():int
    {
    	return items.length
    }

    //----------------------------------
    //  maxLevel
    //----------------------------------
    
    private var _maxLevel:int = 0
    
    /**
     * Maximum level of the collection image pyramid
     */
    public function get maxLevel():int
    {
    	return _maxLevel
    }

    //----------------------------------
    //  type
    //----------------------------------
    
    private var _type:String
    
    /**
     * MIME type of the collection
     */ 
    public function get type():String
    {
        return type
    }

    //----------------------------------
    //  tileSize
    //----------------------------------
    
    private var _tileSize:uint
    
    /**
     * Tile size of the collection image pyramid.
     */ 
    public function get tileSize():uint
    {
        return _tileSize
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * Returns the URL of the tile of a collection item specified
     * by its Morton number and level.
     */
    public function getTileURL(mortonNumber:uint, level:int):String
    {
    	return ""
    }
    
    /**
     * Returns the bounds (position and dimensions) of the tile of
     * a collection item specified by its Morton number and level.
     */
    public function getTileBounds(mortonNumber:uint, level:int):Rectangle
    {
    	return new Rectangle()
    }
    
    public function getItemBounds(mortonNumber:uint):Rectangle
    {
    	var item:CollectionItem = getItemAt(mortonNumber)
    	return item.bounds.clone()
    }
    
    public function getDescriptor(mortonNumber:uint):DeepZoomImageDescriptor
    {
        return null	
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Internal
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private
     */
    private function getItemAt(index:int):CollectionItem
    {
    	return items[index]
    } 
      
    /**
     * @private
     */ 
    private function getScale(level:int):Number
    {
        // 1 / (1 << maxLevel - level)
        return Math.pow(0.5, maxLevel - level)
    }
    
//    /**
//     * @private
//     */ 
//    private function getSize(level:int):Point
//    {
//        var size:Point = new Point()
//        var scale:Number = getScale(level)
//        size.x = Math.ceil(width * scale)
//        size.y = Math.ceil(height * scale)
//        
//        return size
//    }
}

}
	import flash.geom.Rectangle;
	

//------------------------------------------------------------------------------
//
//  Internal classes
//
//------------------------------------------------------------------------------

/**
 * Represents a single item from the collection.
 */
class CollectionItem
{
    //--------------------------------------------------------------------------
    //
    //  Namespaces
    //
    //--------------------------------------------------------------------------

    namespace deepzoom = "http://schemas.microsoft.com/deepzoom/2008"

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
	public function CollectionItem()
	{
		// Do nothing
	}
	
	/**
	 * Create collection item from XML
	 */
	public static function fromXML(xml:XML):CollectionItem
	{
        use namespace deepzoom
	   
        var item:CollectionItem = new CollectionItem()

        item.id = xml.@Id
        item.n = xml.@N
        item.source = xml.@Source
        item.width = xml.Size.@Width
        item.height = xml.Size.@Height
        
        var aspectRatio:Number = item.width / item.height
        item.bounds = new Rectangle(0, 0, 1, 1 / aspectRatio)

        if (xml.Viewport)
        {
            item.viewportWidth = xml.Viewport.@Width
            item.viewportX = xml.Viewport.@X
            item.viewportY = xml.Viewport.@Y
            
	        item.bounds.x = -item.viewportX / item.viewportWidth
	        item.bounds.y = -item.viewportY / item.viewportWidth
	        item.bounds.width = 1 / item.viewportWidth
	        item.bounds.height = item.bounds.width / aspectRatio
        }

        return item	
	}
	
	public var source:String
	
	public var id:uint
	public var n:uint
	public var width:uint
	public var height:uint

    public var viewportWidth:Number = 1
    public var viewportX:Number = 0
    public var viewportY:Number = 0
    
    public var bounds:Rectangle
}