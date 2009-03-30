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

import flash.utils.Dictionary;

import mx.utils.LoaderUtil;

import org.openzoom.flash.descriptors.IImageSourceDescriptor;
import org.openzoom.flash.descriptors.IMultiScaleImageDescriptor;
import org.openzoom.flash.descriptors.IMultiScaleImageLevel;
import org.openzoom.flash.descriptors.ImageSourceDescriptor;
import org.openzoom.flash.descriptors.MultiScaleImageDescriptorBase;
import org.openzoom.flash.utils.math.clamp;

/**
 * OpenZoom Descriptor.
 * <a href="http://openzoom.org/specs/">http://openzoom.org/specs/</a>
 */
public class OpenZoomDescriptor extends MultiScaleImageDescriptorBase
                                implements IMultiScaleImageDescriptor
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

        this.uri = uri
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
        return IMultiScaleImageLevel(levels[level]).getTileURL(column, row)
    }

    /**
     * @inheritDoc
     */
    public function getLevelAt(index:int):IMultiScaleImageLevel
    {
        return IMultiScaleImageLevel(levels[index])
    }

    /**
     * @inheritDoc
     */
    public function getMinLevelForSize(width:Number,
                                       height:Number):IMultiScaleImageLevel
    {
        // TODO
        var level:IMultiScaleImageLevel

        for(var i:int = numLevels - 1; i >= 0; i--)
        {
            level = getLevelAt(i)
            if (level.width < width || level.height < height)
                break
        }

        // FIXME
        return getLevelAt(clamp(level.index + 1, 0, numLevels - 1)).clone()
    }

    /**
     * @inheritDoc
     */
    public function clone():IMultiScaleImageDescriptor
    {
        return new OpenZoomDescriptor(uri, data.copy())
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
        	var path:String = this.uri.substring(0, this.uri.lastIndexOf("/"))
        	var sourceUri:String = LoaderUtil.createAbsoluteURL(path, source.@uri)
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

        if (PyramidOrigin.isValid(pyramid.@origin))
            _origin = pyramid.@origin

        for (var index:int = 0; index < numLevels; index++)
        {
            var level:XML = data.pyramid.level[index]
            var uris:Array = []

            for each (var uri:XML in level.uri)
                uris.push(uri.@template.toString())

            levels[index] = new MultiScaleImageLevel(this,
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