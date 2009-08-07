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

import flash.geom.Rectangle;

/**
 * The MultiScaleImageLevel class represents a single level of a
 * multiscale image pyramid.
 * It is the default implementation of IMultiScaleImageLevel.
 */
public final class ImagePyramidLevel extends ImagePyramidLevelBase
                                     implements IImagePyramidLevel
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function ImagePyramidLevel(descriptor:IImagePyramidDescriptor,
                                      index:int,
                                      width:uint,
                                      height:uint,
                                      numColumns:int,
                                      numRows:int)
    {
        this.descriptor = descriptor
        super(index, width, height, numColumns, numRows)
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    private var descriptor:IImagePyramidDescriptor

    //--------------------------------------------------------------------------
    //
    //  Methods: IMultiScaleImageLevel
    //
    //--------------------------------------------------------------------------

    /**
     * @inheritDoc
     */
    public function getTileURL(column:int, row:int):String
    {
        return descriptor.getTileURL(index, column, row)
    }

    /**
     * @inheritDoc
     */
    public function getTileBounds(column:int, row:int):Rectangle
    {
        return descriptor.getTileBounds(index, column, row)
    }

    /**
     * @inheritDoc
     */
    public function clone():IImagePyramidLevel
    {
        return new ImagePyramidLevel(descriptor,
                                     index,
                                     width,
                                     height,
                                     numColumns,
                                     numRows)
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
        return "[ImagePyramidLevel]" + "\n" + super.toString()
    }
}

}
