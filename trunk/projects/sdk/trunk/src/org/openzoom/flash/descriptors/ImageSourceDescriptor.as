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
package org.openzoom.flash.descriptors
{

/**
 * Basic implementation of the IImageSourceDescriptor interface.
 */
public class ImageSourceDescriptor implements IImageSourceDescriptor
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function ImageSourceDescriptor(uri:String,
                                          width:uint,
                                          height:uint,
                                          type:String)
    {
        _uri = uri
        _width = width
        _height = height
        _type = type
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  width
    //----------------------------------

    private var _width:uint

    /**
     * @inheritDoc
     */
    public function get width():uint
    {
        return _width
    }

    //----------------------------------
    //  height
    //----------------------------------

    private var _height:uint

    /**
     * @inheritDoc
     */
    public function get height():uint
    {
        return _height
    }

    //----------------------------------
    //  uri
    //----------------------------------

    private var _uri:String

    /**
     * @inheritDoc
     */
    public function get uri():String
    {
        return _uri
    }

    //----------------------------------
    //  type
    //----------------------------------

    private var _type:String

    /**
     * @inheritDoc
     */
    public function get type():String
    {
        return _type
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     * @inheritDoc
     */
    public function clone():IImageSourceDescriptor
    {
        return new ImageSourceDescriptor(uri, width, height, type)
    }
}

}
