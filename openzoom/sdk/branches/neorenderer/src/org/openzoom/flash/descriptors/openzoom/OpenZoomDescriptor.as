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
package org.openzoom.flash.descriptors.openzoom
{

import flash.geom.Rectangle;
import flash.utils.Dictionary;

import org.openzoom.flash.descriptors.IImageSourceDescriptor;
import org.openzoom.flash.descriptors.IImagePyramidDescriptor;
import org.openzoom.flash.descriptors.IImagePyramidLevel;
import org.openzoom.flash.descriptors.ImageSourceDescriptor;
import org.openzoom.flash.descriptors.ImagePyramidDescriptorBase;
import org.openzoom.flash.utils.math.clamp;
import org.openzoom.flash.utils.uri.resolveURI;

/**
 * OpenZoom Descriptor.
 * <a href="http://openzoom.org/specs/">http://openzoom.org/specs/</a>
 */
public final class OpenZoomDescriptor extends ImagePyramidDescriptorBase
                                      implements IImagePyramidDescriptor
{
    //--------------------------------------------------------------------------
    //
    //  Namespaces
    //
    //--------------------------------------------------------------------------

    namespace openzoom = "http://ns.openzoom.org/openzoom/2008"

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function OpenZoomDescriptor(uri:String, data:XML)
    {
        use namespace openzoom

        this.data = data

        _source = uri
        parseXML(data)
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var data:XML
    private var levels:Dictionary = new Dictionary()

    //--------------------------------------------------------------------------
    //
    //  Properties: IMultiScaleImageDescriptor
    //
    //--------------------------------------------------------------------------
    
    private var _sources:Array = []
    
    /**
     * @inheritDoc
     */ 
    override public function get sources():Array
    {
        return _sources.slice(0)    
    }

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
        return IImagePyramidLevel(levels[level]).getTileURL(column, row)
    }

    /**
     * @inheritDoc
     */
    public function getLevelForSize(width:Number,
                                    height:Number):IImagePyramidLevel
    {
        var level:IImagePyramidLevel

        for (var i:int = numLevels - 1; i >= 0; i--)
        {
            level = getLevelAt(i)
            if (level.width <= width || level.height <= height)
                break
        }

        var maxLevel:uint = numLevels - 1
        var index:int = level.index
        return getLevelAt(clamp(index, 0, maxLevel))
    }

    /**
     * @inheritDoc
     */
    public function clone():IImagePyramidDescriptor
    {
        return new OpenZoomDescriptor(source, data.copy())
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
        return "[OpenZoomDescriptor]" + "\n" + super.toString()
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Internal
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    private function parseXML(data:XML):void
    {
        use namespace openzoom
        
        // Parse sources
        for each (var source:XML in data.source)
        {
            var path:String = this.source.substring(0, this.source.lastIndexOf("/") + 1)
            var sourceUri:String = resolveURI(path, source.@uri)
            var width:uint = source.@width
            var height:uint = source.@height
            var type:String = source.@type
            
            var descriptor:IImageSourceDescriptor
            descriptor = new ImageSourceDescriptor(sourceUri, width, height, type)
            
            _sources.push(descriptor)
        }

        // Grrrrh, E4X
        var pyramid:XML = data.pyramid[0]

        _width = pyramid.@width
        _height = pyramid.@height
        _tileWidth = pyramid.@tileWidth
        _tileHeight = pyramid.@tileHeight

        _type = pyramid.@type
        _tileOverlap = pyramid.@tileOverlap

        _numLevels = data.pyramid.level.length()

        if (ImagePyramidOrigin.isValid(pyramid.@origin))
            _origin = pyramid.@origin

        for (var index:int = 0; index < numLevels; index++)
        {
            var level:XML = data.pyramid.level[index]
            var uris:Array = []

            for each (var uri:XML in level.uri)
                uris.push(source.@template.toString())

            levels[index] = new ImagePyramidLevel(this,
                                                     index,
                                                     level.@width,
                                                     level.@height,
                                                     level.@columns,
                                                     level.@rows,
                                                     uris,
                                                     origin)
        }
    }
}

}
