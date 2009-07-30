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
package org.openzoom.flash.renderers.images
{

import flash.display.Graphics;
import flash.display.Shape;
import flash.geom.Rectangle;
import flash.utils.Dictionary;

import org.openzoom.flash.core.openzoom_internal;
import org.openzoom.flash.descriptors.IImagePyramidDescriptor;
import org.openzoom.flash.renderers.Renderer;
import org.openzoom.flash.utils.IDisposable;

/**
 * Image pyramid renderer.
 */
public final class ImagePyramidRenderer extends Renderer implements IDisposable
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function ImagePyramidRenderer()
    {
        openzoom_internal::tileLayer = new Shape()
        addChild(openzoom_internal::tileLayer)
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    public var ready:Boolean = false

    private var tileCache:Dictionary /* of ImagePyramidTile */ = new Dictionary()
    openzoom_internal var tileLayer:Shape

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  source
    //----------------------------------

    private var _source:*

    public function get source():*
    {
        return _source
    }

    public function set source(value:*):void
    {
        if (_source === value)
           return

        _source = value
    }

    //----------------------------------
    //  width
    //----------------------------------

    private var _width:Number = 0

    override public function get width():Number
    {
        return _width
    }

    override public function set width(value:Number):void
    {
        if (value === _width)
           return

        _width = value

        updateDisplayList()
    }

    //----------------------------------
    //  height
    //----------------------------------

    private var _height:Number = 0

    override public function get height():Number
    {
        return _height
    }

    override public function set height(value:Number):void
    {
        if (value === _height)
           return

        _height = value

        updateDisplayList()
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    private function updateDisplayList():void
    {
        var g:Graphics = graphics
        g.clear()
        g.beginFill(0x000000, 0)
        g.drawRect(0, 0, _width, _height)
        g.endFill()
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Internal
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    openzoom_internal function getTile(level:int, column:int, row:int):ImagePyramidTile
    {
        var descriptor:IImagePyramidDescriptor = _source as IImagePyramidDescriptor

        if (!descriptor)
           trace("[ImagePyramidRenderer] getTile: Source undefined")

        var tile:ImagePyramidTile = tileCache[ImagePyramidTile.getHashCode(level, column, row)]

        if (!tile)
        {
            var url:String = descriptor.getTileURL(level, column, row)
            var bounds:Rectangle = descriptor.getTileBounds(level, column, row)

            tile = new ImagePyramidTile(level, column, row, url, bounds)
            tileCache[tile.hashCode] = tile
        }

        return tile
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: IDisposable
    //
    //--------------------------------------------------------------------------
    
    public function dispose():void
    {
        tileCache = null
        ready = false
        removeChild(openzoom_internal::tileLayer)
        openzoom_internal::tileLayer = null
    }
}

}
