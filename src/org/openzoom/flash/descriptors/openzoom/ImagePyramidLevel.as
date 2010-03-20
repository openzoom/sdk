////////////////////////////////////////////////////////////////////////////////
//
//  OpenZoom SDK
//
//  Version: MPL 1.1/GPL 3/LGPL 3
//
//  The contents of this file are subject to the Mozilla Public License Version
//  1.1 (the "License"); you may not use this file except in compliance with
//  the License. You may obtain a copy of the License at
//  http://www.mozilla.org/MPL/
//
//  Software distributed under the License is distributed on an "AS IS" basis,
//  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
//  for the specific language governing rights and limitations under the
//  License.
//
//  The Original Code is the OpenZoom SDK.
//
//  The Initial Developer of the Original Code is Daniel Gasienica.
//  Portions created by the Initial Developer are Copyright (c) 2007-2010
//  the Initial Developer. All Rights Reserved.
//
//  Contributor(s):
//    Daniel Gasienica <daniel@gasienica.ch>
//
//  Alternatively, the contents of this file may be used under the terms of
//  either the GNU General Public License Version 3 or later (the "GPL"), or
//  the GNU Lesser General Public License Version 3 or later (the "LGPL"),
//  in which case the provisions of the GPL or the LGPL are applicable instead
//  of those above. If you wish to allow use of your version of this file only
//  under the terms of either the GPL or the LGPL, and not to allow others to
//  use your version of this file under the terms of the MPL, indicate your
//  decision by deleting the provisions above and replace them with the notice
//  and other provisions required by the GPL or the LGPL. If you do not delete
//  the provisions above, a recipient may use your version of this file under
//  the terms of any one of the MPL, the GPL or the LGPL.
//
////////////////////////////////////////////////////////////////////////////////
package org.openzoom.flash.descriptors.openzoom
{

import flash.geom.Rectangle;

import org.openzoom.flash.core.openzoom_internal;
import org.openzoom.flash.descriptors.IImagePyramidLevel;
import org.openzoom.flash.descriptors.ImagePyramidLevelBase;
import org.openzoom.flash.utils.math.clamp;
import org.openzoom.flash.utils.uri.resolveURI;

use namespace openzoom_internal;

/**
 * Represents a single level of a multiscale
 * image pyramid described by an OpenZoom descriptor.
 */
internal final class ImagePyramidLevel extends ImagePyramidLevelBase
                                       implements IImagePyramidLevel
{
	include "../../core/Version.as"

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function ImagePyramidLevel(descriptor:OpenZoomDescriptor,
                                      source:String,
                                      index:int,
                                      width:uint,
                                      height:uint,
                                      numColumns:int,
                                      numRows:int,
                                      uris:Array,
                                      pyramidOrigin:String="topLeft")
    {
        this.descriptor = descriptor
        this.source = source
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
    private var pyramidOrigin:String = ImagePyramidOrigin.TOP_LEFT

    private var source:String

    private static var uriIndex:int = 0

    //--------------------------------------------------------------------------
    //
    //  Methods: IImagePyramidLevel
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
                case ImagePyramidOrigin.TOP_LEFT:
                    computedColumn = column
                    computedRow = row
                    break

                case ImagePyramidOrigin.TOP_RIGHT:
                    computedColumn = numColumns - column
                    computedRow = row
                    break

                case ImagePyramidOrigin.BOTTOM_RIGHT:
                    computedColumn = numColumns - column
                    computedRow = numRows - row
                    break

                case ImagePyramidOrigin.BOTTOM_LEFT:
                    computedColumn = column
                    computedRow = numRows - row
                    break
            }

            uri = uri.replace(/{column}/, computedColumn)
                     .replace(/{row}/, computedRow)

            return resolveURI(source, uri)
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
        return new ImagePyramidLevel(OpenZoomDescriptor(descriptor.clone()),
                                     source, index, width, height,
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
        return "[ImagePyramidLevel]" + "\n" + super.toString()
    }
}

}
