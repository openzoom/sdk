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

import org.openzoom.flash.descriptors.IImagePyramidDescriptor;
import org.openzoom.flash.descriptors.IImagePyramidLevel;
import org.openzoom.flash.descriptors.ImagePyramidDescriptorBase;
import org.openzoom.flash.descriptors.ImagePyramidLevel;
import org.openzoom.flash.utils.math.clamp;

/**
 * Descriptor for the
 * <a href="http://msdn.microsoft.com/en-us/library/cc645077(VS.95).aspx">
 * Microsoft Deep Zoom Image (DZI) format</a>.
 */
public class DZIDescriptor extends ImagePyramidDescriptorBase
                           implements IImagePyramidDescriptor
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
        _uri = path
        _width = width
        _height = height
        extension = format
        _tileOverlap = tileOverlap
        _type = getType(format)
        _tileWidth = _tileHeight = tileSize
        _numLevels = getNumLevels(width, height)
        createLevels(width, height, tileWidth, tileHeight, numLevels)
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
    public function getTileURL(level:int, column:uint, row:uint):String
    {
        var path:String  = uri.substring(0, uri.length - 4) + "_files"
        return [path, "/", level, "/", column, "_", row, ".", extension].join("")
    }

    /**
     * @inheritDoc
     */
    public function getLevelForSize(width:Number, height:Number):IImagePyramidLevel
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
    public function clone():IImagePyramidDescriptor
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
    private function getNumLevels(width:Number, height:Number):int
    {
        return Math.ceil(Math.log(Math.max(width, height)) / Math.LN2) + 1
    }

    /**
     * @private
     */
    private function createLevels(originalWidth:uint,
                                  originalHeight:uint,
                                  tileWidth:uint,
                                  tileHeight:uint,
                                  numLevels:int):void
    {
        var maxLevel:int = numLevels - 1
        
        for (var index:int = 0; index <= maxLevel; index++)
        {
        	var size:Point = getSize(index)
        	var width:uint = size.x
        	var height:uint = size.y
        	var numColumns:int = Math.ceil(width / tileWidth)
        	var numRows:int = Math.ceil(height / tileHeight)
            var level:IImagePyramidLevel = new ImagePyramidLevel(this,
                                                                 index,
                                                                 width,
                                                                 height,
                                                                 numColumns,
                                                                 numRows)
            addLevel(level)
        }
    }
    
    /**
     * @private
     */ 
    private function getScale(level:int):Number
    {
    	var maxLevel:int = numLevels - 1
    	// 1 / (1 << maxLevel - level)
    	return Math.pow(0.5, maxLevel - level)
    }
    
    /**
     * @private
     */ 
    private function getSize(level:int):Point
    {
        var size:Point = new Point()
        var scale:Number = getScale(level)
        size.x = Math.ceil(width * scale)
        size.y = Math.ceil(height * scale)
        
        return size
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
