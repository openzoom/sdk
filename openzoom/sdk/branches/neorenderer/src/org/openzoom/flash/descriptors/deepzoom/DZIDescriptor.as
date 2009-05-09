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

import flash.geom.Point;
import flash.geom.Rectangle;
import flash.utils.Dictionary;

import org.openzoom.flash.descriptors.IMultiScaleImageDescriptor;
import org.openzoom.flash.descriptors.IMultiScaleImageLevel;
import org.openzoom.flash.descriptors.MultiScaleImageDescriptorBase;
import org.openzoom.flash.descriptors.MultiScaleImageLevel;
import org.openzoom.flash.utils.math.clamp;

/**
 * Descriptor for the
 * <a href="http://msdn.microsoft.com/en-us/library/cc645077(VS.95).aspx">
 * Microsoft Deep Zoom Image (DZI) format</a>.
 */
public class DZIDescriptor extends MultiScaleImageDescriptorBase
                           implements IMultiScaleImageDescriptor
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
    public function DZIDescriptor(path:String,
                                  width:uint,
                                  height:uint,
                                  tileSize:uint,
                                  tileOverlap:uint,
                                  format:String)
    {
        this.uri = path
        _width = width
        _height = height
        extension = format
        _tileOverlap = tileOverlap
        _type = getType(format)
        _tileWidth = _tileHeight = tileSize
        _numLevels = computeNumLevels(width, height)
        levels = computeLevels(width, height, tileWidth, tileHeight, numLevels)
    }

    /**
     * Create descriptor from XML.
     */
    public static function fromXML(path:String, data:XML):DZIDescriptor
    {
        use namespace deepzoom

        var width:uint = data.Size.@Width
        var height:uint = data.Size.@Height
        var tileSize:uint = data.@TileSize
        var tileOverlap:uint = data.@Overlap
        var format:String = data.@Format

        return new DZIDescriptor(path, width, height,
                                 tileSize, tileOverlap,
                                 format)
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var extension:String
    private var levels:Dictionary

    //--------------------------------------------------------------------------
    //
    //  Methods: IMultiScaleImageDescriptor
    //
    //--------------------------------------------------------------------------

    /**
     * @inheritDoc
     */
    override public function getTileBounds(level:int, column:uint, row:uint):Rectangle
    {
        var bounds:Rectangle = new Rectangle()
        var offsetX:uint = (column == 0) ? 0 : tileOverlap
        var offsetY:uint = (row == 0) ? 0 : tileOverlap
        bounds.x = (column * tileWidth) - offsetX
        bounds.y = (row * tileHeight) - offsetY
        
        var l:IMultiScaleImageLevel = getLevelAt(level)
        var width:uint = tileWidth + (column == 0 ? 1 : 2) * tileOverlap
        var height:uint = tileHeight + (row == 0 ? 1 : 2) * tileOverlap
        bounds.width = Math.min(width, l.width - bounds.x)
        bounds.height = Math.min(height, l.height - bounds.y)
                
        return bounds
    }

    /**
     * @inheritDoc
     */
    public function getTileURL(level:int, column:uint, row:uint):String
    {
        var path:String  = uri.substring(0, uri.length - 4) + "_files"
        return [path, "/", level, "/", column, "_", row, ".", extension].join("")
    }

    /**
     * @inheritDoc
     */
    override public function getTileAtPoint(level:int, point:Point):Point
    {
    	var p:Point = new Point()
    	
    	var l:IMultiScaleImageLevel = getLevelAt(level)
    	p.x = Math.floor((point.x * l.width) / tileWidth)
    	p.y = Math.floor((point.y * l.height) / tileHeight)
    	
    	return p
    }

    /**
     * @inheritDoc
     */
    public function getLevelAt(index:int):IMultiScaleImageLevel
    {
        return levels[index]
    }

    /**
     * @inheritDoc
     */
    public function getLevelForSize(width:Number, height:Number):IMultiScaleImageLevel
    {
        var longestSide:Number = Math.max(width, height)
        var log2:Number = Math.log(longestSide) / Math.LN2
        var maxLevel:uint = numLevels - 1
        var index:int = clamp(Math.floor(log2), 0, maxLevel)
        
        return getLevelAt(index)
    }

    /**
     * @inheritDoc
     */
    public function clone():IMultiScaleImageDescriptor
    {
        return new DZIDescriptor(uri, width, height, tileWidth, tileOverlap, extension)
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Debug
    //
    //--------------------------------------------------------------------------

    /**
     * @inheritDoc
     */
    override public function toString():String
    {
        return "[DZIDescriptor]" + "\n" + super.toString()
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Internal
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    private function getType(format:String):String
    {
        var type:String

        switch (format)
        {
            case "jpg":
               type = "image/jpeg"
               break

            case "png":
               type = "image/png"
               break

            default:
               throw new ArgumentError("Unknown extension: " + extension)
               break
        }

        return type
    }

    /**
     * @private
     */
    private function getFormat(type:String):String
    {
        var format:String

        switch (type)
        {
            case "image/jpeg":
               type = "jpg"
               break

            case "image/png":
               type = "png"
               break

            default:
               throw new ArgumentError("Unknown mime type: " + type)
               break
        }

        return format
    }

    /**
     * @private
     */
    private function computeNumLevels(width:Number, height:Number):int
    {
        return Math.ceil(Math.log(Math.max(width, height)) / Math.LN2) + 1
    }

    /**
     * @private
     */
    private function computeLevels(originalWidth:uint,
                                   originalHeight:uint,
                                   tileWidth:uint,
                                   tileHeight:uint,
                                   numLevels:int):Dictionary
    {
        var levels:Dictionary = new Dictionary()

        var width :uint = originalWidth
        var height:uint = originalHeight

        for (var index:int = numLevels - 1; index >= 0; index--)
        {
            levels[index] = new MultiScaleImageLevel(this, index, width, height,
                                                       Math.ceil(width / tileWidth),
                                                       Math.ceil(height / tileHeight))
            width = Math.ceil(width / 2)
            height = Math.ceil(height / 2)
        }

//        Twitter on 17.09.2008
//        for (var i:int=max;i>=0;i--){levels[i]=new Level(w,h,Math.ceil(w/tileWidth),Math.ceil(h/tileHeight));w=Math.ceil(w/2);h=Math.ceil(h/2)}

        return levels
    }
}

}

//------------------------------------------------------------------------------
//
//  Internal classes
//
//------------------------------------------------------------------------------

import flash.geom.Rectangle

/**
 * @private
 */
class DisplayRect extends Rectangle
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function DisplayRect(x:Number, y:Number,
                                width:Number, height:Number,
                                minLevel:int, maxLevel:int)
    {
        super(x, y, width, height)
        _minLevel = minLevel
        _maxLevel = maxLevel
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  minLevel
    //----------------------------------

    /**
     * @private
     */
    private var _minLevel:int

    public function get minLevel():int
    {
        return _minLevel
    }

    //----------------------------------
    //  maxLevel
    //----------------------------------

    /**
     * @private
     */
    private var _maxLevel:int

    public function get maxLevel():int
    {
        return _maxLevel
    }
}
