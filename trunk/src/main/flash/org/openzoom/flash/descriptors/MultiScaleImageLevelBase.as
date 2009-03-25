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
 * @private
 *
 * Base class for MultiScaleImageLevel.
 */
public class MultiScaleImageLevelBase
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function MultiScaleImageLevelBase( index:int,
                                              width:uint, height:uint,
                                              numColumns:uint, numRows:uint )
    {
        _index = index

        _width = width
        _height = height

        _numColumns = numColumns
        _numRows = numRows
    }


    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  index
    //----------------------------------

    private var _index:int

    /**
     * @copy org.openzoom.flash.descriptors.IMultiScaleImageLevel#index
     */
    public function get index():int
    {
        return _index
    }

    //----------------------------------
    //  width
    //----------------------------------

    private var _width:uint

    /**
     * @copy org.openzoom.flash.descriptors.IMultiScaleImageLevel#width
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
     * @copy org.openzoom.flash.descriptors.IMultiScaleImageLevel#height
     */
    public function get height():uint
    {
        return _height
    }

    //----------------------------------
    //  numColumns
    //----------------------------------

    private var _numColumns:uint

    /**
     * @copy org.openzoom.flash.descriptors.IMultiScaleImageLevel#numColumns
     */
    public function get numColumns():uint
    {
        return _numColumns
    }

    //----------------------------------
    //  numRows
    //----------------------------------

    private var _numRows:uint

    /**
     * @copy org.openzoom.flash.descriptors.IMultiScaleImageLevel#numRows
     */
    public function get numRows():uint
    {
        return _numRows
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Debug
    //
    //--------------------------------------------------------------------------

    /**
     * @inheritDoc
     */
    public function toString():String
    {
        return "index:" + index + "\n" +
               "width:" + width + "\n" +
               "height:" + height + "\n" +
               "numRows:" + numRows + "\n" +
               "numColumns:" + numColumns + "\n"
    }
}

}