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

import org.openzoom.flash.descriptors.IImagePyramidLevel;
import org.openzoom.flash.descriptors.ImagePyramidLevelBase;
import org.openzoom.flash.utils.math.clamp;
import org.openzoom.flash.utils.uri.resolveURI;


/**
 * Represents a single level of a multiscale
 * image pyramid described by an OpenZoom descriptor.
 */
internal class MultiScaleImageLevel extends ImagePyramidLevelBase
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
    public function MultiScaleImageLevel(descriptor:OpenZoomDescriptor,
                                         index:int,
                                         width:uint,
                                         height:uint,
                                         numColumns:int,
                                         numRows:int,
                                         uris:Array,
                                         pyramidOrigin:String="topLeft")
    {
        this.descriptor = descriptor
        this.uris = uris
        this.pyramidOrigin = pyramidOrigin

        super(index, width, height, numColumns, numRows)
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var uris:Array /* of String */
    private var descriptor:OpenZoomDescriptor
    private var pyramidOrigin:String = PyramidOrigin.TOP_LEFT

    private static var uriIndex:int = 0

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
        if (uris && uris.length > 0)
        {
            uriIndex = clamp(uriIndex + 1, 0, uris.length - 1)
            var uri:String =  String(uris[uriIndex])

            var computedColumn:int
            var computedRow:int

            switch (pyramidOrigin)
            {
                case PyramidOrigin.TOP_LEFT:
                    computedColumn = column
                    computedRow = row
                    break

                case PyramidOrigin.TOP_RIGHT:
                    computedColumn = numColumns - column
                    computedRow = row
                    break

                case PyramidOrigin.BOTTOM_RIGHT:
                    computedColumn = numColumns - column
                    computedRow = numRows - row
                    break

                case PyramidOrigin.BOTTOM_LEFT:
                    computedColumn = column
                    computedRow = numRows - row
                    break
            }

            uri = uri.replace(/{column}/, computedColumn)
                     .replace(/{row}/, computedRow)

            return resolveURI(descriptor.source, uri)
        }

        return ""
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
        return new MultiScaleImageLevel(OpenZoomDescriptor(descriptor.clone()),
                                        index, width, height,
                                        numColumns, numRows, uris.slice())
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
        return "[OpenZoomLevel]" + "\n" + super.toString()
    }
}

}
